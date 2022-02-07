
import UIKit
import RxSwift

/*:
 # timer
 */
// interval : 반복주기
// timer 연산자 : "지연 시간"과 "반복 주기"를 지정해서 정수를 방출

// static 타입 메소드이다.
//     public static func timer(_ dueTime: RxSwift.RxTimeInterval, period: RxSwift.RxTimeInterval? = nil, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<Self.Element>
// dueTime : 첫번째 요소가 방출되는 시점까지의 상대적인 시간이다.
// 구독을 시작하고 첫번째 요소가 구독자에게 전달되는 시간을 나타낸다.
// period : 반복주기 기본값이 nil
// scheduler : 타이머가 동작할 스케줄러 전달


let bag = DisposeBag()

Observable<Int>.timer(.seconds(1), scheduler: MainScheduler.instance)
    .subscribe { print($0)}
    .disposed(by: bag)

// 반복주기가 아니라 첫번째 요소가 구독자에게 전달되는 상대적인 시간을 나타낸다.
// 구독 후 1초뒤에 전달된다. 바로 completed 이벤트 전달됨



// period : 0.5초에 1개씩 방출, 9개 방출후 종료
let t = Observable<Int>.timer(.seconds(1), period: .milliseconds(500), scheduler: MainScheduler.instance)
    
    
var subscription = t.subscribe { print($0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    subscription.dispose()
}






