// RxCocoa Traits
// Traits : UI에 특화된 옵저버블이다. UI 바인딩에서 데이터 생산자 역할을 수행한다. <-> 바인더(소비자)와 반대된다.
// 4가지 Traits 를 제공한다. ControlProperty, ControlEvent, Driver, Signal 이다.
//
// 공통적인 특징은 UI에 특화된 옵저버블이고 모든 작업은 Main Thread(스케줄)에서 실행된다.
// 그래서 UI Update Code를 작성 할 때 코드를 직접 지정할 필요가 없다.
//
// 옵저버블 시퀀스가 Error 이벤트로 인해 종료되면 UI는 더이상 업데이트 되지 않는다.
// 하지만 Traits는 에러 이벤트를 전달하지 않는다. 그래서 업데이트가 안되는 문제가 발생하지 않는다.
// UI가 항상 올바른 쓰레드에서업데이트 하는것을 보장한다.
//
// 옵저버블을 구독하면 새로운 시퀀스가 시작된다. Traits 역시 옵저버블 이지만 새로운 시퀀스가 시작되지는 않는다.
// Traits 구독하는 모든 구독자는 동일한 시퀀스를 공유한다. 일반 옵저버블에서 share 연산자를 사용한 것과 동일한 방식으로 사용한다.
//
//
//
// RxCocoa에서 Trait는 중요하지만 필수적이지는 않다. subscribe를 통해 대체 할 수 있기 때문이다.
// 단지 코드가 많이 지저분해지고 UI 코드가 잘못된 쓰레드에서 실행될 가능성이 높아진다.
// Trait는 UI 구현에 있어 매우 중요한 요소이다. 항상 메인쓰레드에서 UI를 실행해 주고 단순한 코드를 작성 할 수 있다.
//
//
//
//
// ControlProperty ControlEvent
// Cocoa Framework가 제공하는 뷰에는 다양한 속성이 선언되어 있다.
// RxCocoa는 Extension으로 뷰를 확장하고 동일한 이름을 가진 속성을 추가한다.
// 대부분 ControlProperty 형식으로 선언되어 있다.
// ControlProperty는 제너릭 구조체로 선언되어 있고 ControlPropertyType 프로토콜을 채택하고 있다.
// ControlPropertyType 프로토콜은 옵저버블타입과 옵저버 타입을 상속하고 있다. 특별한 옵저버블이면서 옵저버이다.
// ControlProperty가 읽기전용 속성만 확장했다면 옵저버블의 역할만
// ControlProperty가 읽기쓰기가 모두 가능하다면 옵저버의 역할도 함께 수행한다.
//
// ControlProperty의 특징
// UI 바인딩에 사용되므로 에러 이벤트를 전달받지도 전달하지도 않는다.
// Completed 이벤트는 컨트롤이 제거되기 직전에 전달된다.
// 모든 이벤트는 메인 스케줄러에서 전달된다.
// ControlProperty는 시퀀스를 공유한다. 일반 옵저버블에서  share 연산자를 호출하고 replay 파라미터로 1을 전달한 것과 동일한 방식으로 동작한다.
// 새로운 구독자가 추가되면 가장 최근에 저장된 속성값이 바로 전달된다.
//
// UIControl을 상속한 Control들은 다양한 이벤트를 전달한다.
// RxCocoa가 확장한 Extension에는 Event를 옵저버블로 랩핑한 속성이 추가되어 있다.
// ControlEvent는 ControlEventType을 채택한 제네릭 구조체이다.
// ControlEventType 프로토콜은 옵저버블타입프로토콜을 상속하고 있다. 옵저버블의 역할은 수행하지만 옵저버의 역할은 수행하지 않는다.
// (ControlPropertyType은 옵저버블 + 옵저버 수행)
//
// ControlEvent는 ControlProperty와 다수의 공통점을 가지고 있다.
// Error이벤트를 전달하지 않고 Completed 이벤트는 컨트롤이 해제되기 직전에 전달된다. 메인 스케줄러에서 이벤트를 전달하는 것도 동일하다.
//
// 그러나 가장 최근 이벤트를 Replay 하지 않는다.
// 새로운 구독자는 구독 이후에 전달된 이벤트만 전달 받는다.



// 기존 코드와 다른점 resetButton이 Outlet으로 연결되어 있고 슬라이더와 연결된 액션메소드는 존재하지 않는다.


import UIKit
import RxSwift
import RxCocoa

class ControlPropertyControlEventRxCocoaViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var colorView: UIView!
   
   @IBOutlet weak var redSlider: UISlider!
   @IBOutlet weak var greenSlider: UISlider!
   @IBOutlet weak var blueSlider: UISlider!
   
   @IBOutlet weak var redComponentLabel: UILabel!
   @IBOutlet weak var greenComponentLabel: UILabel!
   @IBOutlet weak var blueComponentLabel: UILabel!
   
   @IBOutlet weak var resetButton: UIButton!
   
   private func updateComponentLabel() {
      redComponentLabel.text = "\(Int(redSlider.value))"
      greenComponentLabel.text = "\(Int(greenSlider.value))"
      blueComponentLabel.text = "\(Int(blueSlider.value))"
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      redSlider.rx.value
        .map { "\(Int($0))"}
        .bind(to: redComponentLabel.rx.text)
        .disposed(by: bag)
       blueSlider.rx.value
         .map { "\(Int($0))"}
         .bind(to: blueComponentLabel.rx.text)
         .disposed(by: bag)
       greenSlider.rx.value
         .map { "\(Int($0))"}
         .bind(to: greenComponentLabel.rx.text)
         .disposed(by: bag)
    
    // View에 색깔 조합 표시
    Observable.combineLatest([redSlider.rx.value, greenSlider.rx.value, blueSlider.rx.value])
        .map { UIColor(red: CGFloat($0[0]) / 255, green: CGFloat($0[1]) / 255, blue: CGFloat($0[2]) / 255, alpha: 1.0) }
        .bind(to: colorView.rx.backgroundColor)
        .disposed(by: bag)
    
    
    resetButton.rx.tap //tap은 ControlEvent 속성이다. 버튼을 탭할 때마다 next 이벤트 방출
        .subscribe(onNext: { [weak self] in
            self?.colorView.backgroundColor = UIColor.black
            
            self?.redSlider.value = 0
            self?.greenSlider.value = 0
            self?.blueSlider.value = 0
            
            self?.updateComponentLabel()
        })
        .disposed(by: bag)
   }
}
// UIView+Rx :: background: Binder    UILabel+Rx :: text: Binder
// UISlider+Rx :: value: ControlProperty    UIButton+Rx tap: ControlEvent 속성

// Control Property와 Control Event는 항상 메인쓰레드에서 실행한다. 쓰레드 처리 신경 안써도 된다.
