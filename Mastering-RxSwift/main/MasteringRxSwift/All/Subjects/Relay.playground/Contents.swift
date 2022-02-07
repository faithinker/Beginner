
import UIKit
import RxCocoa
import RxSwift

/*:
 # Relay
 */

// Subject와 유사한 특징을 가지고 있고 내부에 Subject를 Wrapping하고 있다.
// 다른 소스로부터 이벤트를 받아서 구독자에게 전달한다는 점은 Subject와 유사하지만 Next이벤트만 전달받고 전달한다.
// Subject와 달리 종료되지 않는다.(Error나 Completed를 받거나 전달하지 않으니깐)
// 아예 onError 메소드 자체가 없다.
//
// 구독자가 disposed 되기 전까지 계속 이벤트를 처리한다. 그래서 주로 UI 이벤트 처리에 활용한다.
// RxCocoa 프레임을 통해 제공된다.

let bag = DisposeBag()



let hideTooltip = BehaviorRelay<Bool>(value: true)

// 부정을 해주자.
hideTooltip.accept(!hideTooltip.value)



let prelay = PublishRelay<Int>()

prelay.subscribe { print("1:",$0)}
    .disposed(by: bag)

prelay.accept(1) //onNext가 아니라 accept을 쓴다.

let brelay = BehaviorRelay<Int>(value: 0)

brelay.accept(2) // 내부에 저장된 값이 교체된다.

brelay.subscribe {
    print("2: \($0)")
    print("value : ",$0.element!)
}
    .disposed(by: bag)

brelay.accept(3) //추가된것이 아니라 교체 된 것이다.

// BehaviorRelay는 Value라는 속성을 제공한다. Relay이벤트가 저장하고 있는 Next 이벤트에 접근해서 값을 리턴한다.
print(brelay.value)
// Read(읽기)전용이고 값을 Write(바꾸지는) 못한다.


enum MyError: Error {
   case error
}
