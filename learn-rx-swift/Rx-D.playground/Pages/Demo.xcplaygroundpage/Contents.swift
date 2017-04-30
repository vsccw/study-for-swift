//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa

var str = "Hello, playground"

let rangeBufferObservable = Observable<Int>.range(start: 1, count: 10).buffer(timeSpan: 0, count: 3, scheduler: MainScheduler.instance)
rangeBufferObservable
  .subscribe {
    print($0)
  }
  .addDisposableTo(DisposeBag())


//: [Next](@next)
