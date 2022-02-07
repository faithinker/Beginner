
import UIKit
import RxSwift

/*:
 # delay
 */

// Next "이벤트가 전달되는 시점"과 "구독이 시작되는 시점"을 지연시키는 방법
// delay == 이벤트 전달 시점 지연
// delaySubscription == 구독 시작 시점 지연



// delay : Next 이벤트가 구독자로 전달되는 시점을 지정한 시간만큼 지연시킨다.
// 에러 이벤트는 지연없이 전달된다.

//     public func delay(_ dueTime: RxTimeInterval, scheduler: SchedulerType)
//-> Observable<Element> {
//    return Delay(source: self.asObservable(), dueTime: dueTime, scheduler: scheduler)
//}
// dueTime : 지연시킬 시간 지정
// scheduler : delayTimer를 실행할 스케줄러를 전달한다.
// Observable<Element> : 원본 옵저버블과 동일한 형식이지만 next 이벤트가 구독자에게 전달되는 시점이 dueTime만큼 지연된다.

let bag = DisposeBag()

func currentTimeString() -> String {
   let f = DateFormatter()
   f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   return f.string(from: Date())
}



// 1초마다 정수를 방출하고 10개로 제한한다. 지연시간을 5초준다. 구독해서 콘솔에 나타낸다. 종료한다.
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delay(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString() ,$0) }
    .disposed(by: bag)

// delay : 구독 시점을 연기하지는 않는다.
// 원본 옵저버블이 방출한 next 이벤트가 먼저 방출 된 다음에 5초뒤에 구독을 하게 만든다.
