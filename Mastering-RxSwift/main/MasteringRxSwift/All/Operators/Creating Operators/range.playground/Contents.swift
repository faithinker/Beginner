
import UIKit
import RxSwift

/*:
 # range
 */
// 정수를 지정된 수만큼 방출 (파라미터 형식이 정수로 제한됨)
// range 연산자는 시작값에서 1씩 증가하는 시퀀스를 생성한다.

let disposeBag = DisposeBag()

Observable.range(start: 1, count: 10)
   .subscribe { print($0) }
   .disposed(by: disposeBag)





