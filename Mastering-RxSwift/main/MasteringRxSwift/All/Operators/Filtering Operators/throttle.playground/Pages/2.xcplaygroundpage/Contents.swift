//: [Previous](@previous)

import UIKit
import RxSwift

/*:
 # throttle
 ## latest parameter
 */



let disposeBag = DisposeBag()

func currentTimeString() -> String {
   let f = DateFormatter()
   f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   return f.string(from: Date())
}

// latest: true 주기를 정확하게 지킨다. 2.5초마다 가장 최근에 방출된 next 이벤트를 구독자에게 전달한다.
//Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//   .debug() //이벤트 발생시간 확인
//   .take(10)
//   .throttle(.milliseconds(2500), latest: true, scheduler: MainScheduler.instance)
//   .subscribe { print(currentTimeString(), $0) }
//   .disposed(by: disposeBag)



// next 이벤트가 방출된 다음 지정된 주기가 지나고 그 이후에 첫번째로 방출되는 next이벤트를 전달한다.
// 원본 옵저버블이 새로운 next이벤트를 방출 할 때까지 기다린다.
Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
   .debug()
   .take(10)
   .throttle(.milliseconds(2500), latest: false, scheduler: MainScheduler.instance)
   .subscribe { print(currentTimeString(), $0) }
   .disposed(by: disposeBag)
 
// 차이점은 next 이벤트가 전달되는 주기이다. true를 전달하면 주기를 엄격하게 지키지만 false를 전달하면 지정된 주기를 초과할 수 있다.
