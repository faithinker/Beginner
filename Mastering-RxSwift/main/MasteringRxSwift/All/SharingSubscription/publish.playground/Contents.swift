
import UIKit
import RxSwift

/*:
 # publish
 */

// PublishSubject를 활용해서 구독을 공유하는 publish 연산자

//public func publish() -> ConnectableObservable<Element> {
//return self.multicast { PublishSubject() }
//}
// multicast를 호출해서 새로운 PublishSubject를 만들어서 파라미터로 전달한다.
// ConnectableObservable을 리턴한다.


let bag = DisposeBag()
//let subject = PublishSubject<Int>()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).publish() //.multicast(subject)

source
   .subscribe { print("🔵", $0) }
   .disposed(by: bag)

source
   .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
   .subscribe { print("🔴", $0) }
   .disposed(by: bag)

source.connect()

// 결과가 multicast와 같다.
// PublishSubject를 자동으로 생성해 준다는 점만빼면 multicast와 같다.




