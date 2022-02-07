// ErrorHandling : RxSwift의 오류 처리 패턴
// 에러를 알림하면 구독이 종료되고 더이상 새로운 이벤트를 처리 할 수 없다.
//
// 예시)
// 옵저버블 Network 요청을 처리, 구독자 UI 업데이트하는 패턴
//  UI를 업데이트 하는 코드는 Next이벤트가 전달되는 시점에 실행된다.
// 에러가 전달되면 구독이 전달되고 더이상 Next 이벤트가 전달되지 않고 UI는 업데이트 되지 않는다.

// 두가지 해결방법
// 1. catchError : Error 이벤트가 전달되면 새로운 옵저버블을 리턴한다.
// Error 이벤트가 전달되면 새로운 옵저버블을 구독자에게 전달한다.
// 기본값이나 로컬 캐시를 방출하는 옵저버블을 구독자에게 전달 할 수 있다.
// 에러가 발생한 경우에도 UI는 적절한 값으로 업데이트 된다.
//
// 2. Retry : 옵저버블을 다시 구독한다.
// 에러가 발생하지 않을 때까지 무한정 반복하거나 재시도 횟수를 제한한다.


import UIKit
import RxSwift

/*:
 # catchError
 */

// catchError 연산자를 활용한 오류 처리 패턴

// Error 이벤트는 전달하지 않고 새로운 옵저버블이나 기본값을 전달한다.
// 네트워크 요청 구현에서 많이 사용한다.
// 올바른 응답을 받지 못한 상황에서 로컬 캐시를 사용하거나 기본값을 사용하도록 구현할 수 있다.


let bag = DisposeBag()

enum MyError: Error {
   case error
}

//     public func catchError(_ handler: @escaping (Error) throws -> RxSwift.Observable<Self.Element>) -> RxSwift.Observable<Self.Element>
// 클로저로 Error를 받아서 새로운 옵저버블을 리턴한다.
// Self.Element 옵저버블이 방출하는 요소의 형식은 소스옵저버블과 동일하다.
// 교체된 옵저버블은 다른 이벤트를 전달할 수 있다.

let subject = PublishSubject<Int>()
let recovery = PublishSubject<Int>()

subject
    .catchError { _ in recovery }
   .subscribe { print($0) }
   .disposed(by: bag)
subject.onError(MyError.error)

subject.onNext(11) // 다른 이벤트 전달 못함

recovery.onNext(22) // 새로운 요소 방출 가능
recovery.onCompleted() // 구독이 에러없이 잘 completed 됨.

// catchError 연산자는 Source 옵저버블에서 발생한 에러를 새로운 옵저버블로 교체하는 방식으로 처리한다.


