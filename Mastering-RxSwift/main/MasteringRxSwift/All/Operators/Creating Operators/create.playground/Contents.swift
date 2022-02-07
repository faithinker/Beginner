
import UIKit
import RxSwift

/*:
 # create
 */
// 앞의 Operator들은...
// 파라미터로 전달된 요소를 방출하는 Observable을 생성한다.
// 모든 요소를 방출하고 completed 이벤트를 전달하고 종료된다.
// 앞의 연산자들은 동작을 바꿀 수 없다.
//
// create 연산자를 통해서 Observable이 동작하는 방식을 직접 구현
// 처음부터 Observable(데이터 방출자)을 만들 수 있다.

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}

//Single.create { (@escaping PrimitiveSequence<SingleTrait, _>.CompletableObserver) -> Disposable in
//    <#code#>
//}

// create : observer를 파라미터로 받아서 Disposables 리턴하는 클로저를 전달
// 리턴형은 Disposable이다. Disposable 마지막에 S 붙여야 한다.
Observable<String>.create { (observer) -> Disposable in // observer :  AnyObserver<String> 이다.
    guard let url = URL(string: "https://apple.com")
        else {
        observer.onError(MyError.error) // 구독자에게 error전달
        return Disposables.create()
    }
    
    guard let html = try? String(contentsOf: url, encoding: .utf8)
        else {
        observer.onError(MyError.error)
        return Disposables.create()
        }
    // 여기까지 오면 error없이 잘 실행된거. 이제 옵저버 방출
    observer.onNext(html)
    observer.onCompleted()
    
    observer.onNext("After Completed") //Completed 되었기 때문에 방출 안됨
    
    return Disposables.create()
}
.subscribe { print($0) }
.disposed(by: disposeBag)

// Create 규칙
// 요소를 방출할 때는 onNext 메소드를 사용하고 파라미터로 방출할 요소를 전달한다.
// Observable은 하나 이상의 요소를 방출하기도 하지만 아예 방출 안할 수도 있다.
// 반드시 onNext를 호출할 필요는 없다.
// Observable을 종료하기 위해서는 onError, onCompleted 메소드를 반드시 호출해야 한다.
// onNext는  onError, onCompleted 두 이벤트를 전달하기 전에 호출해야 한다.

// observer :  AnyObserver<Int> 이다.
Observable<Int>.create { (observer) -> Disposable in
    print("observer : \(observer), \t Type : \(type(of: observer))")
    observer.onNext(1)
    observer.onCompleted()
    return Disposables.create()
}
.subscribe {
    print($0,"\t" ,type(of: $0))
}
.disposed(by: disposeBag)

Observable<Int>.create {
    $0.onNext(10)
    return Disposables.create()
}
.subscribe {
    print("Event Int를 방출한다. \($0)")
}
