//
//  RxKolodaDataSourceProxy.swift
//  RxKoloda
//
//  Created by Le Phi Hung on 10/24/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//

#if os(iOS) || os(tvOS)

import UIKit
import RxSwift
import Koloda
import RxCocoa

let dataSourceNotSet = "DataSource not set"
let delegateNotSet = "Delegate not set"


extension KolodaView: HasDataSource{
    public typealias DataSource = KolodaViewDataSource
}

private let kolodaViewDataSourceNotSet = KolodaViewDataSourceNotSet()

private final class KolodaViewDataSourceNotSet
    : NSObject
    , KolodaViewDataSource {

  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return 0
  }

  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    rxAbstractMethod(message: dataSourceNotSet)
  }

  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    rxAbstractMethod(message: dataSourceNotSet)
  }

  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .default
  }
}
/// For more information take a look at `DelegateProxyType`.
open class RxKolodaViewDataSourceProxy
    : DelegateProxy<KolodaView, KolodaViewDataSource>
    , DelegateProxyType
, KolodaViewDataSource {


    /// Typed parent object.
    public weak private(set) var kolodaView: KolodaView?

    /// - parameter tableView: Parent object for delegate proxy.
    public init(kolodaView: KolodaView) {
        self.kolodaView = kolodaView
        super.init(parentObject: kolodaView, delegateProxy: RxKolodaViewDataSourceProxy.self)
    }

    // Register known implementations
    public static func registerKnownImplementations() {
        self.register { RxKolodaViewDataSourceProxy(kolodaView: $0) }
    }

    private weak var _requiredMethodsDataSource: KolodaViewDataSource? = kolodaViewDataSourceNotSet

    // MARK: delegate
  public func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return (_requiredMethodsDataSource ?? kolodaViewDataSourceNotSet).kolodaNumberOfCards(koloda)
  }

  public func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    return (_requiredMethodsDataSource ?? kolodaViewDataSourceNotSet).koloda(koloda, viewForCardAt: index)
  }

  public func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return (_requiredMethodsDataSource ?? kolodaViewDataSourceNotSet).koloda(koloda, viewForCardOverlayAt: index)
  }

  public func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return (_requiredMethodsDataSource ?? kolodaViewDataSourceNotSet).kolodaSpeedThatCardShouldDrag(koloda)
  }

  /// For more information take a look at `DelegateProxyType`.
  open override func setForwardToDelegate(_ forwardToDelegate: KolodaViewDataSource?, retainDelegate: Bool) {
    _requiredMethodsDataSource = forwardToDelegate  ?? kolodaViewDataSourceNotSet
    super.setForwardToDelegate(forwardToDelegate, retainDelegate: retainDelegate)
  }

}
#endif
