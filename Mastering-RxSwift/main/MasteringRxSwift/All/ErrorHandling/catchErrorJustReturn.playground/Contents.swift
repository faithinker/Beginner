
import UIKit
import RxSwift

/*:
 # catchErrorJustReturn
 */

// 기본값을 리턴하는 연산자

//public func catchErrorJustReturn(_ element: Self.Element) -> RxSwift.Observable<Self.Element>
// Source 옵저버블에서 에러가 발생하면 파라미터로 전달한 기본값(element)을 구독자에게 전달한다.
// 파라미터의 형식(Self.Element)은 항상 Source 옵저버블이 방출하는 형식과 같다.

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<Int>()

subject
   .catchErrorJustReturn(10) // <Int> 라서 파라미터 Int를 받는다.
   .subscribe { print($0) }
   .disposed(by: bag)

subject.onError(MyError.error)

// 과정 : subject 에러 -> 10 방출 -> Completed
// Source 옵저버블은 더 이상 다른 이벤트를 전달 할 수 없고
// 파라미터로 전달한 것은 옵저버블이 아니라 하나의 값이다.
// 더이상 전달될 이벤트가 없기 때문에 바로 Completed 이벤트가 전달되고 종료된다.


let subject2 = PublishSubject<String>()

subject2
   .catchErrorJustReturn("subject2 Type Parameter is String") // <String>라서 파라미터 String만된다.
   .subscribe { print($0) }
   .disposed(by: bag)



// 정리
// catchErrorJustReturn : 에러가 발생했을 때 사용할 수 있는 기본값이 있다
// 하지만 발생한 에러 종류에 관계없이 항상 동일한 값이 리턴된다는 단점이 있다.

// catchError : 클로저를 통해 에러처리 코드를 자유롭게 구현할 수 있다는 장점이 있다.
//
// Retry : 작업을 처음부터 다시 실행하고 싶다.
