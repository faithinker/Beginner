
import UIKit
import RxSwift

/*:
 # Observables
 */

// Observer는 관찰자, 구독자
// Observable 방출자
//
// Observable = Observables Sequence = Sequence
// Observable은 Observer에게 이벤트를 전달(방출)한다.
// Observer는 Observable을 감시하고 있다가 전달되는 이벤트를 처리한다.
// Subscribe(구독) : Observer(Subscriber)가 Observable을 감시하는 것



// Observable은 3가지 이벤트를 전달한다.
// Next : Observable에서 발생한 새로운 이벤트를 Next를 통해서 Observer에게 전달된다.
// Emission(방출, 배출)이벤트에 값이 포함되어 있다면 Next 이벤트와 함께 전달된다.
//
// Error : Observable에서 에러가 발생하면 Error이벤트가 전달되고
// Completed : 정상적으로 전달되면 Completed 이벤트가 전달된다.
// 두 이벤트는 Observable LifeCycle에서 가장 마지막에 전달되고 Notification이라고 부른다.
// 이후 Observable이 종료되고 모든 Resource가 정리된다. 다른 이벤트는 전달되지 않는다.
//
// Observable Marbel Diagram
// 화살표 상대적인 시간의 흐름
// 개별원 : Next Event 값을 포함할 수 있고 원 내부에 저장된 값을 표시한다.
// | (Completed) ,X (Error) Observable LifeCycle이 종료된다.
//

// 차가운 Observable, 뜨거운 Observable
// "차가운" Observable
// "뜨거운" Observable




// #1 이벤트 연산자 직접구현
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0)) // 구독자로 0이 저장되어 있는 next 이벤트를 전달한다.
    observer.onNext(1)
    
    observer.onCompleted() //Completed 이벤트가 전달되고  Observable이 종료된다.
    
    return Disposables.create() // Disk 정리에 필요한 객체
}

// #2 다른 연산자 활용 미리 정의된 규칙에 따라서 이벤트를 전달한다.
Observable.from([0,1]) //배열에 잇는 요소를 순서대로 방출하고 Completed 이벤트를 전달한다.

// Observable 생성된 상태일 뿐이다. 정수가 방출되거나 이벤트가 전달되지 않는다.
// 어떤 순서로 전달되어야 하는지 정의할 뿐이다.
// Observer(Subscriber)가 Observable을 구독(감시)하는 시점 : 클로저 혹은 연산자의 이벤트가 전달되는 시점
//





var bag = DisposeBag() // 권장

let o1 = Observable.from([1, 2, 3])

o1
    .subscribe { print($0) }
    .disposed(by: bag)

o1
    .subscribe {print ($0) }
    .disposed(by: bag)
























