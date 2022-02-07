
import UIKit
import RxSwift

/*:
 # replay, replayAll
 */

// Connectable Observable에 버퍼를 추가하고 새로운 구독자에게 최근 이벤트를 전달하는 방법


// replayAll : 버퍼 사용에 제한이 없다. 구현에 따라서 메모리 사용량이 급격하게 증가하기 때문에 권장 X

let bag = DisposeBag()
//let subject = ReplaySubject<Int>.create(bufferSize: 5) // 별도의 버퍼를 갖게한다.
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5).replay(5) // multicast(subject)

source
   .subscribe { print("🔵", $0) }
   .disposed(by: bag)

source
   .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
   .subscribe { print("🔴", $0) }
   .disposed(by: bag)

source.connect()

// 첫번째 구독자는 모든 이벤트를 방출하지만
// 두번째 이벤트는 3초 뒤에 구독하느라 앞의 항목이 방출 안됨

// 버퍼 크기를 신중하게 정하자 => 필요한 선에서 가장 작게

