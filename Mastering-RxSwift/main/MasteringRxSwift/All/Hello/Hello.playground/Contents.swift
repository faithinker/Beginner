// 다시 한번 봐야할 부분 : Key Concepts, Subject
// 이해 잘 안갔던 부분 : 


// Swift -> 함수형프로그래밍 , POP -> RxSwift
// RxSwift는 ReactiveX를 Swift로 구현한 것이다.
//
// 장점 : 기존 코드에 비해 단순해진다.
// KVO, Noti, 바인딩, 델리게이트 패턴 등등 기존에 길게 쓰던 코드를
// 단순하고 직관적인 코드를 작성 할 수 있다.
//
// RXCocoa : 코코아터치 프레임워크에 Rx기능을 추가하는 라이브러리이다.
//

import UIKit
import RxSwift

let disposeBag = DisposeBag()

Observable.just("Hello, RxSwift")
    .subscribe{ print($0)}
    .disposed(by: disposeBag)

// var a = 1
// var b = 2
// a + b //이 연산이 실행 될 때는 각각 저장된 값을 사용해서 결과를 도출한다.
// a = 12


// a와 b의 값이 바뀔때마다 계산을 다시 실행하도록 구현하려면 Rx를 사용하는 것이 편리하다.
// Reactive Programming : 값이나 상태의 변화에 따른 새로운 결과를 도출하는 코드를 쉽게 도출할 수 있다.

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

Observable.combineLatest(a, b) { $0 + $1 }
    .subscribe(onNext: { print($0) })
    .disposed(by: disposeBag)

a.onNext(12) // 명령형 코드에서는 더하기 연산의 결과가 바뀌지 않는다.
// 하지만 Rx에서는 반응형 코드이기 때문에 값이 바뀐다.

// Observable 데이터를 방출해야...
// 구독이 가능하다.























