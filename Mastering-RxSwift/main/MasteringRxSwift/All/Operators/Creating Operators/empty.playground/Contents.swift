
import UIKit
import RxSwift

/*:
 # empty
 */
// 어떠한 요소도 방출하지 않는다.

// completed 이벤트를 전달하는 Observable을 생성한다.
// Observer가 아무런 동작없이 종료해야 할 때 자주 활용한다.

// empty와 error가 생성하는 Observable이 next이벤트를 전달하지 않는다.

let disposeBag = DisposeBag()

Observable<Void>.empty()
    .subscribe { print($0)}
    .disposed(by: disposeBag)












