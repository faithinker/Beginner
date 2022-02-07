
import UIKit
import RxSwift

/*:
 # withLatestFrom
 */

// withLatestFrom 연산자 : 트리거 옵저버블이 Next 이벤트를 방출하면 데이터 옵저버블이 가장 최근에 방출한 Next 이벤트를 구독자에게 전달하는 

// triggerObservable.withLatestFrom(dataObservable)
// triggerObservable : 연산자를 호출하는 옵저버블  Next 이벤트 방출
// dataObservable : 파라미터로 전달하는 옵저버블   가장 최근에 방출한 이벤트를 구독자에게 전달
// 회원가입 탭하는 시점에 textField에 입력된 값을 가져올 때 사용


//    public func withLatestFrom<Source, ResultType>(_ second: Source, resultSelector: @escaping (Self.Element, Source.Element) throws -> ResultType) -> RxSwift.Observable<ResultType> where Source : RxSwift.ObservableConvertibleType
//
// 두가지 형태로 사용한다.
// second 데이터 옵저버블 resultSelector 클로저를 파라미터로 받는다. 클로저에는 두 옵저버블이 방출하는 요소를 받는다.
// 리턴 : Observable<ResultType> 클로저가 리턴하는 결과를 방출함


//     public func withLatestFrom<Source>(_ second: Source) -> RxSwift.Observable<Source.Element> where Source : RxSwift.ObservableConvertibleType
// trigger 옵저버블에서 Next이벤트를 전달하면 파라미터로 전달한 data 옵저버블에서 가장 최근에 방출한 Next이벤트를 가져온다.
// 이벤트에 포함된 요소를 방출하는 옵저버블을 리턴한다.

let bag = DisposeBag()

enum MyError: Error {
   case error
}

let trigger = PublishSubject<Void>()
let data = PublishSubject<String>()

trigger.withLatestFrom(data)
    .subscribe { print($0) }
    .disposed(by: bag)

data.onNext("Hello")

trigger.onNext(())
trigger.onNext(())

// trigger 옵저버블로 next이벤트가 전달되면 data 옵저버블에 있는 최신 next이벤트를 구독자에게 전달한다.

//data.onCompleted()
//data.onError(MyError.error)
//trigger.onNext(())


// data 옵저버블이 Completed를 해도 구독이 계속 이뤄지지만 Error 보내면 에러뜨고 구독 해제한다.

trigger.onCompleted()
//trigger.onError(MyError.error)
// 바로 trigger 옵저버블은 구독자에게 바로 전달됨
