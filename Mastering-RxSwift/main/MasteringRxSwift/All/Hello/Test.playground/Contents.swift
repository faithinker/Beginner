import UIKit
import RxSwift

// https://kyungmosung.github.io/
// https://kyungmosung.github.io/2019/12/11/rxswift-transforming-operators/

let words = ["Apple","Banana","Orange","Book","City","Axe"]


let disposeBag = DisposeBag()

// 첫번째 문자로 그룹핑
Observable.from(words)
    .groupBy { $0.first }
    .flatMap{ $0.toArray() }
    .subscribe{ print($0) }
    .disposed(by: disposeBag)


// 홀짝으로 그룹핑
Observable.range(start: 1, count: 10)
    .groupBy{ $0.isMultiple(of: 2) }
    .flatMap{ $0.toArray() }
    .subscribe{ print($0) }
    .disposed(by: disposeBag)




let fruits = Observable.from(["🍏", "🍎"])
let animals = Observable.from(["🐶", "🐱"])

// 타입 메소드
Observable.concat([animals, fruits]) // 먼저 들어온놈 다 처리
    .subscribe{ print($0) }
    .disposed(by: disposeBag)

// 인스턴스 메소드
fruits.concat(animals)
    .subscribe{ print($0) }
    .disposed(by: disposeBag)
