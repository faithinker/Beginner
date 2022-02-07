
import UIKit
import RxSwift

/*:
 # startWith
 */

//  startWith 연산자 : 옵저버블 시퀀스 앞에 새로운 요소를 추가
// 옵저버블이 요소를 방출하기 전에 다른 항목들을 앞부분에 추가한다.
// 기본값이나 시작값을 지정할 때 시작한다.


let bag = DisposeBag()
let numbers = [1, 2, 3, 4, 5]


Observable.from(numbers)
    .startWith(11)
    .startWith(-1,-2)
    .subscribe{ print($0) }
    .disposed(by: bag)

//  public func startWith(_ elements: Self.Element...) -> RxSwift.Observable<Self.Element>
// 가변 파라미터이다.
// 
// LIFO 구조
