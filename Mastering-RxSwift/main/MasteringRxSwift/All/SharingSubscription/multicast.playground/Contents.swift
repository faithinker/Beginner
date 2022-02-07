
import UIKit
import RxSwift

/*:
 # multicast
 */
// multicast 연산자와 Connectable Observable
// network - unicast


//     public func multicast<Subject: SubjectType>(_ subject: Subject)
//    -> ConnectableObservable<Subject.Element> where Subject.Observer.Element == Element {
//    return ConnectableObservableAdapter(source: self.asObservable(), makeSubject: { subject })
//}
// Subject를 파라미터로 받는다. 원본 옵저버블이 방출하는 이벤트는 구독자에게 전달되는 것이 아니라 subject에게 전달된다.
// Subject 이벤트는 전달받은 이벤트를 등록된 다수의 구독자에게 전달한다. unicast 방식 -> multicast 방식 바꾼다.
//
// ConnectableObservable의 특징
// 시퀀스가 시작되는 시점이 다르다.
// 일반 옵저버블 구독자가 추가되면 세로운 시퀀스가 시작된다 (이벤트 방출을 함)
// 구독자가 추가되어도 시퀀스는 시작되지 않는다. Connect 메소드를 호출하는 시점에 시퀀스가 시작됨
//
// 원본 옵저버블이 전달한 이벤트는 subject로 전달되고 등록된 모든 구독자에게 이벤트를 전달한다.
// 모든 구독자가 등록된 이후에 하나의 시퀀스를 시작하는 패턴을 구현할 수 있다.
//
// ConnectableObservableAdapter : 원본 옵저버블과 Subject를 연결해주는 특별한 클래스

let bag = DisposeBag()
let subject = PublishSubject<Int>()

//let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5)
//    .multicast(subject)
//// source에는 일반 옵저버블이 아니라 ConnectableObservable이 추가된다.
//// 구독자가 추가되는 시점에 시작하지 않는다.
//// connect() 메소드를 명시적으로 호출해야한다.
////
//// connect 되는 시점에 시작되는 순서
//// 원본 옵저버블에서 시퀀스가 시작되고 모든 이벤트는 파라미터로 전달한 subject로 전달된다.
//// subject는 모든 구독자에게 이벤트를 전달한다.
//
//source
//   .subscribe { print("🔵", $0) }
//   .disposed(by: bag)
//
//source
//   .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) // 구독시점 3초 지연
//   .subscribe { print("🔴", $0) }
//   .disposed(by: bag)
//
//source.connect()


// 구독하자마자 개별 시퀀스가 생성되느냐, 원본 옵저버블을 공유하느냐



//let source2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).take(5)
//
//source2
//   .subscribe { print("🔵", $0) }
//   .disposed(by: bag)
//
//source2
//   .delaySubscription(.seconds(3), scheduler: MainScheduler.instance) // 구독시점 3초 지연
//   .subscribe { print("🔴", $0) }
//   .disposed(by: bag)


// Result
//🔵 next(0)
//🔵 next(1)
//🔵 next(2)
//🔵 next(3)
//🔴 next(0)
//🔵 next(4)
//🔵 completed
//🔴 next(1)
//🔴 next(2)
//🔴 next(3)
//🔴 next(4)
//🔴 completed
