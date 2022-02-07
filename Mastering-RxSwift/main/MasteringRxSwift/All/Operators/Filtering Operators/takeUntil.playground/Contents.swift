
import UIKit
import RxSwift

/*:
 # takeUntil
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.takeUntil(trigger)
    .subscribe {print($0) }
    .disposed(by: disposeBag)

subject.onNext(1)
subject.onNext(2)

trigger.onNext(0) // trigger에서 요소를 방출하면 completed 이벤트를 방출한다.


//public func takeUntil<Source: ObservableType>(_ other: Source)
//    -> Observable<Element> {
//    return TakeUntil(source: self.asObservable(), other: other.asObservable())
//}
// 파리미터 : Observable,
// 파라미터로 전달한 옵저버블에서 next이벤트를 전달하지 전까지 원본 옵저버블에서 next 이벤트를 전달한다.
