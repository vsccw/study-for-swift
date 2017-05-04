//: [Previous](@previous)

import UIKit
import RxSwift
import RxCocoa
import PlaygroundSupport

var str = "Hello, playground"

let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 128, height: 128))
PlaygroundPage.current.liveView = imageView

let swiftImage = UIImage.init(named: "swift")
let swiftImageData = UIImagePNGRepresentation(swiftImage!)

let imageData = PublishSubject<Data>()
let disposeBag = DisposeBag()

imageData
    .observeOn(ConcurrentDispatchQueueScheduler.init(qos: .background))
    .map {
        UIImage.init(data: $0)
    }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: {
        imageView.image = $0
    })
    .addDisposableTo(disposeBag)

imageData.onNext(swiftImageData!)


//: [Next](@next)
