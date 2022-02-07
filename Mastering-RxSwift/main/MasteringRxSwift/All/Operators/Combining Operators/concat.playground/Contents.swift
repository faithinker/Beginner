
import UIKit
import RxSwift

/*:
 # concat
 */

// concat 연산자 : 두 개의 옵저버블을 연결

let bag = DisposeBag()
let fruits = Observable.from(["🍏", "🍎", "🥝", "🍑", "🍋", "🍉"])
let animals = Observable.from(["🐶", "🐱", "🐹", "🐼", "🐯", "🐵"])

// ** 타입 메소드 방식 **
//public static func concat<Collection>(_ collection: Collection) -> RxSwift.Observable<Self.Element> where Collection : Collection, Collection.Element == RxSwift.Observable<Self.Element>
// 파라미터로 전달된 Collection에 있는 모든 옵저버블을 순서대로 연결한 하나의 옵저버블을 리턴한다.



Observable.concat([fruits, animals])
    .subscribe { print($0) }
    .disposed(by: bag)

print("=====================")

// ** 인스턴스 연산자로 구성된 방식 **
//
// public func concat<Source>(_ second: Source) -> RxSwift.Observable<Self.Element> where Source : RxSwift.ObservableConvertibleType, Self.Element == Source.Element
// 대상 옵저버블이 completed 이벤트를 전달한 경우에 파라미터로 전달한 옵저버블을 연결한다.
// 만약 에러이벤트가 전달된다면 옵저버블은 연결되지 않는다.
// 대상 옵저버블이 방출하는 요소만 전달되고 에러이벤트가 전달된 다음 바로 종료된다.

fruits.concat(animals)
    .subscribe { print($0) }
    .disposed(by: bag)

print("=====================")

animals.concat(fruits)
    .subscribe { print($0) }
    .disposed(by: bag)


// concat 연산자는 두 옵저버블을 연결한다.
// 단순히 하나의 옵저버블 뒤에 다른 옵저버블을 연결하기 때문에 연결된 모든 옵저버블이 방출하는 요소들이 방출 순서대로 정렬되지는 않는다.
// 이전 옵저버블이 모든 요소를 방출하고 completed 이벤트를 전달해야 이어지는 옵저버블이 방출을 시작한다.
