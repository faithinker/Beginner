
import UIKit
import RxSwift

/*:
 # ignoreElements
 */
// Observable이 방출하는 Next이벤트를 필터링하고 Completed와 Error 이벤트만 구독자로 전달한다.
// next 이벤트를 필터링하는 ignoreElements 연산자

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]

Observable.from(fruits)
    .ignoreElements()
    .subscribe { print($0)}
    .disposed(by: disposeBag)

// Return형 : Completable  트레이치?라고 불리는 특별한 옵저버이다.
// Completable은 Completed와 Error 이벤트만 전달하고 Next이벤트는 무시한다.
// 작업의 성공과 실패에 관심이 있을 때만 사용한다.















