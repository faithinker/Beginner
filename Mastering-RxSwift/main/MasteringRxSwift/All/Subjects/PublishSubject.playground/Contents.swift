// Subject OverView
// Observable : 이벤트(데이터) 전달
// Observer 구독하고 이벤트를 처리한다.
// Subject : 다른 Observable로부터 이벤트를 받아서 다른 구독자(Observer)에게 전달 할 수 있다.
// 교각 혹은 프록시
// 옵저버이기 때문에 하나 이상의 Observable을 구독할 수 있으며 동시에 Observable이기도 하기 때문에 항목들을 하나 하나 거치면서 재배출하고 관찰하며 새로운 항목들을 배출할 수도 있다.


// PublishSubject : Subject로 새로운 이벤트를 구독자로 전달
// BehaviorSubject : 생성시점에 시작 이벤트를 지정한다. Subject로 전달되는 이벤트 중에서 가장 마지막에 전달된 최신 이벤트를 저장해두었다가 새로운 구독자에게 최신 이벤트를 전달한다.
// ReplaySubject : 하나 이상의 최신 이벤트를 버퍼에 저장한다. 옵저버가 구독을 시작하면 버퍼에 있는 모든 이벤트를 전달한다.
// AsyncSubject : Subject로 Completed Event가 전달되는 시점에 마지막으로 전달된 next() 이벤트를 구독자로 전달한다.
//
// Relay
// 일반적인 Subject와 달리 Next이벤트만 받고 나머지 Completed와 Error이벤트는 받지 않는다.
// 주로 종료없이 계속 전달되는 이벤트 시퀀스를 처리할 때 활용한다.
// PublishRelay : PublishSubject를 래핑한 것
// BehaviorRelay : BehaviorSubject를 래핑한 것



import UIKit
import RxSwift


/*:
 # PublishSubject
 */
// Subject로 전달되는 이벤트를 옵저버에게 전달하는 가장 기본적인 형태의 Subject이다.

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let subject = PublishSubject<String>()

// 문자열이 포함된 Next 이벤트를 받아서 다른 옵저버에게 전달 할 수 있다.
// subjet가 생성되는 시점에는 내부에 아무런 이벤트가 저장되어 있지 않다.
// Observable인 동시에 Observer

subject.onNext("Hello")
// Hello 출력 안됨.  구독 이후에 전달되는 새로운 이벤트만 구독자로 전달한다.

let o1 = subject.subscribe { print(">> 1", $0) }
o1.disposed(by: disposeBag)


subject.onNext("RxSwift")

let o2 = subject.subscribe { print(">> 2", $0)}
o2.disposed(by: disposeBag)

subject.onNext("Subject")

subject.onCompleted()
subject.onError(MyError.error)

let o3 = subject.subscribe { print(">> 3", $0)}
o3.disposed(by: disposeBag)

subject.onNext("Test")
// o3는 바로 completed Method만 전달하고 끝남

// 이벤트가 전달되면 즉시 구독자에게 이벤트를 전달한다.
// subject가 최초로 생성되는 시점과 첫번째 구독이 시작되는 시점 사이에 전달되는 이벤트는 그냥 사라진다.=> Hello



