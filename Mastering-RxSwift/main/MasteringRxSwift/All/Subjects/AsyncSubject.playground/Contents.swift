
import UIKit
import RxSwift
import RxCocoa

/*:
 # AsyncSubject
 */
// 이벤트를 전달하는 시점에 차이가 있다.
// Publish, Behavior, Replay는 Subject로 이벤트가 전달되면 즉시 구독자(옵저버)에게 전달한다.
// AsyncSubject는 Subject로 Completed 이벤트가 전달되기 전까지 어떤 이벤트도 구독자에게 전달하지 않는다.
// Completed가 전달되면 가장 최근에 전달된 Next 이벤트 하나를 구독자에게 전달한다.

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let a = AsyncSubject<Int>()

a.subscribe{ print("Async 1:", $0)}
    .disposed(by: bag)

a.onNext(1)

a.subscribe{ print("Async 2:", $0)}
    .disposed(by: bag)


a.onNext(10)

a.onCompleted()
//a.onError(MyError.error)

// Async는 Completed 이벤트가 전달된 시점을 기준으로 가장 최근에 전달된 하나의 이벤트만 구독자에게 전달한다.
// 이벤트가 없다면 Completed 이벤트만 전달하고 종료하거나
// Error를 만나면 이벤트 전달없이 Error만 전달하고 끝이 난다.

