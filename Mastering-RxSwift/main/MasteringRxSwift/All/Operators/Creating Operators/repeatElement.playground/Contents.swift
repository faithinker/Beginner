
import UIKit
import RxSwift

/*:
 # repeatElement
 */
// 동일한 요소를 반복적으로 방출하는 Observable 생성
let disposeBag = DisposeBag()
let element = "❤️"

Observable.repeatElement(element)
    .take(5) // 나머지 요소는 무시
    .subscribe { print($0) }
    .disposed(by: disposeBag)








