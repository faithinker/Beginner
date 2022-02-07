
import UIKit
import RxSwift

/*:
 # takeLast
 */

// public func takeLast(_ count: Int) -> RxSwift.Observable<Self.Element>
// 파라미터 정수, 리턴형 옵저버블
// 리턴되는 옵저버블에는 원본 옵저버블이 방출하는 요소 중에서 마지막에 방출된 N개의 요소가 포함되어 있다.
// "구독자에게 전달되는 시점이 delay 된다."

let disposeBag = DisposeBag()
let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

let subject = PublishSubject<Int>()
let trigger = PublishSubject<Int>()

subject.takeLast(2)
    .subscribe {print($0) }
    .disposed(by: disposeBag)

numbers.forEach { subject.onNext($0) }


// 결과를 보면 출력되지 않았고 code는 분명히 실행되었고 takeLast는 마지막에 방출한 9,10을 버퍼에 저장하고 있다.

subject.onNext(11)
// 버퍼에 저장되어 있는 값이 업데이트 된다.
// 옵저버블이 다른 요소를 방출할지 종료할지 판단 할 수 없다. 요소를 방출하는 시점을 계속 지연시킨다.

//subject.onCompleted()

enum MyError: Error {
    case error
}

subject.onError(MyError.error)

// 에러를 보내면 버퍼에 있는 요소는 전달되지 않고 에러이벤트만 전달한다.
