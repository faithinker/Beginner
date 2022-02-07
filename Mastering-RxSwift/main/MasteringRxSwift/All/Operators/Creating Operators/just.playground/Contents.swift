
import UIKit
import RxSwift

/*:
 # just
 */



// 하나의 항목을 방출하는 Observable을 생성

let disposeBag = DisposeBag()
let element = "😀"

Observable.just(element) //방출
   .subscribe { event in print(event) }
   .disposed(by: disposeBag)

// just로 생성한 Observable은 파라미터로 전달한 요소를 그대로 방출한다.
Observable.just([1, 2, 3])
   .subscribe { event in print(event) }
   .disposed(by: disposeBag)














