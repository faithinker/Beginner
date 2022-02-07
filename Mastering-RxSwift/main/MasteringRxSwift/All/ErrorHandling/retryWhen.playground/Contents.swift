
import UIKit
import RxSwift

/*:
 # retryWhen
 */
// retry : 성공할 때 까지 계속 재시도 하거나 (빈파라미터) 최대 재시도 횟수만큼 재시도 함
// retryWhen : 재시도 할 시점을 규정함

//    public func retryWhen<TriggerObservable: ObservableType, Error: Swift.Error>(_ notificationHandler: @escaping (Observable<Error>) -> TriggerObservable)
// 클로저를 파라미터로 받고 발생한 에러를 방출한 옵저버블이 전달된다.  TriggerObservable을 리턴한다.
// TriggerObservable이 next이벤트를 전달하는 시점에 Source 옵저버블에서 새로운 구독을 시작한다 => 작업을 재시도 한다.

let bag = DisposeBag()

enum MyError: Error {
   case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
   let currentAttempts = attempts
   print("START #\(currentAttempts)")
   
   if attempts < 3 {
      observer.onError(MyError.error)
      attempts += 1
   }
   
   observer.onNext(1)
   observer.onNext(2)
   observer.onCompleted()
   
   return Disposables.create {
      print("END #\(currentAttempts)")
   }
}

let trigger = PublishSubject<Void>()

source
   .retryWhen { _ in trigger }
   .subscribe { print($0) }
   .disposed(by: bag)

trigger.onNext(())
// 바로 재시도 하지 않고 trigger 옵저버블이 next 이벤트를 전달 할 때까지 대기한다.

trigger.onNext(())



// 시작 시점을 5초 늦게 주고 싶다.
//let trigger2 = PublishSubject<Void>()
//source
//   .retryWhen { _ in trigger2 }
//   .delay(.seconds(3), scheduler: MainScheduler.instance)
//   .subscribe { print($0) }
//   .disposed(by: bag)
//
//trigger2.onNext(())


// 내가 예상했던 값
//START #3
//next(1)
//next(2)
//END #3
//completed

// 실제 결과값
//START #3
//END #3
//next(1)
//next(2)
//completed
