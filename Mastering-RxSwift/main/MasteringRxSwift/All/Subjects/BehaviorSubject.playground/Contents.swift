
import UIKit
import RxSwift



/*:
 # BehaviorSubject
 */

// Subject로 전달된 이벤트를 구독자(옵저버)에게 전달하는 것은 PublishSubject와 동일하다.
// Subject 생성 방식에 차이가 있고(초기값 존재) onNext 이벤트 전달 후에 구독을 하더라도 값을 방출한다.
// subscribe가 발생하면, 발생한 시점 이전에 발생한 이벤트 중 가장 최신의 이벤트를 전달받는다.

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

let p = PublishSubject<Int>()

p.onNext(10)
p.subscribe { print("PublishSubject >>", $0)}
    .disposed(by: disposeBag)

let b = BehaviorSubject<Int>(value: 0)
// 타입 파라미터가 Int이기 때문에 value에 숫자 전달

b.subscribe { print("BehaviorSubject >>", $0)}
    .disposed(by: disposeBag)


// 내부에 이벤트가 저장되지 않은 상태로 저장된다.
// 내부에 next이벤트가 만들어지고 생성자로 전달한 값이 저장된다.

b.onNext(1)
b.onNext(2)
b.subscribe{ print("BehaviorSubject2 >>", $0)}
    .disposed(by: disposeBag)

// 생성 시점에 만들어진 next이벤트를 저장하고 있다가 새로운 옵저버에게 전달한다.
// 이후에 새로운 next이벤트가 전달되면 기존에 저장되어 있던 이벤트를 교체한다.
// 결과적으로 가장 최신의 next이벤트를 옵저버로 교체한다.

//b.onCompleted()
b.onError(MyError.error)

b.subscribe{ print("BehaviorSubject 3 >>", $0)}
    .disposed(by: disposeBag)

// BehaviorSubject는 가장 최근의 Next이벤트를 저장했다가 새로운 구독자로 전달한다.
// 최신 이벤트를 제외한 나머지 이벤트는 사라진다.

