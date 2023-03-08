//
//  RxSwipeCardStackDelegateProxy.swift
//  AcrosticPoem_ios
//
//  Created by Supermove on 2023/03/06.
//  Copyright © 2023 Minestrone. All rights reserved.
//

import RxSwift
import RxCocoa
import Shuffle_iOS

#if os(iOS) || os(tvOS)

extension SwipeCardStack: HasDelegate {
    public typealias delegate = SwipeCardStackDelegate
}

/// For more information take a look at `DelegateProxyType`.
open class RxSwipeCardStackDelegateProxy
: DelegateProxy<SwipeCardStack, SwipeCardStackDelegate>
, DelegateProxyType {
    
    /// Typed parent object.
    public weak private(set) var swipeCardView: SwipeCardStack?
    
    /// - parameter tableView: Parent object for delegate proxy.
    public init(swipeCardView: SwipeCardStack) {
        self.swipeCardView = swipeCardView
        super.init(parentObject: swipeCardView, delegateProxy: RxSwipeCardStackDelegateProxy.self)
    }
    
    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxSwipeCardStackDelegateProxy(swipeCardView: $0) }
    }
}

#endif

