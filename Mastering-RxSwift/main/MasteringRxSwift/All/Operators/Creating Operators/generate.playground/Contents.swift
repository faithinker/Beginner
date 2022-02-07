
import UIKit
import RxSwift

/*:
 # generate
 */
// 증가되는 크기를 바꾸거나 감소하는 시퀀스를 생성

let disposeBag = DisposeBag()
let red = "🔴"
let blue = "🔵"

// initialState : 시작값 = 가장 먼저 배출
// condition : true를 리턴하는 경우에만 요소를 방출한다. false 전달시 바로 Completed 전달하고 종료
// iterate : 값을 바꾸는 코드 전달

//

Observable.generate(initialState: 0, condition: { $0 <= 10 }, iterate: { $0 + 2})
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable.generate(initialState: 10, condition: { $0 >= 0 }, iterate: { $0 - 2})
    .subscribe { print($0) }
    .disposed(by: disposeBag)

Observable.generate(initialState: red, condition: { $0.count < 10 }, iterate: { $0.count.isMultiple(of: 2) ? $0 + red : $0 + blue})
    .subscribe { print($0) }
    .disposed(by: disposeBag)




