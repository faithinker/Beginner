
import UIKit
import RxSwift

/*:
 # flatMap
 */

// 원본 옵저버블이 항목(item)을 방출하면 flatMap 연산자가 변환함수를 실행한다. 변환함수는 방출된 항목을 옵저버블로 변환한다.
// 한개를 방출했는데 두개가 방출되는 이유 :  방출된 항목의 값이 바뀌면 flatMap 연산자가 변환한 옵저버블이 새로운 항목을 방출한다.
// 원본 옵저버블이 방출하는 항목을 지속적으로 감시하고 최신 값을 확인 할 수 있다.
// flatMap을 통해 옵저버블로 변환되고 값이 업데이트 될 때마다 새로운 항목을 배출한다.
// flatMap은 모든 옵저버블이 방출하는 항목을 모아서 최종적으로 하나의 옵저버블을 리턴한다.
//
// 개별항목 ->개별 옵저버블로 변환되었다가 -> 다시 하나의 옵저버블로 합쳐진다.

//

let disposeBag = DisposeBag()

let a = BehaviorSubject(value: 1)
let b = BehaviorSubject(value: 2)

let subject = PublishSubject<BehaviorSubject<Int>>()

subject
    .flatMap { $0.asObservable() } //subject -> Observable로 변환
    .subscribe { print($0) }
    .disposed(by: disposeBag)


// BehaviorSubject를 원하는 대로 변환한 다음 새로운 Subject를 리턴해야 한다.

subject.onNext(a) //  PublishSubject에서 A를 방출하면 flatMap을 거쳐서 새로운 옵저버블이 생성된다.
subject.onNext(b) // flatmap을 거쳐서 새로운 옵저버블이 생성되고 최종적으로 앞에서 생성된 옵저버블과 합쳐진다.

// flatMap 내부적으로 여러개의 옵저버블을 생성하지만 최종적으로 모든 옵저버블이 하나의 옵저버블로 합쳐지고 방출되는 항목들이 순서대로 구독자에게 전달된다.

a.onNext(11) // 구독자에게 새로운 항목이 전달됨
b.onNext(22) //

// flatMap 연산자는 원본 옵저버블이 방출하는 항목을 새로운 옵저버블로 변환한다.
// 새로운 옵저버블은 항목이 업데이트 될 때마다 새로운 항목을 방출한다. 이렇게 생성된 모든 옵저버블은 최종적으로 하나의 옵저버블로 합쳐지고
// 모든 항목들이 이 옵저버를 통해서 구독자로 전달된다.
// 단순히 처음에 방출된 항목만 구독자로 전달되는 것이 아니라 업데이트 된 최신 항목도 구독자로 전달된다.
// "네트워크 요청"을 구현할 때 자주 활용한다.




//  http://minsone.github.io/programming/reactive-swift-flatmap-flatmapfirst-flatmaplatest

//let sequenceInt = Observable.of(1, 2, 3)    // Int 타입 시퀀스
//let sequenceString = Observable.of("A", "B", "C", "D")    // String 타입 시퀀스
//
//print("====================")
//
//sequenceInt
//    .flatMap { (x: Int) -> Observable<String> in
//        print("Emit Int Item : \(x)")
//        return sequenceString
//    }
//    .subscribe {
//        print("Emit String Item : \($0)")
//}
