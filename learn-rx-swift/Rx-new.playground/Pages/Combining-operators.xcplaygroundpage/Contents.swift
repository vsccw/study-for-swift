//: Playground - noun: a place where people can play

import UIKit
import RxSwift

let disposeBag = DisposeBag()

example(of: "startWith") {

}

example(of: "merge") {
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()

  Observable.merge([left, right])
    .asObservable()
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)

  left.onNext("left 1 : 1")
  right.onNext("right 1 : 1")
  left.onNext("left 2 : 2")
  left.onCompleted()
  right.onNext("right 3 : 3")
}

example(of: "comlbineLatest") {
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()

  Observable
    .combineLatest(left, right, resultSelector: { (value1, value2) in
      return "\(value1) --- \(value2)"
    }).asObservable()
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)


  left.onNext("left 1 : 1")
  right.onNext("right 1 : 1")
  left.onNext("left 2 : 2")
  right.onNext("right 3 : 3")
  left.onCompleted()
}

example(of: "zip") {
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()

  Observable
    .zip(left, right, resultSelector: { (value1, value2) in
      return "\(value1) --- \(value2)"
    })
    .asObservable()
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)

  left.onNext("left 1 : 1")
  left.onNext("left 2 : 2")
  left.onNext("left 3 : 3")
  right.onNext("right 1 : 1")
  right.onNext("right 3 : 3")
  right.onNext("right 4 : 4")
  left.onCompleted()
}

example(of: "withLatestFrom") { 
  let button = PublishSubject<Void>()
  let textField = PublishSubject<String>()

  button.withLatestFrom(textField)
    .asObservable()
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)

  textField.onNext("1 : 1")
  textField.onNext("2 : 2")
  button.onNext()
  textField.onNext("3 : 3")
  button.onNext()
  button.onNext()
  button.onNext()
}

example(of: "sample") {
  let button = PublishSubject<Void>()
  let textField = PublishSubject<String>()

  textField.sample(button)
    .asObservable()
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)

  textField.onNext("1 : 1")
  textField.onNext("2 : 2")
  button.onNext()
  textField.onNext("3 : 3")
  button.onNext()
  button.onNext()
  button.onNext()
}

example(of: "amb") { // 那个 sequence 先发出以后就只要那个队列的
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()
  let middle = PublishSubject<String>()

  left.amb(right).amb(middle)
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)

  middle.onNext("middle")
  left.onNext("left 1 : 1")
  right.onNext("right 1 : 1")
  left.onNext("left 2 : 2")
  right.onNext("right 2 : 2")
  left.onCompleted()
}

example(of: "switchLatest") { // like flatMapLatest
  let left = PublishSubject<String>()
  let right = PublishSubject<String>()
  let source = PublishSubject<Observable<String>>()

  source.switchLatest()
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)

  source.onNext(left)
  left.onNext("left 1 : 1")
  right.onNext("right 0 : 0")
  left.onNext("left 1 : 1")

  source.onNext(right)
  right.onNext("right 1 : 1")
  left.onNext("left 3 : 3")
  right.onNext("right 2 : 2")
}

example(of: "reduce") {
  let numbers = Observable.of(1, 2, 3, 4, 5)
  numbers.reduce(100, accumulator: +)
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)
}

example(of: "scan") {  /// 将reduce的每一步都输出
  let numbers = Observable.of(1, 2, 3, 4, 5)
  numbers.scan(100, accumulator: +)
    .subscribe(onNext: { value in
      print(value)
    })
    .disposed(by: disposeBag)
}


