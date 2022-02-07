
import UIKit
import RxSwift

/*:
 # sample
 */

// trigger 옵저버블이 Next 이벤트를 전달할 때마다 data 옵저버블이 Next 이벤트를 방출하지만, 동일한 Next 이벤트를 반복해서 방출하지 않는 sample 연산자

// dataObservable.withLatestFrom(triggerObservable)
// withLatestFrom과 반대로 위치한다.

// dataObservable에서 연산자를 호출하고 triggerObservable을 파라미터로 전달한다.
// triggerObservable에서 next 이벤트를 전달할 때마다 data 옵저버블이 최신 이벤트를 방출한다. => withLatestFrom 같다.
// 하지만 동일한 이벤트를 반복해서 방출하지 않는다는 차이가 있다.


let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

data.sample(trigger)
    .subscribe { print($0) }
    .disposed(by: bag)

trigger.onNext(())
data.onNext("Hello")

trigger.onNext(())
trigger.onNext(())
// trigger Subject로 Next 이벤트를 전달한 경우에만 구독자에게 전달이 된다.
// 동일한 이벤트를 두번이상 방출하지 않는다.


//data.onCompleted()
//trigger.onNext(())
// withLatestFrom Completed 아밴트 대신 최신 next 이벤트를 전달했지만
// sample 연산자는 구독자에게 completed 이벤트를 그대로 전달한다.

data.onError(MyError.error)
// trigger가 이벤트 전달하지 않더라고 즉시 방출된다.






