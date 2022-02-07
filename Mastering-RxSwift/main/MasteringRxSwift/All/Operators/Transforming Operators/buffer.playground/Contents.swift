

import UIKit
import RxSwift

/*:
 # buffer
 */

// Controlled Buffering 구현에 사용되는 buffer 연산자
// 특정 주기동안 옵저버블이 방출하는 항목을 수집하고 하나의 배열로 리턴한다.

// public func buffer(timeSpan: RxSwift.RxTimeInterval, count: Int, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<[Self.Element]>

// timespan : 항목을 수집할 시간. 시간이 경과하지 않은 경우에도 배출 가능하다.
// count : 수집할 항목의 숫자(최대숫자). 최대항목보다 적은 항목을 수집했던라도 시간이 지나면 방출한다.
// scheduler :

// return형 타입 파라미터가 배열로 선언되어 있다.
//
// RxTimeInterval이지만 DispatchTimeInterval 형을 쓴다.

// 1초마다 항목방출
// .seconds(2)  2초마다 3개씩 수집. count가 안채워저도 Max timeSpan이 경과했기 때문에 방출한다.

// .seconds(5) timeSpan이 경과하지 않더라도 count가 3개가 채워졌기 때문에 방출한다.

let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .buffer(timeSpan: .seconds(5), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0)}
    .disposed(by: disposeBag)
