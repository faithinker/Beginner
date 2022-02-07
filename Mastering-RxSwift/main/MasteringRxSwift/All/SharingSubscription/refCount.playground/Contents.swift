
import UIKit
import RxSwift

/*:
 # refCount
 */
// refCount 연산자와 RefCount 옵저버블

// ObservableType이 아니라 ConnectableObservableType 이다.
// observable sequence에 하나 이상의 구독이 있는 한 소스에 연결된 observable sequence이다.
//public func refCount() -> Observable<Element> {
//return RefCount(source: self)
//}
//
// RefCount 옵저버블 : 내부에 ConnectableObservable을 유지하면서 새로운 구독자가 추가되는 시점에 자동으로 Connect 메소드를 호출한다.
// 구독자가 구독을 중지하고 다른 구독자가 없다면 ConnectableObservable애서 시퀀스를 중지한다. 그러다가 새로운 구독자가 추가되면 다시 Connect 메소드를 호출한다.


let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().publish().refCount()

let observer1 = source
   .subscribe { print("🔵", $0) }

//source.connect() // refCount()는 내부에 connect 메소드를 자동으로 호출하기 때문에 필요없다.

DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
   observer1.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
   let observer2 = source.subscribe { print("🔴", $0) }

   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      observer2.dispose()
   }
}


// subscribed 구독자가 추가되면 ConnectableObservable을 추가한다.
// isDisposed => Disconnect

// 구독자가 추가되면 Connect되고 더이상 구독자가 없다면 Disconnect 된다.

// 이전의 연산자들은
// ConnectableObservable을 직접 관리하거나 connect 메소드를 직접 호출한다.
// 필요한 시점에 dispose 메소드를 호출하거나 take 연산자를 활용해서 리소스가 정리되도록 구현해야 한다.

// 하지만 refCount를 활용하면 이런 부분이 자동으로 처리되어 코드를 간소화 할 수 있다.






