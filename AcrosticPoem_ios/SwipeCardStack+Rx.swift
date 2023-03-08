//
//  SwipeCardStack+Rx.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/06.
//  Copyright © 2023 Minestrone. All rights reserved.
//

#if os(iOS) || os(tvOS)

import RxSwift
import RxCocoa
import UIKit
import Shuffle_iOS

/// Marks data source as `UITableView` reactive data source enabling it to be used with one of the `bindTo` methods.
public protocol RxSwipeCardStackDataSourceType /*: UITableViewDataSource*/ {
    
    /// Type of elements that can be bound to table view.
    associatedtype Element
    
    /// New observable sequence event observed.
    ///
    /// - parameter tableView: Bound table view.
    /// - parameter observedEvent: Event
    func swipeCardView(_ swipeCardStack: SwipeCardStack, observedEvent: Event<Element>)
}


// Items

extension Reactive where Base: SwipeCardStack {

    /**
    Binds sequences of elements to table view rows.
    
    - parameter source: Observable sequence of items.
    - parameter cellFactory: Transform between sequence elements and view cells.
    - returns: Disposable object that can be used to unbind.
     
     Example:
    
         let items = Observable.just([
             "First Item",
             "Second Item",
             "Third Item"
         ])

         items
         .bind(to: tableView.rx.items) { (tableView, row, element) in
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
             cell.textLabel?.text = "\(element) @ row \(row)"
             return cell
         }
         .disposed(by: disposeBag)

     */
    public func items<Sequence: Swift.Sequence, Source: ObservableType>
        (_ source: Source)
        -> (_ cellFactory: @escaping (SwipeCardStack, Int, Sequence.Element) -> SwipeCard)
        -> Disposable
        where Source.Element == Sequence {
            return { cellFactory in
                let dataSource = RxSwipeCardStackReactiveArrayDataSourceSequenceWrapper<Sequence>(cellFactory: cellFactory)
                return self.items(dataSource: dataSource)(source)
            }
    }

    /**
    Binds sequences of elements to table view rows.
    
    - parameter cellIdentifier: Identifier used to dequeue cells.
    - parameter source: Observable sequence of items.
    - parameter configureCell: Transform between sequence elements and view cells.
    - parameter cellType: Type of table view cell.
    - returns: Disposable object that can be used to unbind.
     
     Example:

         let items = Observable.just([
             "First Item",
             "Second Item",
             "Third Item"
         ])

         items
             .bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element) @ row \(row)"
             }
             .disposed(by: disposeBag)
    */
    public func items<Sequence: Swift.Sequence, Cell: SwipeCard, Source: ObservableType>
        (cellIdentifier: String, cellType: Cell.Type = Cell.self)
        -> (_ source: Source)
        -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
        -> Disposable
        where Source.Element == Sequence {
        return { source in
            return { configureCell in
                let dataSource = RxSwipeCardStackReactiveArrayDataSourceSequenceWrapper<Sequence> { tv, i, item in
                    
                    let cell = tv.card(forIndexAt: i) as! Cell
                    configureCell(i, item, cell)
                    return cell
                }
                return self.items(dataSource: dataSource)(source)
            }
        }
    }


    /**
    Binds sequences of elements to table view rows using a custom reactive data used to perform the transformation.
    This method will retain the data source for as long as the subscription isn't disposed (result `Disposable`
    being disposed).
    In case `source` observable sequence terminates successfully, the data source will present latest element
    until the subscription isn't disposed.
    
    - parameter dataSource: Data source used to transform elements to view cells.
    - parameter source: Observable sequence of items.
    - returns: Disposable object that can be used to unbind.
    */
    public func items<
            DataSource: RxSwipeCardStackDataSourceType & SwipeCardStackDataSource,
            Source: ObservableType>
        (dataSource: DataSource)
        -> (_ source: Source)
        -> Disposable
        where DataSource.Element == Source.Element {
        return { source in
            // This is called for sideeffects only, and to make sure delegate proxy is in place when
            // data source is being bound.
            // This is needed because theoretically the data source subscription itself might
            // call `self.rx.delegate`. If that happens, it might cause weird side effects since
            // setting data source will set delegate, and UITableView might get into a weird state.
            // Therefore it's better to set delegate proxy first, just to be sure.
            _ = self.delegate
            // Strong reference is needed because data source is in use until result subscription is disposed
            return source.subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource as SwipeCardStackDataSource, retainDataSource: true) {
                [weak swipeCardStack = self.base] (_: RxSwipeCardStackDataSourceProxy, event) -> Void in
                    guard let swipeCardStack = swipeCardStack else {
                        return
                    }
                    
                    dataSource.swipeCardView(swipeCardStack, observedEvent: event)
            }
        }
    }

}

extension Reactive where Base: SwipeCardStack {
    /**
    Reactive wrapper for `dataSource`.
    
    For more information take a look at `DelegateProxyType` protocol documentation.
    */
    public var dataSource: DelegateProxy<SwipeCardStack, SwipeCardStackDataSource> {
        return RxSwipeCardStackDataSourceProxy.proxy(for: base)
    }
    
    public var delegate: DelegateProxy<SwipeCardStack, SwipeCardStackDelegate> {
        return RxSwipeCardStackDelegateProxy.proxy(for: base)
    }
   
    /**
    Installs data source as forwarding delegate on `rx.dataSource`.
    Data source won't be retained.
    
    It enables using normal delegate mechanism with reactive delegate mechanism.
     
    - parameter dataSource: Data source object.
    - returns: Disposable object that can be used to unbind the data source.
    */
    public func setDataSource(_ dataSource: SwipeCardStackDataSource)
        -> Disposable {
        return RxSwipeCardStackDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
    }
    
    // events
    
    /**
    Reactive wrapper for `delegate` message `cardStack:didSelectCardAt:`.
    */
    public var itemSelected: ControlEvent<Int> {
        let source = self.delegate.methodInvoked(#selector(SwipeCardStackDelegate.cardStack(_:didSelectCardAt:)))
            .map { a in
                return try castOrThrow(Int.self, a[1])
            }

        return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `cardStack:didUndoCardAt:`.
     */
    public var itemSwiped: ControlEvent<Int> {
        let source = self.delegate.methodInvoked(#selector(SwipeCardStackDelegate.cardStack(_:didSwipeCardAt:with:)))
            .map { a in
                return try castOrThrow(Int.self, a[1])
            }

        return ControlEvent(events: source)
    }

    /**
     Reactive wrapper for `delegate` message `cardStack:didUndoCardAt:`.
     */
    public var itemUndid: ControlEvent<Int> {
        let source = self.delegate.methodInvoked(#selector(SwipeCardStackDelegate.cardStack(_:didUndoCardAt:from:)))
            .map { a in
                return try castOrThrow(Int.self, a[1])
            }

        return ControlEvent(events: source)
    }
    
    /**
     Reactive wrapper for `delegate` message `didSwipeAllCards:`.
     */
    public var itemEnded: ControlEvent<SwipeCardStack> {
        let source = self.delegate.methodInvoked(#selector(SwipeCardStackDelegate.didSwipeAllCards(_:)))
            .map { a in
                return try castOrThrow(SwipeCardStack.self, a[1])
            }

        return ControlEvent(events: source)
    }
    
    /**
    Reactive wrapper for `delegate` message `tableView:didSelectRowAtIndexPath:`.
    
    It can be only used when one of the `rx.itemsWith*` methods is used to bind observable sequence,
    or any other data source conforming to `SectionedViewDataSourceType` protocol.
    
     ```
        tableView.rx.modelSelected(MyModel.self)
            .map { ...
     ```
    */
    public func modelSelected<T>(_ modelType: T.Type) -> ControlEvent<T> {
        let source: Observable<T> = self.itemSelected.flatMap { [weak view = self.base as SwipeCardStack] index -> Observable<T> in
            guard let view = view else {
                return Observable.empty()
            }

            return Observable.just(try view.rx.model(at: index))
        }
        
        return ControlEvent(events: source)
    }

    /**
     Synchronous helper method for retrieving a model at indexPath through a reactive data source.
     */
    public func model<T>(at index: Int) throws -> T {
        let dataSource: SwipeCardSectionedViewDataSourceType = castOrFatalError(self.dataSource.forwardToDelegate(), message: "This method only works in case one of the `rx.items*` methods was used.")
        
        let element = try dataSource.model(at: index)

        return castOrFatalError(element)
    }
}

#endif

#if os(tvOS)
    
    extension Reactive where Base: UITableView {
        
        /**
         Reactive wrapper for `delegate` message `tableView:didUpdateFocusInContext:withAnimationCoordinator:`.
         */
        public var didUpdateFocusInContextWithAnimationCoordinator: ControlEvent<(context: UITableViewFocusUpdateContext, animationCoordinator: UIFocusAnimationCoordinator)> {
            
            let source = delegate.methodInvoked(#selector(UITableViewDelegate.tableView(_:didUpdateFocusIn:with:)))
                .map { a -> (context: UITableViewFocusUpdateContext, animationCoordinator: UIFocusAnimationCoordinator) in
                    let context = try castOrThrow(UITableViewFocusUpdateContext.self, a[1])
                    let animationCoordinator = try castOrThrow(UIFocusAnimationCoordinator.self, a[2])
                    return (context: context, animationCoordinator: animationCoordinator)
            }
            
            return ControlEvent(events: source)
        }
    }
#endif

func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
    guard let returnValue = object as? T else {
        throw RxCocoaError.castingError(object: object, targetType: resultType)
    }

    return returnValue
}

func castOrFatalError<T>(_ value: AnyObject!, message: String) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError(message)
    }
    
    return result
}


func castOrFatalError<T>(_ value: Any!) -> T {
    let maybeResult: T? = value as? T
    guard let result = maybeResult else {
        fatalError("Failure converting from \(String(describing: value)) to \(T.self)")
    }
    
    return result
}

#if os(iOS) || os(tvOS)
    import UIKit

extension ObservableType {
    func subscribeProxyDataSource<DelegateProxy: DelegateProxyType>(ofObject object: DelegateProxy.ParentObject, dataSource: DelegateProxy.Delegate, retainDataSource: Bool, binding: @escaping (DelegateProxy, Event<Element>) -> Void)
        -> Disposable
        where DelegateProxy.ParentObject: UIView
        , DelegateProxy.Delegate: AnyObject {
        let proxy = DelegateProxy.proxy(for: object)
        let unregisterDelegate = DelegateProxy.installForwardDelegate(dataSource, retainDelegate: retainDataSource, onProxyForObject: object)

        // Do not perform layoutIfNeeded if the object is still not in the view hierarchy
        if object.window != nil {
            // this is needed to flush any delayed old state (https://github.com/RxSwiftCommunity/RxDataSources/pull/75)
            object.layoutIfNeeded()
        }

        let subscription = self.asObservable()
            .observe(on:MainScheduler())
            .catch { error in
                bindingError(error)
                return Observable.empty()
            }
            // source can never end, otherwise it would release the subscriber, and deallocate the data source
            .concat(Observable.never())
            .take(until: object.rx.deallocated)
            .subscribe { [weak object] (event: Event<Element>) in

                if let object = object {
                    assert(proxy === DelegateProxy.currentDelegate(for: object), "Proxy changed from the time it was first set.\nOriginal: \(proxy)\nExisting: \(String(describing: DelegateProxy.currentDelegate(for: object)))")
                }
                
                binding(proxy, event)
                
                switch event {
                case .error(let error):
                    bindingError(error)
                    unregisterDelegate.dispose()
                case .completed:
                    unregisterDelegate.dispose()
                default:
                    break
                }
            }
            
        return Disposables.create { [weak object] in
            subscription.dispose()

            if object?.window != nil {
                object?.layoutIfNeeded()
            }

            unregisterDelegate.dispose()
        }
    }
}

#endif

func bindingError(_ error: Swift.Error) {
    let error = "Binding error: \(error)"
#if DEBUG
    fatalError(error)
#else
    print(error)
#endif
}
