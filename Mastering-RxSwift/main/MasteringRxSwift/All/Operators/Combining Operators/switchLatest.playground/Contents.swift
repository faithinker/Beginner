
import UIKit
import RxSwift

/*:
 # switchLatest
 */
// switchLatest 연산자 : 가장 최근에 방출된 옵저버블을 구독하고, 이 옵저버블이 전달하는 이벤트를 구독자에게 전달
// 어떤 옵저버블이 가장 최근 옵저버블인지 이해하는 것이 핵심이다.


let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = PublishSubject<String>()
let b = PublishSubject<String>()

let source = PublishSubject<Observable<String>>()
// 문자열을 방출하는 옵저버블을 방출하는 Subject

source
    .switchLatest()
    .subscribe { print($0) }
    .disposed(by: bag)

a.onNext("1")
b.onNext("b")

source.onNext(a) // 옵저버블(서브젝트)이 방출됨
// 옵저버블을 방출하는 옵저버블에서 사용한다.
// Source 옵저버블이 가장 최근에 방출한 옵저버블을 구독하고 next 이벤트를 방출하는 새로운 옵저버블을 리턴한다.

// switchLatest은  최신 옵저버블인 A에서 전달한 이벤트를 구독자에게 전달한다.

a.onNext("2")
b.onNext("c")

source.onNext(b)
// a에 대한 구독을 종료하고 b를 구독한다.

a.onNext("3")
b.onNext("d")

//a.onCompleted()
//b.onCompleted() // 최신 옵저버블인 b를 Completed해도 종료되지 않는다.
//source.onCompleted() // 직접 Completed 이벤트를 전달해야 한다.

// Error의 경우는 다르다.
a.onError(MyError.error) // a는 최신 옵저버가 아니기 때문에 error 알림 안받음
b.onError(MyError.error) // 에러가 전달된다.
