//
//  KolodaView+Rx.swift
//  RxKoloda
//
//  Created by Le Phi Hung on 10/24/19.
//  Copyright © 2019 Pubbus. All rights reserved.
//

import RxSwift
import RxCocoa
import Koloda

public extension Reactive where Base: KolodaView {
  func items<Sequence: Swift.Sequence, Source: ObservableType>
      (_ source: Source)
      -> (_ pagingFactory: @escaping (KolodaView, Int, Sequence.Element) -> (UIView, OverlayView))
      -> Disposable
      where Source.Element == Sequence {
          return { kolodaFactory in
              let dataSource = RxKolodaViewReactiveArrayDataSourceSequenceWrapper<Sequence>(kolodaFactory: kolodaFactory)
              return self.items(dataSource: dataSource)(source)
          }
  }

  func items<DataSource: RxKolodaViewDataSourceType & KolodaViewDataSource, O: ObservableType>(dataSource: DataSource)
      -> (_ source: O)
    -> Disposable where DataSource.Element == O.Element {
          return { source in

              let subscription = source
                  .subscribeProxyDataSource(ofObject: self.base, dataSource: dataSource, retainDataSource: true) { [weak kolodaView = self.base] (_: RxKolodaViewDataSourceProxy, event) -> Void in
                  guard let kolodaView = kolodaView else { return }
                    dataSource.kolodaView(kolodaView, observedEvent: event)
              }
              return Disposables.create {
                  subscription.dispose()
              }
          }
  }
}
extension Reactive where Base: KolodaView {
    /**
     Reactive wrapper for `dataSource`.
     For more information take a look at `DelegateProxyType` protocol documentation.
     */
    public var dataSource: DelegateProxy<KolodaView, KolodaViewDataSource> {
        return RxKolodaViewDataSourceProxy.proxy(for: base)
    }

    /**
     Installs data source as forwarding delegate on `rx.dataSource`.
     Data source won't be retained.
     It enables using normal delegate mechanism with reactive delegate mechanism.
     - parameter dataSource: Data source object.
     - returns: Disposable object that can be used to unbind the data source.
     */
    public func setDataSource(_ dataSource: KolodaViewDataSource)
        -> Disposable {
            return RxKolodaViewDataSourceProxy.installForwardDelegate(dataSource, retainDelegate: false, onProxyForObject: self.base)
    }
}

