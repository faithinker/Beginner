
import UIKit
import RxSwift

/*:
 # flatMapLatest
 */

// 원본 옵저버블이 방출하는 항목을 옵저버블로 변환하는 것은 동일하다.
// 하지만 모든 옵저버블이 방출하는 항목을 하나로 병합하지 않는다.
// 대신 가장 최근에 항목을 방출한 옵저버블을 제외한 나머지는 모두 무시한다.


let disposeBag = DisposeBag()

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject
   .flatMapLatest { $0.asObservable() }
   .subscribe { print($0) }
   .disposed(by: disposeBag)

subject.onNext(a)

a.onNext(11)

subject.onNext(b)

b.onNext(22)

a.onNext(111) // subject.onNext(a) 주석처리하면 a가 전달하는 항목은 더이상 구독되지 않는다.

b.onNext(222)

subject.onNext(a) // 최신 옵저버블이 변경되어 이전에 방출되지 않던 111이 방출된다.
// 원본 옵저버블이 방출하는 subject가 BehaviorSubject이다.

b.onNext(2222) // 다시 최신 옵저버블이 바뀌어서 방출 안됨


// flatMapLatest : 원본 옵저버블이 방출하는 요소를 새로운 옵저버블로 변환하고 가장 최근에 변환된 옵저버블이 방출하는 요소만 구독자에게 전달한다.
