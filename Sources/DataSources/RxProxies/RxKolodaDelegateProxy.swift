//
//  RxKolodaViewDelegateProxy.swift
//  RxKoloda
//
//  Created by Le Phi Hung on 10/24/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//

import Foundation
import Koloda
import RxSwift
import RxCocoa

extension KolodaView: HasDelegate {
    public typealias Delegate = KolodaViewDelegate
}

final class RxKolodaViewDelegateProxy: DelegateProxy<KolodaView, KolodaViewDelegate>, DelegateProxyType, KolodaViewDelegate {

    /// Typed parent object.
    public weak private(set) var kolodaView: KolodaView?

    /// Init
    public init(kolodaView: KolodaView) {
        self.kolodaView = kolodaView
        super.init(parentObject: kolodaView, delegateProxy: RxKolodaViewDelegateProxy.self)
    }

    public static func registerKnownImplementations() {
        self.register { RxKolodaViewDelegateProxy(kolodaView: $0) }
    }
}

public extension Reactive where Base: KolodaView {

    var delegate: DelegateProxy<KolodaView, KolodaViewDelegate> {
        return RxKolodaViewDelegateProxy.proxy(for: base)
    }

//    var didSwipeCart: ControlEvent<(at: Int, direction: SwipeResultDirection)> {
//    let source = self.delegate.methodInvoked(#selector(KolodaViewDelegate.koloda(_:didSwipeCardAt:in:)))
//            .map { a in
//              return try castOrThrow((at: Int,direction: SwipeResultDirection).self, a[1])
//        }
//
//        return ControlEvent(events: source)
//    }


}
