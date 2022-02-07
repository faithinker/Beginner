// 데이터를 UI에 표시함 Cocoa 터치로 구현한 바인딩 코드를 Rx Cocoa로 구현
// 옵저버블(데이터생산자), UI Component(데이터소비자)
// 생산자가 생산한 데이터는 소비자에게 전달되고 소비자는 적절한 방식으로 데이터를 소비한다. 단방향 데이터 스트림(흐름)이다.
//
// 바인더(Binder)는 UI 바인딩에 사용되는 특별한 옵저버이다. 데이터 소비자의 역할을 수행한다.
// 옵저버이기 때문에 바인더로 새로운 값을 전달할 수 있지만 옵저버블이 아니기 때문에 구독자를 추가하는 것은 불가능하다.
// 에러 이벤트를 받지 않는다. 에러 이벤트를 전달하면 실행모드에 따라서 에러메시지 혹은 크래시가 발생한다.
// 옵저버에서 에러 이벤트가 전달되면 옵저버블 시퀀스가 종료된다. next 이벤트가 전달되지 않으면 바인딩된 UI가 업데이트 되지 않는다.
// 바인더는 바인딩이 메인 쓰레드에서 실행되는 것을 보장한다.


import UIKit
import RxSwift
import RxCocoa

class BindingRxCocoaViewController: UIViewController {
   
   @IBOutlet weak var valueLabel: UILabel!
   
   @IBOutlet weak var valueField: UITextField!
   
   let disposeBag = DisposeBag()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      valueLabel.text = ""
      valueField.becomeFirstResponder()
      
//    valueField.rx.text  // Controlproperty 형식으로 선언되어 있고 Controlproperty은 특별한 옵저버블이다.
//        .observeOn(MainScheduler.instance)
//        .subscribe(onNext: { [weak self] str in
//                self?.valueLabel.text = str
//        })
//        .disposed(by: disposeBag)
// RxCocoa가 확장한 텍스트 속성은 텍스트 필드에 입력된 값이 업데이트 될때마다 next 이벤트를 전달한다.
    
      valueField.rx.text
          .bind(to: valueLabel.rx.text)
          .disposed(by: disposeBag)
   }

   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      valueField.resignFirstResponder()
   }
}

// 결과는 같지만...
// 장점
// 코드가 단순하다.
// delegate 구현할 필요가 없고
// 최종 문자를 조합하는 코드를 작성할 필요가 없다.
//
// 데이터 흐름을 쉽게 파악할 수 있다.
//
// subscribe가 메인 혹은 백그라운드에서 실행 될 수도 있다. (지금은 UI 업데이트이기 때문에 자동으로 메인에서 실행함)
// 해결책
// 1. GCD 사용
//.subscribe(onNext: { [weak self] str in
//    DispatchQueue.main.async {
//        self?.valueLabel.text = str
//    }
//})
//
// 2. Rx Operator 사용
//.observeOn(MainScheduler.instance)
//.subscribe(onNext: { [weak self] str in
//        self?.valueLabel.text = str
//})
//
// 3. Rx Cocoa의 특성 사용.
// .bind(to: <#T##ObserverType...##ObserverType#>) 옵저버타입을 받는 bind to 메소드 사용
// Binder는 UI에 바인딩에 사용하는 특별한 옵저버
// valueField.rx.text
//    .bind(to: valueLabel.rx.text)
//    .disposed(by: disposeBag)
// 옵저버블이 방출한 이벤트를 옵저버에게 전달한다. rxCocoa가 UILabel에게 추가한 text 속성을 전달
// textField의 text와 Label의 text가 바인딩된다.
//
// 결과적으로 Bind를 사용함으로 코드가 더 단순해지고 쓰레드에 대해 신경 쓸 필요가 없다.
// text(Binder)가 바인딩을 메인쓰레드에서 실행해준다.
