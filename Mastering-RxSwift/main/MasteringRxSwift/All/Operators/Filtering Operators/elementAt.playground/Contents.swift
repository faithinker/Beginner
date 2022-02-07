
import UIKit
import RxSwift

/*:
 # elementAt
 */
// 특정 인덱스에 위치한 요소를 제한적으로 방출하는 방법

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]

Observable.from(fruits)
    .elementAt(1)
    .subscribe { print($0)}
    .disposed(by: disposeBag)


// 정수 index를 파라미터로 받아서 옵저버블을 리턴한다.
// 연산자가 리턴하는 옵저버블은 해당 인덱스에 있는 하나의 요소를 방출하고 completed Event를 전달한다.
// 구독자에게는 하나의 요소만 전달되고 원본 옵저버블이 방출하는 나머지 요소는 무시된다.
// 












