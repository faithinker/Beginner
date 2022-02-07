
import UIKit
import RxSwift

/*:
 # map
 */

// 원본 옵저버블이 방출하는 요소(항목,item)를 대상으로 함수를 실행하고 결과를 새로운 옵저버블로 리턴하는 map 연산자


let disposeBag = DisposeBag()
let skills = ["Swift", "SwiftUI", "RxSwift"]

Observable.from(skills)
//    .map { "Heelo, \($0)"}
    .map { $0.count }
//    .map { $0.hasPrefix("Hello") }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// map 연산자는 옵저버블이 방출하는 요소를 대상으로 클로저를 실행하고 그 결과를 구독자에게 전달한다.
// 클로저로 전달되는 파라미터의 형식은 source 옵저버블이 방출하는 요소와 동일하다.
// 하지만 클로저가 리턴하는 값의 형식은 고정되어 있지 않다. 

