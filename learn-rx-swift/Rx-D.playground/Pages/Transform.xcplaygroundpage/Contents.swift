//: [Previous](@previous)

import UIKit
import RxSwift

let disposeBag = DisposeBag()

Observable.of("10", "100", "1000")
    .scan("2") { (aggregateValue, newValue) in
        "\(aggregateValue) --- \(newValue)"
    }
    .subscribe(onNext: { print($0) })
    .addDisposableTo(disposeBag)












//: [Next](@next)
