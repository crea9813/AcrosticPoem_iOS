//
//  RxSwipeCardStackDataSourceProxy.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/06.
//  Copyright © 2023 Minestrone. All rights reserved.
//

#if os(iOS) || os(tvOS)

import Shuffle_iOS
import RxSwift
import RxCocoa
import UIKit
    
extension SwipeCardStack: HasDataSource {
    public typealias DataSource = SwipeCardStackDataSource
}

@MainActor
private let swipeCardViewDataSourceNotSet = SwipeCardStackDataSourceNotSet()

private final class SwipeCardStackDataSourceNotSet : NSObject, SwipeCardStackDataSource {
    func cardStack(_ cardStack: Shuffle_iOS.SwipeCardStack, cardForIndexAt index: Int) -> Shuffle_iOS.SwipeCard {
        fatalError("dataSourceNotSet")
    }
    
    func numberOfCards(in cardStack: Shuffle_iOS.SwipeCardStack) -> Int {
        0
    }
}

/// For more information take a look at `DelegateProxyType`.
open class RxSwipeCardStackDataSourceProxy
    : DelegateProxy<SwipeCardStack, SwipeCardStackDataSource>
    , DelegateProxyType {

    /// Typed parent object.
    public weak private(set) var swipeCardView: SwipeCardStack?

    /// - parameter tableView: Parent object for delegate proxy.
    public init(swipeCardView: SwipeCardStack) {
        self.swipeCardView = swipeCardView
        super.init(parentObject: swipeCardView, delegateProxy: RxSwipeCardStackDataSourceProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxSwipeCardStackDataSourceProxy(swipeCardView: $0) }
    }

    private weak var _requiredMethodsDataSource: SwipeCardStackDataSource? = swipeCardViewDataSourceNotSet

    /// For more information take a look at `DelegateProxyType`.
    open override func setForwardToDelegate(_ forwardToDelegate: SwipeCardStackDataSource?, retainDelegate: Bool) {
        _requiredMethodsDataSource = forwardToDelegate  ?? swipeCardViewDataSourceNotSet
        super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
    }
}

extension RxSwipeCardStackDataSourceProxy: SwipeCardStackDataSource {
    
    /// Required delegate method implementation.
    public func cardStack(_ cardStack: SwipeCardStack, cardForIndexAt index: Int) -> SwipeCard {
        (_requiredMethodsDataSource ?? swipeCardViewDataSourceNotSet).cardStack(cardStack, cardForIndexAt: index)
    }
    
    /// Required delegate method implementation.
    public func numberOfCards(in cardStack: SwipeCardStack) -> Int {
        (_requiredMethodsDataSource ?? swipeCardViewDataSourceNotSet).numberOfCards(in: cardStack)
    }
}

#endif
