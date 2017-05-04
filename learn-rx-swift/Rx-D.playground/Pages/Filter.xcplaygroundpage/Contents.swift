//: [Previous](@previous)

import Foundation
import RxSwift
import XCPlayground

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

exampleOf(desc: "distinctUntilChanged") {
    let disposeBag = DisposeBag()
    
    let searchString = BehaviorSubject
    searchString
        .map { $0.lowercased() }
        .distinctUntilChanged()
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)
    searchString.value = "apple"
    searchString.value = "APPLE"
    searchString.value = "Google"
    searchString.value = "GOOGLE"
}

//: [Next](@next)
