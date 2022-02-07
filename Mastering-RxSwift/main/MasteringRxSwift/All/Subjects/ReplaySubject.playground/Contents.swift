
import UIKit
import RxSwift


/*:
 # ReplaySubject
 */
// 지정된 버퍼크기만큼 최신 이벤트를 지정하고 새로운 구독자에게 전달한다.
// buffer = Memory이기 때문에 낭비 혹은 leak(누수)이 되지 않도록 신경써야 한다.

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

// 두개 이상의 이벤트를 저장했다가 새로운 구독자에게 전달하고 싶을 때 사용한다.
let rs = ReplaySubject<Int>.create(bufferSize: 3)

(0...10).forEach { rs.onNext($0) }
// 이 이벤트들이 새로운 구독자에게 전달이 되는데 마지막 8,9,10 세개만 버퍼에 저장됨

rs.subscribe { print("Observer 1 : >>", $0) }
    .disposed(by: disposeBag)

rs.subscribe { print("Observer 2 : >>", $0) }
    .disposed(by: disposeBag)

rs.onNext(0)

rs.subscribe { print("Observer 3 : >>", $0) }
    .disposed(by: disposeBag)
// 가장 오래된 이벤트를 지우고 버퍼를 채운다.

//rs.onCompleted()
rs.onError(MyError.error)

rs.subscribe { print("Observer 4 : >>", $0) }
    .disposed(by: disposeBag)
// 버퍼에 저장되어 있는 이벤트가 전달된 다음에 Completed이벤트가 전달된다.
// ReplaySubject는 종료 여부에 관계 없이 항상 버퍼에 저장되어 있는 이벤트를 새로운 구독자에게 전달한다.
//
// BehaviorSubject는 1개만 이벤트가 저장되고  error나 completed가로 처리된 다음 구독하면
// 이벤트가 저장되지 않고 바로 error 또는 completed만 호출되고 끝이난다.
