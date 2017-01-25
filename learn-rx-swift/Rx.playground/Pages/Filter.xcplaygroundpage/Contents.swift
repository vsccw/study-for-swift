//: [Previous](@previous)

import Foundation
import RxSwift

let disposeBag = DisposeBag()

Observable.of("🐰", "🐶", "🐸", "🐷", "🐵")
    .single()
    .subscribe(onNext: { print($0) }, onError: { print($0) }, onCompleted: { print($0) })
    .addDisposableTo(disposeBag)

print("------")

Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
    .single { $0 == "🐸" }
    .subscribe { print($0) }
    .addDisposableTo(disposeBag)

Observable.of("🐱", "🐰", "🐶", "🐱", "🐰", "🐶")
    .single { $0 == "🐰" }
    .subscribe { print($0) }
    .addDisposableTo(disposeBag)

Observable.of("🐱", "🐰", "🐶", "🐸", "🐷", "🐵")
    .single { $0 == "🔵" }
    .subscribe { print($0) }
    .addDisposableTo(disposeBag)
//: [Next](@next)
