//
//  RxKolodaViewReactiveArrayDataSource.swift
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

// objc monkey business
class _RxKolodaViewReactiveArrayDataSource
    : NSObject
, KolodaViewDataSource {

  func _kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return 0
  }

  func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return _kolodaNumberOfCards(koloda)
  }

  func _koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    return UIView()
  }

  func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    return _koloda(koloda, viewForCardAt: index)
  }

  func _koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return OverlayView()
  }

  func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return _koloda(koloda, viewForCardOverlayAt: index)
  }

  func _kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return .default
  }

  func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return _kolodaSpeedThatCardShouldDrag(koloda)
  }
}


class RxKolodaViewReactiveArrayDataSourceSequenceWrapper<Sequence: Swift.Sequence>
    : RxKolodaViewReactiveArrayDataSource<Sequence.Element>
, RxKolodaViewDataSourceType {

    typealias Element = Sequence

  override init(dragSpeed: DragSpeed = .default,kolodaFactory: @escaping KolodaFactory) {
      super.init(dragSpeed: dragSpeed, kolodaFactory: kolodaFactory)
    }

  func kolodaView(_ koloda: KolodaView, observedEvent: Event<Sequence>) {
    Binder(self) { kolodaViewDataSource, sectionModels in
           let sections = Array(sectionModels)
         kolodaViewDataSource.kolodaView(koloda, observedElements: sections)
       }.on(observedEvent)
  }
}

// Please take a look at `DelegateProxyType.swift`
class RxKolodaViewReactiveArrayDataSource<Element>
    : _RxKolodaViewReactiveArrayDataSource
    , SectionedViewDataSourceType {
  typealias KolodaFactory = (KolodaView, Int, Element) -> (view: UIView, overlay: OverlayView)

  var itemModels: [Element]?
  var dragSpeed: DragSpeed = .default

  func modelAtIndex(_ index: Int) -> Element? {
    return itemModels?[index]
  }

  func model(at indexPath: IndexPath) throws -> Any {
    precondition(indexPath.section == 0)
    guard let item = itemModels?[indexPath.item] else {
      throw RxCocoaError.itemsNotYetBound(object: self)
    }
    return item
  }

  let kolodaFactory: KolodaFactory

  init(dragSpeed: DragSpeed = .default, kolodaFactory: @escaping KolodaFactory) {
    self.kolodaFactory = kolodaFactory
    self.dragSpeed = dragSpeed
  }

  override func _kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
    return itemModels?.count ?? 0
  }

  override func _koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
    return kolodaFactory(koloda, index, itemModels![index]).view
  }

  override func _koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
    return kolodaFactory(koloda, index, itemModels![index]).overlay
  }

  override func _kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
    return dragSpeed
  }

  // reactive
  func kolodaView(_ koloda: KolodaView, observedElements: [Element]) {
    self.itemModels = observedElements

    koloda.reloadData()
  }
}

#endif
