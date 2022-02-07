
import UIKit
import RxSwift

/*:
 # merge
 */


// merge 연산자 : 여러 옵저버블이 방출하는 이벤트를 하나의 옵저버블에서 방출하도록 병합
// concat과 혼동한다. 하지만 concat 연산자와 동작방식이 다르다.
//
// concat 하나의 옵저버블이 모든 요소를 방출하고 completed 이벤트를 전달하면 이어지는 옵저버블을 연결한다.
// 반면 merge 두개 이상의 옵저버블을 병합하고 모든 옵저버블에서 방출하는 요소들을 순서대로 방출하는 옵저버블을 리턴한다.


let bag = DisposeBag()

enum MyError: Error {
   case error
}

let oddNumbers = BehaviorSubject(value: 1)
let evenNumbers = BehaviorSubject(value: 2)
let negativeNumbers = BehaviorSubject(value: -1)


let source = Observable.of(oddNumbers, evenNumbers)

//public func merge() -> RxSwift.Observable<Self.Element.Element>
// 두개 이상의 옵저버블이 방출하는 요소들을 병합한 하나의 옵저버블을 리턴한다.
// 단순히 뒤에 연결하는 것이 아니라 하나의 옵저버블로 합쳐준다.
// 옵저버블이나 서브젝트로 연결된 이벤트가 순서대로 구독자에게 전달된다.

source
//    .merge(maxConcurrent: 2) //옵저버블 수를 제한
    .merge()
    .subscribe { print($0) }
    .disposed(by: bag)
// next가 방출한 것이 아니라 Subject가 방출한 것이다.

oddNumbers.onNext(3)
evenNumbers.onNext(4)

evenNumbers.onNext(6)
oddNumbers.onNext(5)

oddNumbers.onCompleted()
//oddNumbers.onError(MyError.error)

evenNumbers.onNext(8)

evenNumbers.onCompleted()

// 둘다 completed 이어야 옵저버도 completed 됨
// odd가 종료될 때는 even의 값이 전달되지만 => 구독자에게 completed가 전달 된 상태가 아니다.
// odd가 에러이면 그 이후 값 전달이 안됨

//Observable.merge(oddNumbers, evenNumbers, negativeNumbers)
//    .subscribe { print($0) }
//    .disposed(by: bag)

print("================")
let source2 = Observable.of(oddNumbers, evenNumbers, negativeNumbers)
source2
    .merge(maxConcurrent: 2) // 옵저버블 수를 제한
    .subscribe { print($0) }
    .disposed(by: bag)


oddNumbers.onCompleted()

negativeNumbers.onNext(-2)

// 앞의 odd, even subject만 즉 옵저버블을 병합한 상태이기 때문에 negative 병합 대상에서 제거된다.
// merge 연산자는 이런 옵저버블을 큐에 저장해 두었다가 병합 대상 중 하나가 순서대로 병합 대상에 추가한다.
