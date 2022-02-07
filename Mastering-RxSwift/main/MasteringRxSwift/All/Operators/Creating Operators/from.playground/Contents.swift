
import UIKit
import RxSwift

/*:
 # from
 */
// 배열의 요소를 하나씩 방출

// public static func from(_ array: [Self.Element], scheduler: RxSwift.ImmediateSchedulerType = CurrentThreadScheduler.instance) -> RxSwift.Observable<Self.Element>

// from 리턴형 : 배열에 포함된 요소의 형식 Self.Element 이다.

let disposeBag = DisposeBag()
let fruits = ["🍏", "🍎", "🍋", "🍓", "🍇"]
let intArr = ["1", "2", "3"]

Observable.from(fruits)
   .subscribe { element in print(element) }
   .disposed(by: disposeBag)

// just : 하나의 요소를 그대로 방출하는 Observable 생성
// of : 두개 이상의 요소를 그대로 방출하는 Observable 생성
// from : 배열 자체가 아닌 그 요소들 하나씩 방출하는 Observable 생성















