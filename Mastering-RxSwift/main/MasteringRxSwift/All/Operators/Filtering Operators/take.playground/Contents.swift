
import UIKit
import RxSwift

/*:
 # take
 */

// 처음 n개의 요소 또는 마지막 n개의 요소를 방출하는 방법과 요소의 방출 조건을 지정하는 방법

// 정수를 파라미터로 받아서 해당 숫자만큼 요소 방출
// next 이벤트를 제외한 나머지 이벤트에는 영향을 주지 않는다.

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

Observable.from(numbers)
    .take(3)
    .subscribe { print($0) }
    .disposed(by: disposeBag)





