


import UIKit
import RxSwift

/*:
 # toArray
 */

//  toArray 연산자 : 원본 옵저버블이 방출하는 모든 요소를 하나의 배열로 방출하고 바로 종료한다.
// 정확하게는 Single을 방출한다.
// Single은 하나의 요소를 방출하거나 Error이벤트를 전달하는 특별한 옵저버이다.

let disposeBag = DisposeBag()

let subject = PublishSubject<Int>()

enum MyError: Error {
    case error
}

subject
    .toArray()
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
//subject.onNext(2)
//subject.onError(MyError.error)
subject.onCompleted() // Completed 안하면 옵저버에게 전달이 안된다.

// Source Observable이 더이상 요소를 방출하지 않는 시점(Completed)이 되어야 모든 요소를 배열에 담을 수 있다.


