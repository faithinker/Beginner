
import UIKit
import RxSwift

/*:
 # Operators
 */

// Operaotr == ObservableType
// 대부분의 연산자는 옵저버블 상에서 동작하고 새로운 Observable을 리턴한다.
// 두개 이상의 연산자를 잇달아서 호출 할 수 있다.
// 하지만 호출 순서에 따라서 다른 결과가 나오기 때문에 호출 순서에 주의해야 한다.


let bag = DisposeBag()

// 보통 subscribe 앞에 추가한다. 구독자로 전달되는 최종이벤트가 우리가 원하는 데이터가 된다.
// 호출 순서에 주의해야 한다.
Observable.from([1, 2, 3, 4, 5, 6, 7, 8, 9])
   .take(5) // 처음 5개의 요소만 방출
   .filter { $0.isMultiple(of: 2)} //2의 배수만 방출
   .subscribe { print($0) }
   .disposed(by: bag)
























