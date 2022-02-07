
import UIKit
import RxSwift

/*:
 # deferred
 */

// 특정조건에 따라서 Observable을 생성할 수 있다.
// defer : 미루다 연기, infer 추론, 불러오다.
let disposeBag = DisposeBag()
let animals = ["🐶", "🐱", "🐹", "🐰", "🦊", "🐻", "🐯"]
let fruits = ["🍎", "🍐", "🍋", "🍇", "🍈", "🍓", "🍑"]
var flag = true

// Generic parameter 'Element' could not be inferred
// 타입 annotation 추가 : Observable<String>
// let factory: Observable<String> = Observable.deferred { // 또는 아래처럼
let factory = Observable<String>.deferred {
    flag.toggle() // flag 상태 뒤집는다.
    if flag {
        return Observable.from(animals)
    }
    else {
        return Observable.from(fruits)
    }
}

// 새로운 구독자가 추가되는 시점에 deferred 연산자로 전달한 클로저가 실행되고 새로운 Observable이 생성된다.

factory
    .subscribe { print($0)} // Event<String> 방출
    .disposed(by: disposeBag)


factory
    .subscribe { print($0)}
    .disposed(by: disposeBag)

factory
    .subscribe { print($0)}
    .disposed(by: disposeBag)





