
import UIKit
import RxSwift

/*:
 # interval
 */
// interval 연산자 : 지정된 주기마다 정수를 방출

// 타입 메소드로 구현되어 있다.
//     public static func interval(_ period: RxSwift.RxTimeInterval, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<Self.Element>
// period : 반복주기
// RxTimeInterval은 DispatchTimeInterval과 같다.
// scheduler : 정수를 방출할 스케줄러 지정
// disposeBag 하기 전까지 계속 방출한다.
// 요소의 형식이 FixedWidthInteger 을 채용하고 있다. int를 포함한 다른 정수 형식을 사용할 수 있지만 Double이나 String을 쓸 수 없다.

let i = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)

// 바로 방출해서 5가되면 멈춤
let subscription1 = i.subscribe { print("1 >> \($0)") }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
    subscription1.dispose()
}

// 생성 시점이 아니라 구독자가 구독을 시작하는 시점에 타이머가 생성된다.

var subscription2: Disposable?

// 2초 뒤에 시작되고 7초가 되면 dispose 함. interval은 1초마다 방출함
DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
    subscription2 = i.subscribe { print("2 >> \($0)") }
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
    subscription2?.dispose()
}

// interval 연산자는 새로운 구독이 추가되는 시점에 내부의 타이머가 시작된다


//1 >> next(0) 1초
//1 >> next(1) 2초
//1 >> next(2) 3초
//2 >> next(0) 3초
//1 >> next(3) 4초
//2 >> next(1) 4초
//1 >> next(4) 5초
//2 >> next(2) 5초
//2 >> next(3) 6초
