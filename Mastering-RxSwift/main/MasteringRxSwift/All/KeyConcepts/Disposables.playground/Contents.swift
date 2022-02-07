// 빌드하면 XCode 팅김현상 발생

//
//import UIKit
//import RxSwift
//
///*:
// # Disposables
// */
//
////
//// subscribe : 클로저를 파라미터로 받는다.
//// 이벤트가 전달받고 이벤트를 직접 처리한다
//// $0 -> 전체 라이프사이클 및 이벤트명까지 호출
////
//// $0.element
//// 옵셔널 바인딩 풀면  값만 빼옴
////
//// 개별 이벤트를 별도의 클로저로 처리하고 싶을 때 사용한다.
//// next이벤트 요소에 저장된 값만 출력된다.
////
//// 옵저버는 동시에 두개 이상의 이벤트를 처리하지 않는다.
//
//// 3개의 정수를 방출하는 옵저버 이벤트를 개별적으로 처리
//let subscription1 = Observable.from([1,2,3])
//    .subscribe(onNext: { elem in
//        print("Next", elem)
//    }, onError:  { error in
//        print("Error", error)
//    }, onCompleted:  {
//        print("Completed")
//    }, onDisposed: { //파라미터로 클로저를 전달하면 옵저버블과 관련된 모든 리소스가 제거된 후에 호출된다.
//        print("Disposed")
//    })
//
//subscription1.dispose() //권장X
//
//
//
// Error나 Completed로 종료되었다면 관련된 리소스가 자동으로 해지된다.
//
// 하나의 클로저에서 모든 이벤트 처리
// Disposed는 옵저버블이 전달하는 이벤트가 아니다.
// 리소스 해제와 실행취소에 사용된다.
//
//
//var bag = DisposeBag() // 권장
//
//Observable.from([1, 2, 3])
//    .subscribe {
//        print($0)
//    }
//    .disposed(by: bag)
//
//bag = DisposeBag() // 새로운 DisposeBag을 만들면 이전 disposed가 해제됨
//
//
//// Observable을 실행취소에 사용하는 경우
//let subscription2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
//    .subscribe(onNext: { elem in
//        print("Next", elem)
//    }, onError:  { error in
//        print("Error", error)
//    }, onCompleted:  {
//        print("Completed")
//    }, onDisposed: {
//        print("Disposed")
//    })
//
//
//
//// 3초 뒤에 실행 취소. dispose() 메소드 직접 호출은 가능한 하지 말아야 한다.
//DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//    subscription2.dispose()
//}
//
//
//
//
//
//
