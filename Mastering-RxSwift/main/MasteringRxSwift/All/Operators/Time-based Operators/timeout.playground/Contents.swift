
import UIKit
import RxSwift

/*:
 # timeout
 */

// timeout 연산자 : 지정된 시간 이내에 요소를 방출하지 않으면 에러 이벤트를 전달 

//     public func timeout(_ dueTime: RxSwift.RxTimeInterval, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<Self.Element>
// dueTime : timeOut 시간전달. 이 시간안에 next 이벤트를 전달하지 않으면 error 이벤트를 전달하고 종료한다.
// 반대로 시간안에 전달하면 구독자에게 전달한다.

//     public func timeout<Source>(_ dueTime: RxSwift.RxTimeInterval, other: Source, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<Self.Element> where Source : RxSwift.ObservableConvertibleType, Self.Element == Source.Element
// other : Source 옵저버블 전달
// timeout이 발생하면 error 이벤트로 알림하는 것이 아니라 구독대상을 두번째 파라미터로 전달한 옵저버블로 대체한다.


let bag = DisposeBag()

let subject = PublishSubject<Int>()

//subject
//    .timeout(.seconds(3), scheduler: MainScheduler.instance)
//    .subscribe { print($0) }
//    .disposed(by: bag)

// 1 1
// 5 1
// 2 5
Observable<Int>.timer(.seconds(1), period: .seconds(5), scheduler: MainScheduler.instance)
    .subscribe(onNext: { subject.onNext($0) } )
    .disposed(by: bag)

// timeout 시간 이내레 next 이벤트가 전달되기 때문에 계속해서 구독자에게 전달되고 error이벤트는 전달되지 않는다.


subject
    .timeout(.seconds(3), other: Observable.just(10) , scheduler: MainScheduler.instance)
    .subscribe { print($0) }
    .disposed(by: bag)
// error 대신 other로 대체하고 completed 전달 뒤 끝냄
