
import UIKit
import RxSwift

/*:
 # reduce
 */

// reduce 연산자 : 시드 값과 옵저버블이 방출하는 요소를 대상으로 클로저를 실행하고 최종 결과를 옵저버블로 방출
// scan 연사자와 비교해봐라

// reduce : 최종 결과
// scan : 중간 결과와 최종 결과



let bag = DisposeBag()

enum MyError: Error {
   case error
}

let o = Observable.range(start: 1, count: 5)

print("== scan")

o.scan(0, accumulator: +) // 누적 합계
   .subscribe { print($0) }
   .disposed(by: bag)

// soource 옵저버블이 방출하는 이벤트의 수와 구독자로 전달되는 이벤트의 수가 같다.
// 중간과정과 최종 결과가 모두 필요한 경우에 쓴다.

print("== reduce")

o.reduce(0, accumulator: +)
    .subscribe { print($0) }
    .disposed(by: bag)

//  public func reduce<A>(_ seed: A, accumulator: @escaping (A, Self.Element) throws -> A) -> RxSwift.Observable<A>

// 파리미터 : seed, 클로저
// 리턴형 : Result Observable

// Result Observable을 통해 최종 결과 한개만 방출한다.

//o.reduce(<#T##seed: A##A#>, accumulator: <#T##(A, Int) throws -> A#>, mapResult: <#T##(A) throws -> Result#>)
// mapResult 최종 결과를 다른 형식으로 바꾸고 싶을 때 활용한다. reduce 뒤에 map 연산자 쓰는 것과 동일하다.

