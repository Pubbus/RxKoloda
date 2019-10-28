# RxKoloda
A reactive wrapper built around [Yalantis/Koloda](https://github.com/Yalantis/Koloda)

## Installation
### CocoaPods
- Creating a pod spec. Not too long.

### Carthage

To integrate RxParchmentDataSources into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "Pubbus/RxKoloda"
```

# Usage
Working with RxKoloda datasource will be very simple:

```swift
let items = Observable.of([UIImage(named: "A"), UIImage(named: "B"), UIImage(named: "C")])

items.bind(to: kolodaView.rx.items) { (kolodaView: KolodaView, index: Int, image: UIImage?)
        -> (view: UIView, overlay: OverlayView) in
   return (view: UIImageView(image: image), overlay: OverlayView())
}.disposed(by: disposeBag)
```
