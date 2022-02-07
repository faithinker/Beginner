
import UIKit
import RxSwift

/*:
 # delaySubscription
 */

let bag = DisposeBag()

func currentTimeString() -> String {
   let f = DateFormatter()
   f.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
   return f.string(from: Date())
}

// 원본 옵저버블이  5초 뒤에 event를 전달하고 구독이 바로 이어진다.
// delaySubscription : 구독 시점을 지연시킬뿐, next 이벤트가 전달되는 시점을 지연시키지는 않는다.


Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .take(10)
    .debug()
    .delaySubscription(.seconds(5), scheduler: MainScheduler.instance)
    .subscribe { print(currentTimeString() ,$0) }
    .disposed(by: bag)




