
import UIKit
import RxSwift

/*:
 # Scheduler
 */

// 코드를 원하는 스레드에서 실행하는 방법
// 쓰레드 처리가 필요하면 iOS는 GCD RXSwift는 Scheduler
// Scheduler 특정 코드가 실행되는 Context를 추상화 한 것이다.
// Context는 LowLevel Thread가 될수도 있고 Dispatch Queue 또는 Opertaion Queue
//
// Scheduler는 추상화된 컨텍스트이기 때문에 1대1로 매칭되지 않는다.
// 하나의 쓰레드에 두개의 개별 쓰레드가 존재하거나 하나의 쓰레드가 두개의 쓰레드에 걸쳐있는 경우도 있다.
//
// UI를 업데이트하는 코드 메인 쓰레드에서 실행한다. GCD-Main Queue, RxSwift-Main Scheduler
// 네트워크 요청처리, 데이터 주고받기, 파일 읽기 백그라운드에서 실행한다. (블로킹 때문에)  GCD-Gloabl Queue, RxSwift-Background Scheduler
//
// 다양한 기본 스케줄러를 제공한다.
// 1. Serial Scheduler
// CurrentThreadScheduler : 가장 기본적임. 기본값임
// MainScheduler : 메인 쓰레드와 연관된 스케줄러, UI업데이트시 사용
// SerialDispatchQueueScheduler : 작업을 실행할 DispatchQueue를 직접 지정

// 2. Concurrent Scheduler
// ConcurrentDispatchQueueScheduler : 작업을 실행할 DispatchQueue를 직접 지정
// OperationQueueScheduler : 실행순서를 제어하거나 동시에 실행 가능한 작업의 수를 제한하고 싶을 때
//
// UnitTest에 사용하는 TestScheduler


// 1. 옵저버블이 생성되는 시점을 정확하게 이해하기
// 옵저버블이 생성되고 연산자가 실행되는 시점은 "구독"을 하는 시점이다.
// 2. 스케줄러를 지정하는 방법
// .observeOn() : 연산자를 실행할 스케줄러를 지정. 다른 스케줄러로 변경하기 전까지 계속 사용됨. 호출 시점이 중요하다.
// .subscribeOn() : 구독을 시작하고 종료할 때 사용할 스케줄러를 지정한다. 이벤트를 방출할 스케줄러를 지정한다.

let bag = DisposeBag()

let backgroundScheduler = ConcurrentDispatchQueueScheduler(queue: DispatchQueue.global())


Observable.of(1, 2, 3, 4, 5, 6, 7, 8, 9)
   .filter { num -> Bool in
      print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> filter")
      return num.isMultiple(of: 2)
   }
   .observeOn(backgroundScheduler) // 이어지는 연산자들이 작업을 실행할 스케줄러를 지정한다. filter에는 영향 안끼침
   .map { num -> Int in
      print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> map")
      return num * 2
   }
    .subscribeOn(MainScheduler.instance) // subscribe 메소드가 실행되는 스케줄러를 지정하는 것이 아니다.
    // 이어지는 연산자가 호출되는 스케줄러를 지정하는 것도 아니다.
    // 옵저버블이 시작되는 시점에 어떤 스케줄러를 사용할지 지정하는 것이다. 호출시점이 중요하지 않다.
    .subscribe { print(Thread.isMainThread ? "Main Thread" : "Background Thread", ">> subscribe")
        print($0)
    }
    .disposed(by: bag)


// observeOn 이어지는 연산자가 실행되는 스케줄러를 지정한다.
// subscribeOn 메서드는 옵저버블이 시작되는 스케줄러를 지정한다



