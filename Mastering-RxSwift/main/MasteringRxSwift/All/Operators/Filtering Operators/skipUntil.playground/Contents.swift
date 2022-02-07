
import UIKit
import RxSwift

/*:
 # skipUntil
 */


//public func skipUntil<Source: ObservableType>(_ other: Source)
//    -> Observable<Element> {
//    return SkipUntil(source: self.asObservable(), other: other.asObservable())
//}
// 파라미터 : ObservableType 다른 옵저버블을 파라미터로 받는다.
// 이 옵저버블이 next이벤트를 전달하기 전까지 원본 옵저버블이 전달하는 이벤트를 무시한다.
// 파라미터로 전달하는 Observable을 트리거라고 한다.


let disposeBag = DisposeBag()


let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.skipUntil(trigger)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

subject.onNext(1) // 요소 방출

// 아직 트리거가 요소를 방출한적이 없기 때문에 서브젝트가 방출한 요소는 구독자로 전달되지 않는다.

trigger.onNext(0)

//skipUntil 트리거가 요소를 방출한 이후부터 원본 옵저버블에서 방출되는 요소들을 구독자로 전달한다.

subject.onNext(2)
