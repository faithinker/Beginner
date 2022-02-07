
import UIKit
import RxSwift

/*:
 # combineLatest
 */
// Source 옵저버블 -> result 옵저버블

// combineLatest 연산자 : 소스(Source) 옵저버블이 방출하는 최신 요소를 병합
// 연산자가 리턴한 옵저버블이 "언제" 이벤트를 방출하는지 이해하는 것이다.
//
// First Source 옵저버블이 방출하는 시점에 먼저 방출된 Second Source 옵저버블의 이벤트가 있으면 combine 연산을 해서
// 방출하고 없으면 방출하지 않는다.
//
// Second Source 옵저버블이 방출하는 시점에 먼저 방출된 Second Source 옵저버블이 있으면 방출하고 그렇지 않으면 뒤의 것과 결합해서 방출한다.
//
// 서로가 결합할 때 가장 가까운 옵저버블과 결합해서 방출한다.


//public static func combineLatest<O1, O2>(_ source1: O1, _ source2: O2, resultSelector: @escaping (O1.Element, O2.Element) throws -> Self.Element) -> RxSwift.Observable<Self.Element> where O1 : RxSwift.ObservableType, O2 : RxSwift.ObservableType
//
// 두개의 옵저버블과 클로저를 파라미터로 받는다. 옵저버블이 next 이벤트를 통해 전달하는 요소들은 클로저 파라미터를 통해 클로저로 전달한다.

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let greetings = PublishSubject<String>()
let languages = PublishSubject<String>()


Observable.combineLatest(greetings, languages) { lhs, searchstate
    -> String in
    return "\(lhs) \(lhs)"
}
    .subscribe { print($0) }
    .disposed(by: bag)

greetings.onNext("Hi")
languages.onNext("World!")

greetings.onNext("Hello")
languages.onNext("RXSwift")

greetings.onCompleted()
// greetings.onError(MyError.error)
languages.onNext("SwiftUI")


languages.onCompleted()


// 구독과 동시에 이벤트를 받고 싶으면 startWith behaviorSubject로 바꾸면 된다.

// 두개의 Source 옵저버블이 모두 Completed 되어야 옵저버(구독자)도 종료된다.
// error는 한쪽만 에러가 나도 구독자가 에러 알림(Noti)을 띄운다.

