
import UIKit
import RxSwift

/*:
 # single
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
let numbers2:Array<Int> = []

// 하나의 요소가 방출되는 것을 보장하는 single 연산자
// 원본 Observable에서 하나만 방출하거나 조건과 일치하는 첫번째 요소만 방출한다.
// 방출할 요소가 없거나 두개 이상이면 error 이벤트를 발생시킨다.

// Observable
Observable.from(numbers2)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

print("==================")

Observable.just(1)
    .single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

print("==================")

Observable.from(numbers)
    .single { $0 != 3}
//    .single() // error
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 파라미터가 없는 연산자와, predicate를 받는 연산자 두개가 있다.


// 마지막으로 single 연산자가 이벤트를 전달하는 시점
print("==================")
let subject = PublishSubject<Int>()

subject.single()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(100)


// 하나의 요소가 방출되었다고 해서 completed이벤트를 전달하지 않는다. 다른요소가 방출 할 수도 있기 때문에
// 그래서 single 연산자가 리턴하는 옵저버블은 원본 옵저버블에서 completed 이벤트를 전달할 때까지 대기한다.
// completed 이벤트가 전달되는 시점에 하나의 요소만 방출되었다면 구독자에게 completed이벤트가 전달되고 그 사이에 다른 요소가 방출되었다면 구독자에게는 error이벤트가 전달된다.
