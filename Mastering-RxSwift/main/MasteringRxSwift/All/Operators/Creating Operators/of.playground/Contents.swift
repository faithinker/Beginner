
import UIKit
import RxSwift

/*:
 # of
 */
// 두개 이상의 Observable을 방출하는 요소
// ObservableType의 프로토콜의 타입 메소드로 선언되어 있다.
// 가변파라미터라 원하는 수가만큼 방출 가능

let disposeBag = DisposeBag()
let apple = "🍏"
let orange = "🍊"
let kiwi = "🥝"

Observable.of(apple, orange, kiwi)
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)

// 배열이 그대로 방출
Observable.of([1, 2], [3, 4], [5, 6])
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)












