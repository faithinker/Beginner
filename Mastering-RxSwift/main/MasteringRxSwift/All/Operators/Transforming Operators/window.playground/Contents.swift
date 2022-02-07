
import UIKit
import RxSwift

/*:
 # window
 */

// Buffer 연산자처럼 timeSpan Max count를 지정해서 원본 옵저버블이 방출하는 항목들을 작은 단위의 옵저버블로 분해한다.
// buffer 연산자는 수집된 항목을 "배열" 형태로 리턴하지만 window 연산자는 수집된 항목을 방출하는 옵저버블을 리턴한다.
// 리턴된 옵저버블이 무엇을 방출하고 언제 완료되는지 이해하는게 중요하다.


// 시간 또는 count의 최대 범위를 넘어서면 방출한다.

let disposeBag = DisposeBag()

Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    .window(timeSpan: .seconds(2), count: 3, scheduler: MainScheduler.instance)
    .take(5)
    .subscribe { print($0)
        // inner observable 구독
        if let observable = $0.element {
            observable.subscribe { print(" inner: ", $0)}
        }
    }
    .disposed(by: disposeBag)



// public func window(timeSpan: RxSwift.RxTimeInterval, count: Int, scheduler: RxSwift.SchedulerType) -> RxSwift.Observable<RxSwift.Observable<Self.Element>>
//
// timespan : 항목을 분해할 시간단위 전달
// count : 분해할 최대 항목수를 전달
// 연산자를 실행할 스케줄러 지정
// Inner Observable 옵저버블을 방출하는 옵저버블을 리턴한다.
// 지정된 최대 항목 수 만큼 리턴하거나 지정된 시간이 경과하면 completed 이벤트를 전달하고 종료한다.
//
// Inner Observable == RxSwift.AddRef<Swift.Int> 옵저버블이고 구독할 수 있다


