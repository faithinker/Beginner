
import UIKit
import RxSwift
import RxCocoa

class CustomControlPropertyViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var resetButton: UIBarButtonItem!
   
   @IBOutlet weak var whiteSlider: UISlider!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // value은 ControlProperty로 선언되어 있기 때문에 값을 방출하는 옵저버블로 사용할 수 있고
//      whiteSlider.rx.value
//         .map { UIColor(white: CGFloat($0), alpha: 1.0) }
//         .bind(to: view.rx.backgroundColor)
//         .disposed(by: bag)
      
//      resetButton.rx.tap
//         .map { Float(0.5) }
//         .bind(to: whiteSlider.rx.value)
//         .disposed(by: bag)
//
//    // 이벤트를 슬라이더로 변환해서  슬라이더의 value 속성과 바인딩하고 있다.
//    // value는 옵저버의 역할을 수행하고 있다.
//    // 바인딩 대상이 되는 옵저버로 사용할 수도 있다.
//      resetButton.rx.tap
//         .map { UIColor(white: 0.5, alpha: 1.0) }
//         .bind(to: view.rx.backgroundColor)
//         .disposed(by: bag)
//
    // 신규 작성 코드 컬러 변경
    whiteSlider.rx.color
        .bind(to: view.rx.backgroundColor)
        .disposed(by: bag)
    // 리셋버튼
    resetButton.rx.tap
        .map { _ in UIColor(white: 0.5, alpha: 1.0) }
        .bind(to: whiteSlider.rx.color.asObserver(), view.rx.backgroundColor.asObserver())
        .disposed(by: bag)
// 내가 작성한 코드
//    whiteSlider.rx.value
//        .bind(to: view.rx.controlValue)
//        .disposed(by: bag)
   }
}
// UISlider에 UIColor를 방출해야 한다.
// 쓰기만 필요한 속성은 바인더로 구현하고 읽기와 쓰기가 모두 가능해야 한다면 ControlProperty로 구현해야 한다.

// UISlider+Rx > value
// getter 옵저버블로 사용될 때
// setter 옵저버(바인딩) 될 때 사용

// controlPropertyWithDefaultEvents
// Control Property를 쉽게 생성할 수 있는 Factory Methods

extension Reactive where Base: UIView {
    var controlValue: Binder<Float> {
        return Binder(self.base) { view, number in
            view.backgroundColor = UIColor(white: CGFloat(number), alpha: 1.0)

        }
    }
}
//
//extension Reactive where Base: UIButton {
//    var resetButton: ControlEvent<Void> {
//        return ControlEvent(events: <#T##ObservableType#>)
//    }
//
//}

extension Reactive where Base: UISlider {
    var color: ControlProperty<UIColor?> {
        return base.rx.controlProperty(editingEvents: .valueChanged, getter: { (slider) in
            UIColor(white: CGFloat(slider.value), alpha: 1.0)
        }, setter: { slider, color in
            var white = CGFloat(1)
            color?.getWhite(&white, alpha: nil)
            slider.value = Float(white)
        })
    }
}
