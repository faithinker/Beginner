
import UIKit
import RxSwift

/*:
 # throttle
 */
// public func throttle(_ dueTime: RxTimeInterval, latest: Bool = true, scheduler: SchedulerType)
//    -> Observable<Element> {
//    return Throttle(source: self.asObservable(), dueTime: dueTime, latest: latest, scheduler: scheduler)
//}

// dueTime 반복주기, scheduler 스케줄러
// latest는 대부분 생략한다. (기본값 사용하는데 엄격하다.)
// false를 전달하면 반복주기가 경과 한 다음 가장 먼저 방출되는 이벤트를 구독자에게 전달한다.
// 지정된 주기동안 하나의 이벤트만 구독자에게 전달한다.
//


let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
      
      Thread.sleep(forTimeInterval: 1)
      
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
      
      observer.onCompleted()
   }
   
   return Disposables.create()
}


buttonTap
   .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
   .subscribe { print($0) }
   .disposed(by: disposeBag)

// dueTime 반복주기 마다 방출한다.
//

// 두 연산자 비교 정리
// Next 이벤트를 지정된 주기마다 하나씩 구독자에게 전달한다.
// Debounce : Next 이벤트가 전달된 다음 지정된 시간이 경과하기까지 다른 이벤트가 전달되지 않는다면 마지막으로 방출된 이벤트를 구독자에게 이벤트를 전달한다.

// Throttle : 짧은 시간동안 반복되는 Tap Delegate 메시지 처리
// Debounce : Search 검색기능
// 사용자가 키워드를 입력할 때마다 네트워크 요청을 전달하거나 DB를 검색한다 가정.
// 매번 DB 검색하면 비효율적. 사용자가 짧은시간동안 연속해서 문자를 입력할 때는 작업이 실행되지 않는다.
// 지정된 시간동안 문자를 입력하지 않으면 실제로 검색작업을 시작한다. 불필요한 리소를 낭비하지 않으면서 실시간 검색 기능을 구현할 수 있다.
//

//: [Next](@next)
