// RxCocoa가 제공하는 Traits 중에서 가장 : 데이터를 UI에 바인딩하는 직관적이고 효율적인 방법을 제공
// Driver는 특별한 옵저버이고 UI 처리에 특화된 몇가지 특징을 가지고 있다.
// 에러 메시지를 전달하지 않는다. 오류로 인해 UI처리가 중단되는 상황은 발생하지 않는다.
// 스케줄러를 강제로 변경하는 경우를 제외하고 항상 메인 쓰레드에서 실행된다. 이벤트는 항상 메인 스케줄러에서 전달되고 이어지는 작업 역시 메인스케줄러에서 진행된다.
// Driver는 사이트 이팩트를 공유한다. 일반 옵저버블에서 share 연산자를 호출한다.
// 모든 구독자가 시퀀스를 공유하고 새로운 구독이 시작되면 가장 최근에 전달된 이벤트가 즉시 전달된다.
 

import UIKit
import RxSwift
import RxCocoa

enum ValidationError: Error {
   case notANumber
}

class DriverViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var inputField: UITextField!
   
   @IBOutlet weak var resultLabel: UILabel!
   
   @IBOutlet weak var sendButton: UIButton!
   
    // drive는 모든 작업이 메인쓰레드에서 실행하는 것을 보장하기 때문에 스케줄러를 지정할 필요가 없다.
    // 시퀀스를 자동으로 공유하기 때문에 불필요한 리소스 낭비를 막아주는 장점이 있다. 동시에 에러처리까지 단순하게 할 수 있다.
    // UIBinding 코드를 작성할 때 Drive 코드를 적극적으로 활용하자.
   override func viewDidLoad() {
      super.viewDidLoad()
      
    let result = inputField.rx.text.asDriver()
        .flatMapLatest {
            validateText($0)
                .asDriver(onErrorJustReturn: false)
        }
                
    
      result
         .map { $0 ? "Ok" : "Error" }
         .drive(resultLabel.rx.text)
         .disposed(by: bag)

      result
         .map { $0 ? UIColor.blue : UIColor.red }
         .drive(resultLabel.rx.backgroundColor)
         .disposed(by: bag)

      result
         .drive(sendButton.rx.isEnabled)
         .disposed(by: bag)
      
   }
}


func validateText(_ value: String?) -> Observable<Bool> {
   return Observable<Bool>.create { observer in
      print("== \(value ?? "") Sequence Start ==")
      
      defer {
         print("== \(value ?? "") Sequence End ==")
      }
      
      guard let str = value, let _ = Double(str) else {
         observer.onError(ValidationError.notANumber)
         return Disposables.create()
      }
      
      observer.onNext(true)
      observer.onCompleted()
      
      return Disposables.create()
   }
}


// 원본 코드 에러발생(문자입력)하면 앱 크래시 남. 시퀀스도 세번 호출하므로 굉장히 안좋은 코드
// 동일한 요청을 세번 실행하는 나쁜 코드(불필요한 리소스 낭비)
//override func viewDidLoad() {
//   super.viewDidLoad()
//
//   let result = inputField.rx.text
//      .flatMapLatest { validateText($0) }
//
//   result
//      .map { $0 ? "Ok" : "Error" }
//      .bind(to: resultLabel.rx.text)
//      .disposed(by: bag)
//
//   result
//      .map { $0 ? UIColor.blue : UIColor.red }
//      .bind(to: resultLabel.rx.backgroundColor)
//      .disposed(by: bag)
//
//   result
//      .bind(to: sendButton.rx.isEnabled)
//      .disposed(by: bag)
//
//}

// 1차 수정코드
// 에러 이벤트 때문에 크래시 발생하거나 UI가 업데이트되지 않는 문제도 해결되었다.
//override func viewDidLoad() {
//   super.viewDidLoad()
//
//   let result = inputField.rx.text
//     .flatMapLatest {
//         validateText($0)  // inner 옵저버블이 백그라운드스케줄러에서 결과를 리턴한다면 UI바인딩이 잘못된 쓰레드에서 실행 될수도 있다.
//             .observeOn(MainScheduler.instance) // 직접 지정해서 잠재적 문제 방지
//             .catchErrorJustReturn(false) }
//      .share()
//
//   result
//      .map { $0 ? "Ok" : "Error" }
//      .bind(to: resultLabel.rx.text)
//      .disposed(by: bag)
//
//   result
//      .map { $0 ? UIColor.blue : UIColor.red }
//      .bind(to: resultLabel.rx.backgroundColor)
//      .disposed(by: bag)
//
//   result
//      .bind(to: sendButton.rx.isEnabled)
//      .disposed(by: bag)
//
//}
