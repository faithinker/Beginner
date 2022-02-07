
import UIKit
import RxSwift

/*:
 # skipWhile
 */

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]


// 클로저를 파라미터로 받는다. Filter 연산자와 마찬가지로 predicate로 사용되고 클로저에서 true를 리턴하는 동안
// 방출되는 요소를 무시한다. 클로저에서 false를 리턴하면 그때부터 요소를 방출하고 이후에는 조건없이 방출한다.
//public func skipWhile(_ predicate: @escaping (Element) throws -> Bool) -> Observable<Element> {
//    return SkipWhile(source: self.asObservable(), predicate: predicate)
//}
// filter와 달리 클로저가 false로 판단한 이후에는 조건없이 방출한다.


Observable.from(numbers)
    .skipWhile { !$0.isMultiple(of: 2)}
    .subscribe { print($0) }
    .disposed(by: disposeBag)

