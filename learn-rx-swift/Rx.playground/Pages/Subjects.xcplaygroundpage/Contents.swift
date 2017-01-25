//: Playground - noun: a place where people can play

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

print("\n//--------------------------------------------")
//:> PublishSubject: 在订阅时向（订阅之前的）所有观察者广播新事件
let subject = PublishSubject<String>()
//subject.add
subject.addObserver("1").disposed(by: disposeBag)
subject.onNext("AÀ")
subject.onNext("BɃ")

subject.addObserver("2").disposed(by: disposeBag)
subject.onNext("CC")
subject.onNext("DD")

print("\n//ReplaySubject--------------------------------------------")
//:> ReplaySubject: 向所有的订阅者广播新事件，并将特定的前bufferSize个事件给新的订阅者
let replaySubject = ReplaySubject<String>.create(bufferSize: 1)
replaySubject.addObserver("replay subject-1").disposed(by: disposeBag)
replaySubject.onNext("222")
replaySubject.onNext("111")

replaySubject.addObserver("replay subject-2").disposed(by: disposeBag)
replaySubject.onNext("333")
replaySubject.onNext("444")

print("\n//BehaviorSubject--------------------------------------------")
//: >BehaviorSubject: 向所有订阅者广播新事件，向新订阅者广播最新或者初始事件
let behaviorSubject = BehaviorSubject(value: "+11111+")
behaviorSubject.addObserver("1").disposed(by: disposeBag)
behaviorSubject.onNext("111")
behaviorSubject.onNext("222")
print("---")
behaviorSubject.addObserver("2").disposed(by: disposeBag)
behaviorSubject.onNext("333")
behaviorSubject.onNext("444")
print("---")
behaviorSubject.addObserver("3").disposed(by: disposeBag)
behaviorSubject.onNext("555")
behaviorSubject.onNext("666")

print("\n//Variable--------------------------------------------")

/*:
 >Variable:包装BehaviorSubject，因此它会向新的订阅者发出最近的或者初始的事件，同时一个Variable也保持了当前的状态，Variable从不发出一个Error事件，但是它会在deinit时候发出一个completed事件并终止。
 */
let variable = Variable("+1111+")
print("---")
variable.asObservable().addObserver("1").disposed(by: disposeBag)
variable.value = "111"
variable.value = "222"
print("---")
variable.asObservable().addObserver("2").disposed(by: disposeBag)
variable.value = "333"
variable.value = "444"



