//: [Previous](@previous)

import UIKit
import RxSwift

let disposeBag = DisposeBag()

extension ObservableType {
    func addObserver(_ id: String) -> Disposable {
        return subscribe {
            print("Subscription: ", id, "Event", $0)
        }
    }
}

extension Disposable {
    func disposed(by bag: DisposeBag) {
        bag.insert(self)
    }
}
print("// StartWith-----------------------------")
//: startWith
Observable.of("1", "2", "3", "4")
    .startWith("1")
    .startWith("5")
    .startWith("3","4","5")
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

print("\n// Merge-----------------------------")
//: Merge
let subject1 = PublishSubject<String>()
let subject2 = PublishSubject<String>()

Observable.of(subject1, subject2)
    .merge()
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

subject1.onNext("1")
subject2.onNext("2")
subject1.onNext("A")
subject2.onNext("B")
subject1.onNext("12")
subject2.onNext("3")

print("\n// zip--------------------------------")
Observable.zip(subject1, subject2) { (element1, element2) in
    "\(element1)  \(element2)"
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
subject1.onNext("1")
subject2.onNext("2")
subject1.onNext("A")
subject2.onNext("B")
subject1.onNext("12")
subject2.onNext("3")

print("\n// combileLatest--------------------------------")
Observable.combineLatest(subject1, subject2) { (element1, element2) in
    "\(element1)  \(element2)"
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
subject1.onNext("1-1")
subject1.onNext("1-A")
subject2.onNext("2-B")
subject2.onNext("2-4")
subject1.onNext("1-3")

print("\n combileLatest----------------------------------")
let stringObservable = Observable.just("❤️")
let fruitObservable = Observable.from(["🍎", "🍐", "🍊"])
let animalObservable = Observable.of("🐶", "🐱", "🐭", "🐹")

Observable.combineLatest([stringObservable, fruitObservable, animalObservable]) { (element) in
    "\(element)"
    }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

//: SwitchLatest
let switchSubject1 = BehaviorSubject(value: "⚽️")
let switchSubject2 = BehaviorSubject(value: "🍎")
let variable = Variable(switchSubject1)

variable.asObservable()
    .switchLatest()
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)
switchSubject1.onNext("🏈")
switchSubject2.onNext("🏀")

variable.value = switchSubject2

switchSubject2.onNext("⚾️")
switchSubject1.onNext("H") // 不会打印出来，此时 variable de value 已经switch到switchSubject2了

switchSubject2.onNext("🍐")
//: [Next](@next)

















