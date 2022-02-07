
import UIKit
import RxSwift

/*:
 # share
 */

// share 연산자를 활용해서 구독을 공유하는 방법


//   public func share(replay: Int = 0, scope: RxSwift.SubjectLifetimeScope = .whileConnected) -> RxSwift.Observable<Self.Element>
// replay : 버퍼의 크기 0을 지정하면 PublishSubject를 전달한다. 0 초과하면 ReplaySubject를 전달한다.
// scope : Subject의 수명을 관리한다.
//
// scope Option
// .whileConnected 개별 connection
// .forever 모든 connection이 하나의 Subject를 공유함

let bag = DisposeBag()
let source = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance).debug().share(replay: 5, scope: .forever)
// source는 Observable이지만 share는 refCount 옵저버블이다.

let observer1 = source
   .subscribe { print("🔵", $0) }

let observer2 = source
   .delaySubscription(.seconds(3), scheduler: MainScheduler.instance)
   .subscribe { print("🔴", $0) }

DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
   observer1.dispose()
   observer2.dispose()
}

DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
   let observer3 = source.subscribe { print("⚫️", $0) }

   DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
      observer3.dispose()
   }
}

// ConnectableObservable 내부에 있는 서브젝트의 수명을 결정한다. 새로운 구독자가 추가되면 서브젝트를 생성하고
// 이어지는 구독자들은 이 서브젝트를 공유한다. 첫번째와 두번째는 동일한 서브젝트로부터 이벤트를 받는다.
// 🔴 이전 3개 이벤트 받지 못함

// ⚫️ next(7)이 아니라   next(0) 으로 방출됨
// subscribed가 isDisposed 되었다가 새롭게 다시 subscribed 했기 때문이다.


// isDisposed 된 시퀀스가 다시 공유되지는 않는다. 
