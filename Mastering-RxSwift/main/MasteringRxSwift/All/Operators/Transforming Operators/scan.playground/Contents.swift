
import UIKit
import RxSwift

/*:
 # scan
 */

// accumulator function(Closure)을 활용하는 scan 연산자
// 기본값으로 연산을 실행한다.
// 원본 옵저버블이 방출하는 항목을 대상으로 변환을 실행한 다음 결과를 방출하는 하나의 옵저버를 리턴한다.
// 원본이 방출하는 항목의 수와 구독자로 전달되는 항목의 수가 동일하다.


// public func scan<A>(_ seed: A, accumulator: @escaping (A, Self.Element) throws -> A) -> RxSwift.Observable<A>
// first Para : 기본값 전달
// second Para : Closure
//
// @escaping (A, Self.Element) throws -> A
// 기본값의 형식과 같다.
// 옵저버블이 방출하는 항목의 형식과 동일
// 리턴형은 첫번째 파라미터와 같다.
//
// 기본값이나 옵저버블이 방출하는 항목을 대상으로 accumulatorClosure를 실행한 다음,
// 결과를 옵저버블로 리턴한다. Closure가 리턴한 값은 이어서 실행되는 클로저에 첫번째 파라미터로 전달된다.


let disposeBag = DisposeBag()

Observable.range(start: 1, count: 10)
    .scan(0, accumulator: +)
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// Observable이 계속 누적된 값을 전달한다.
// 작업 결과를 누적시키면서 중간 결과와 최종 결과가 모두 필요한 경우에 사용한다.



