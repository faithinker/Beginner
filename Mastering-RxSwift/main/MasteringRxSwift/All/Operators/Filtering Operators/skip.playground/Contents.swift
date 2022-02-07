
import UIKit
import RxSwift

/*:
 # skip
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// skip 연산자를 활용해서 특정 요소를 무시하는 방법
// 지정된 수만큼 무시한 다음에 이후에 방출하는 요소만 구독자로 전달한다.

// skip과 인덱스는 다르다.
Observable.from(numbers)
    .skip(2)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

