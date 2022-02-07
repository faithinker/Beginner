
import UIKit
import RxSwift

/*:
 # zip
 */
//  zip 연산자 : Indexed Sequencing을 구현
// Source 옵저버블이 방출하는 요소를 결합한다.
//
// combineLatest : Source 옵저버블 중에서 하나라도 요소를 방출하면 가장 최근 요소를 대상으로 클로저를 실행한다.
// Zip : 클로저에게 중복된 요소를 전달하지 않는다. 반드시 Index 기준으로 짝을 일치시켜서 전달한다.
// 결합할 짝이 없는 요소들은 구독자에게 전달되지 않는다.
// Indexed Sequencing : 소스 옵저버블이 방출하는 요소를 순서를 일치시켜서 결합하는 것


let bag = DisposeBag()

enum MyError: Error {
   case error
}

let numbers = PublishSubject<Int>()
let strings = PublishSubject<String>()

Observable.zip(numbers, strings) { " \($0) - \($1)"}
    .subscribe { print($0) }
    .disposed(by: bag)

numbers.onNext(1)
strings.onNext("one")

numbers.onNext(2)
strings.onNext("two")

// 항상 방출된 순서대로 짝을 이룬다.

numbers.onCompleted()
//numbers.onError(MyError.error)

strings.onNext("three")
strings.onCompleted()

// combineLatest와 달리 Source 옵저버블 중에 하나라도 Completed 이벤트를 전달하면 이후에는 Next이벤트가 전달되지 않는다.
// 모든 Source 옵저버블이 Completed해야 구독자에게 Completed 이벤트가 전달된다.
