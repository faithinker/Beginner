
import UIKit
import RxSwift

/*:
 # filter
 */

// filter 연산자를 활용해서 특정 조건에 맞는 항목을 필터링하는 방법


let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

// 옵저버블이 방출하는 요소를 필터링한다.

Observable.from(numbers)
    .filter { $0.isMultiple(of: 2) }
    .subscribe { print($0)}
    .disposed(by: disposeBag)

//public func filter(_ predicate: @escaping (Self.Element) throws -> Bool) -> RxSwift.Observable<Self.Element>

// 클로저를 파라미터로 받는다. 이 클로저는 predicate로 설정된다.
