
import UIKit
import RxSwift

/*:
 # groupBy
 */

// 방출되는 요소를 조건에 따라 그룹핑하는 groupBy 연산자


let disposeBag = DisposeBag()
let words = ["Apple", "Banana", "Orange", "Book", "City", "Axe"]


// 파라미터 클로저를 받고 클로저는 요소를 파라미터로 받아서 키를 리턴함 키의 형식은 Hashable
// 연산자를 실행하면 클로저에서 동일한 값을 리턴하는 요소끼리 그룹으로 묶이고 그룹에 속한 요소들은 개별 옵저버를 통해 방출된다.


// 1분짜리 설명 다시
// 리턴형이 타입파라미터로 GroupedObservable이고  옵저버블을 방출함


Observable.from(words)
    .groupBy { $0.count}
    .subscribe { print($0) }
    .disposed(by: disposeBag)

print("===============")

Observable.from(words)
    .groupBy { $0.count}
    .subscribe(onNext : { groupedObservable in
        print("== \(groupedObservable.key)")
                groupedObservable.subscribe { print("  \($0) ")}
    })
    .disposed(by: disposeBag)

// flatMap, toArray 연산자를 활용해서 그룹핑된 최종 결과를 하나의 배열로 방출하도록 구현한다.

print("===============")

// 문자열 길이로 그룹핑 된 4개의 문자열 방출
Observable.from(words)
    .groupBy { $0.count}
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

// 첫번째 값 기준으로 그룹핑함
Observable.from(words)
    .groupBy { $0.first ?? Character(" ") }
    .flatMap { $0.toArray() }
    .subscribe { print($0) }
    .disposed(by: disposeBag)

print("======== Assignment ====== ")

// Assignment - groupBy를 사용해서 홀수와 짝수로 나눠라 => 나머지값이 0이냐 1이냐
Observable.range(start: 1, count: 10)
    .groupBy { $0%2 == 0 }  // 나머지 값이 0이면 짝수 1이면 홀수
    .flatMap { $0.toArray() } //두개의 옵저버를 한개의 옵저버로 (  하나의 옵저버블로 합침 )
    .subscribe { print($0) }
    .disposed(by: disposeBag)


print("================")
