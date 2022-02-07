
import UIKit
import RxSwift

/*:
 # flatMapFirst
 */

// flatMap
// 원본 옵저버블이 방출하는 항목을 옵저버블로 변환한다. 변환된 옵저버블이 방출하는 모든 항목을 하나로 모아서 단일 옵저버블을 리턴한다.

// flatMapFirst
// 하지만 연산자가 리턴하는 옵저버블에는 처음에 변환된 옵저버블이 방출하는 항목이 포함된다.
// 앞의 옵저버의 항목들만 방출됨 A의 항목들만 방출됨

let disposeBag = DisposeBag()

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject
   .flatMapFirst { $0.asObservable() }
   .subscribe { print($0) }
   .disposed(by: disposeBag)

subject.onNext(a)
subject.onNext(b) // 첫번째로 변환된 옵저버블이 방출하는 항목만 구독자로 전달하고 나머지는 무시한다.

a.onNext(11)
b.onNext(22)
b.onNext(222)
a.onNext(111)
