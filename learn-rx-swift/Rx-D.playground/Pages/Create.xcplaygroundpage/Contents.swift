//: [Previous](@previous)

import Foundation
import RxSwift

func myFrom<E>(sequence: [E]) -> Observable<E> {
    return Observable.create { observer in
        for element in sequence {
            observer.on(.next(element))
        }
        observer.onCompleted()
        return Disposables.create()
    }
}

let stringCounter = myFrom(sequence: ["first", "second"])
stringCounter.subscribe {
    print($0.element ?? "nothing")
}

extension ObservableType {
    public func myDebug(identifier: String) -> Observable<E> {
        return Observable.create({ (observer) -> Disposable in
            print("subscribed \(identifier)")
            let subscription = self.subscribe(onNext: { (e) in
                print("\(identifier) ++++++ \(e)")
                observer.on(Event.next(e))
            }, onError: { (error) in
                observer.on(Event.error(error))
            }, onCompleted: {
                observer.on(Event.completed)
            })
            
            return Disposables.create {
                print("disposing \(identifier)")
                subscription.dispose()
            }
        })
    }
}

print("----------------------------------------")
/// create an `Observable` that performs work
func myInterval(_ interval: TimeInterval) -> Observable<Int> {
    return Observable.create { observer in
        print("Subscribed")
        let timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global())
        timer.scheduleRepeating(deadline: DispatchTime.now(), interval: interval)
        
        let cancel = Disposables.create {
            print("Disposed")
            timer.cancel()
        }
        var next = 0
        timer.setEventHandler(handler: {
            if cancel.isDisposed {
                return
            }
            observer.on(.next(next))
            next += 1
        })
        timer.resume()
        return cancel
    }
}

let counter = myInterval(0.1)
    .shareReplay(0)

let subscription1 = counter
    .myDebug(identifier: "my counter 1")
    .subscribe { (n) in
    print("First \(n.element ?? 10000)")
}
let subscription2 = counter
    .debug("my counter 2")
    .subscribe { (n) in
    print("Second \(n.element ?? 10000)")
}

Thread.sleep(forTimeInterval: 0.5)

subscription1.dispose()

Thread.sleep(forTimeInterval: 0.5)

subscription2.dispose()


//: [Next](@next)
