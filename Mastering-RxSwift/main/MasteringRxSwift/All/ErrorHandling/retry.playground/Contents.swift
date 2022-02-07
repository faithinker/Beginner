
import UIKit
import RxSwift

/*:
 # retry
 */

// retry 연산자를 활용한 오류 처리 패턴

// 옵저버블애서 에러가 발생하면 옵저버블에 대한 구독을 해제하고 새로운 구독을 실행한다.
// 옵저버블 시퀀스는 처음부터 다시 실행한다.



let bag = DisposeBag()

enum MyError: Error {
   case error
}

var attempts = 1

let source = Observable<Int>.create { observer in
   let currentAttempts = attempts
   print("#\(currentAttempts) START") // 시퀀스의 시작
   
   if attempts < 3 {
      observer.onError(MyError.error)
      attempts += 1
   }
   
   observer.onNext(1)
   observer.onNext(2)
   observer.onCompleted()
         
   return Disposables.create {
      print("#\(currentAttempts) END")
   }
}

source
   .retry(6)
   .subscribe { print($0) }
   .disposed(by: bag)

// public func retry(_ maxAttemptCount: Int) -> RxSwift.Observable<Self.Element>
// maxAttemptCount 최대 재시도 횟수 제한 : 실제로 재시도한 횟수는 파라미터 값이 아니라 n-1 번 재시도한다.
// 첫번째는 재시도 횟수가 아니기 때문이다.
// 재시도 횟수 넘어서도 error 하면 error 알림 처리하고 구독 해제된다.
// error 발생한 즉시 재시도 하기 때문에 개발자가 재시도 "시점"을 제어하는 것은 불가능하다.
// 사용자가 재시도 버튼을 탭하는 시점에만 재시도 할 수 있도록 구현하는 법


// .retry() 무한루프(재시도)가 될 수 있어 앱이 비정상적으로 종료 될 수 있다. 권장 X
