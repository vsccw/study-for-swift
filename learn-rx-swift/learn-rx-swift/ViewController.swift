//
//  ViewController.swift
//  learn-rx-swift
//
//  Created by 程庆春 on 2016/12/25.
//  Copyright © 2016年 Qiun Cheng. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // 
        let disposeBag = DisposeBag()
        let neverSequence = Observable<String>.never()
        let neverSequenceSubscription = neverSequence.subscribe { _ in
            print("This will not be printed.")
        }
        neverSequenceSubscription.addDisposableTo(disposeBag)

        Observable<Int>.empty()
        .subscribe { event in
            print(event)
        }
        .addDisposableTo(disposeBag)

        print("-----just begin------")
        Observable<String>.just("I am a just.")
        .subscribe { event in
            print(event)
        }
        .addDisposableTo(disposeBag)

        print("-----of begin-----")
        Observable<String>.of("I", "am", "a", "of", ".")
        .subscribe { event in
            print(event)
        }
        .addDisposableTo(disposeBag)

        print("-----")
        Observable<String>.of("I", "am", "a", "of", ".")
        .subscribe(onNext: {
            print($0)
        }, onError: {
            print($0)
        }, onCompleted: { 
            print("completed")
        }) { 
            print("disposed")
        }
        .addDisposableTo(disposeBag)

        Observable<String>.from(["I", "am", "a", "of", "."])
        .subscribe(onNext: {
            print($0)
        })
        .addDisposableTo(disposeBag)

        print("------- create a custom Observable suquence just -------")
        func myJust<E>(element: E) -> Observable<E> {
            return Observable.create({ observer -> Disposable in
                observer.on(.next(element))
                observer.on(Event.completed)
                return Disposables.create()
            })
        }
        myJust(element: 0)
        .subscribe { (event) in
            print(event)
        }
        .addDisposableTo(disposeBag)

        print("-----another way.-----")
        let myJust2 = { (element: String) -> Observable<String> in
            return Observable.create({ (observer) -> Disposable in
                observer.on(Event.next(element))
                observer.on(Event.completed)
                return Disposables.create()
            })
        }
        myJust2("😀")
        .subscribe { (event) in
//            print($0)
            print(event)
        }
        .addDisposableTo(disposeBag)

        print("-----create an observable sequence with repeatElement------")
        Observable.repeatElement("😇")
        .take(3)
        .subscribe {
            print($0)
        }
        .addDisposableTo(disposeBag)

        print("-----create an observable sequence with generate------")
        Observable<Int>.generate(
            initialState: 1,
            condition: { $0 < 10 },
            iterate: {  $0 + 1  })
        .subscribe {
            print($0)
        }
        .addDisposableTo(disposeBag)

        var c = 1
        let deferredSequence = Observable<String>.deferred {
            print("Creating \(c)")
            c += 1

            return Observable.create { observer in
                print("Emitting...")
                observer.onNext("🐶")
                observer.onNext("🐱")
                observer.onNext("🐵")
                return Disposables.create()
            }
        }

        deferredSequence
            .subscribe(onNext: { print($0) })
            .addDisposableTo(disposeBag)

        deferredSequence
            .subscribe(onNext: { print($0) })
            .addDisposableTo(disposeBag)

        deferredSequence
            .subscribe {
                print($0)
            }
            .addDisposableTo(disposeBag)


//        Observable<Int>.error
//            .subscribe {
//                print($0)
//            }
//            .addDisposableTo(disposeBag)


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

