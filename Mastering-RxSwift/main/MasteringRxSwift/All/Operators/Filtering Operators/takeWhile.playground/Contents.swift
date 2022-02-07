
import UIKit
import RxSwift

/*:
 # takeWhile
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]




Observable.from(numbers)
    .takeWhile { !$0.isMultiple(of: 2)} // 홀수
    .subscribe { print($0) }
    .disposed(by: disposeBag)



//public func takeWhile(_ predicate: @escaping (Element) throws -> Bool)
//    -> Observable<Element>
// 클로저를 파라미터로 받아서 predicate로 사용한다. true를 리턴하면 구독자에게 전달한다(요소를 방출한다.)
// 연산자가 리턴하는 Observable에는 조건을 만족시키는 요소만 포함된다.

// 이후에도 홀수가 방출 되지만 구독자에게 전달되지 않는다.
// 클로저가 false를 리턴하면 더이상 요소를 방출하지 않고 이후에는 completed error 이벤트만 전달한다.

