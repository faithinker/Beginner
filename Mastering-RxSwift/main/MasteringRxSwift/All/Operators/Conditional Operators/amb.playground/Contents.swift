
import UIKit
import RxSwift

/*:
 # amb
 */

// amb 연산자 : 여러 옵저버블 중에서 가장 먼저 이벤트를 방출하는 옵저버블을 선택함
// 두개 이상의 Source 옵저버블 중에서 가장 먼저 next 이벤트를 전달하는 옵저버블을 구독하고 나머지는 무시한다.

// 여러 서버로 요청을 전달하고 가장 빠른 응답을 처리하는 패턴을 구현 할 수 있다.

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()
let c = PublishSubject<String>()


Observable.amb([a,b,c])
//a.amb(b) // source 옵저버블이 두개로 제한된 연산자이다.
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("A")
b.onNext("B")

b.onCompleted() // 전달 안됨
a.onCompleted()


//     public func amb<O2>(_ right: O2) -> RxSwift.Observable<Self.Element> where O2 : RxSwift.ObservableType, Self.Element == O2.Element
// 하나의 옵저버블을 파라미터로 받는다.
// 두 옵저버블 중에서 먼저 이벤트를 전달하는 옵저버블을 구독하고 이 옵저버블의 이벤트를 구독자에게 전달하는 새로운 옵저버블을 리턴한다.


// Observable.메소드
// 타입 메소드로 구현된 연산자 : 3개이상의 파라미터를 받는다.
// public static func amb<Sequence>(_ sequence: Sequence) -> RxSwift.Observable<Self.Element> where Sequence : Sequence, Sequence.Element == RxSwift.Observable<Self.Element>
// 모든 Source 옵저버블을 배열 형태로 전달한다.



