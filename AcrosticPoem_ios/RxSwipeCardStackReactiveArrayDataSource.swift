//
//  RxSwipeCardStackReactiveArrayDataSource.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/06.
//  Copyright © 2023 Minestrone. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
import RxCocoa
import Shuffle_iOS

// objc monkey business
class _RxSwipeCardStackReactiveArrayDataSource
    : NSObject
    , SwipeCardStackDataSource {

    func _numberOfCards(in cardStack: SwipeCardStack) -> Int {
        0
    }
   
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int {
        _numberOfCards(in: cardStack)
    }

    fileprivate func _cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        fatalError()
    }
    
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        _cardStack(cardStack, cardForIndexAt: index)
    }
}


class RxSwipeCardStackReactiveArrayDataSourceSequenceWrapper<Sequence: Swift.Sequence>
    : RxSwipeCardStackReactiveArrayDataSource<Sequence.Element>
    , RxSwipeCardStackDataSourceType {
    typealias Element = Sequence

    override init(cellFactory: @escaping CellFactory) {
        super.init(cellFactory: cellFactory)
    }

    func swipeCardView(_ cardStack: SwipeCardStack, observedEvent: Event<Sequence>) {
        Binder(self) { cardStackDataSource, sectionModels in
            let sections = Array(sectionModels)
            cardStackDataSource.cardStackView(cardStack, observedElements: sections)
        }.on(observedEvent)
    }
}

// Please take a look at `DelegateProxyType.swift`
class RxSwipeCardStackReactiveArrayDataSource<Element>
    : _RxSwipeCardStackReactiveArrayDataSource
    , SwipeCardSectionedViewDataSourceType {
    typealias CellFactory = (SwipeCardStack, Int, Element) -> SwipeCard
    
    var itemModels: [Element]?
    
    func modelAtIndex(_ index: Int) -> Element? {
        itemModels?[index]
    }

    func model(at index: Int) throws -> Any {
        guard let item = itemModels?[index] else {
            throw RxCocoaError.itemsNotYetBound(object: self)
        }
        return item
    }

    let cellFactory: CellFactory
    
    init(cellFactory: @escaping CellFactory) {
        self.cellFactory = cellFactory
    }
    
        override func _numberOfCards(in cardStack: SwipeCardStack) -> Int {
        itemModels?.count ?? 0
    }
    
        override func _cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        cellFactory(cardStack, index, itemModels![index])
    }
    
    // reactive
        
        func cardStackView(_ cardStack: Shuffle_iOS.SwipeCardStack, observedElements: [Element]) {
            self.itemModels = observedElements
            
            cardStack.reloadData()
        }
    
}

#endif
/// Data source with access to underlying sectioned model.
public protocol SwipeCardSectionedViewDataSourceType {
    /// Returns model at index path.
    ///
    /// In case data source doesn't contain any sections when this method is being called, `RxCocoaError.ItemsNotYetBound(object: self)` is thrown.

    /// - parameter indexPath: Model index path
    /// - returns: Model at index path.
    func model(at index: Int) throws -> Any
}
