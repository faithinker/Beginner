
import UIKit
import RxSwift
import RxCocoa

// Binder.swift UIBinding을 사용하는 특별한 옵저버이다.

// public init<Target: AnyObject>(_ target: Target, scheduler: ImmediateSchedulerType = MainScheduler(), binding: @escaping (Target, Value) -> Void)
// target : 바인더가 확장하는 객체
// 객체의 형식은 Class로 제한되어 있다. UIBinding에 사용되기 때문에
// UILabel이나 UIImageView와 같이 UI와 관련된 객체를 전달한다.
// binding 클로저이고 두개의 파라미터를 전달받는다.
// Target 바인더가 확장하는 UI 객체이다. Value 바인더로 전달된 값이다.
// 클로저에서는 Value로 전달된 값을 Target에 있는 속성에 저장하는 코드를 구현한다.
// next : 이벤트가 전달되는 시점마다 메인스케줄러에서 클로저를 호출하고 있다.
// error : debug 모드에서는 fatalError, release 모드에서는 print문 호출
// 바인더는 에러 이벤트를 받지 않는다. 에러이벤트를 위와같이 처리하기 때문이다.
//
// UILabel+Rx.swift : text 속성.
// self.base = UILabel 전달
// 3번째 파라미터 Trailing Closure
// 클로저에는 레이블과 바인더로 전달된 텍스트가 파라미터로 전달된다.
// 커스텀 바인더로 구현할 때도 이와 같이 구현한다.



class CustomBinderViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var valueLabel: UILabel!
   
   @IBOutlet weak var colorPicker: UISegmentedControl!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
//      colorPicker.rx.selectedSegmentIndex
//         .map { index -> UIColor in
//            switch index {
//            case 0:
//               return UIColor.red
//            case 1:
//               return UIColor.green
//            case 2:
//               return UIColor.blue
//            default:
//               return UIColor.black
//            }
//         }
//         .subscribe(onNext: { [weak self] color in
//            self?.valueLabel.textColor = color
//         })
//         .disposed(by: bag)
//
//      colorPicker.rx.selectedSegmentIndex
//         .map { index -> String? in
//            switch index {
//            case 0:
//               return "Red"
//            case 1:
//               return "Green"
//            case 2:
//               return "Blue"
//            default:
//               return "Unknown"
//            }
//         }
//         .bind(to: valueLabel.rx.text)
//         .disposed(by: bag)
    
    colorPicker.rx.selectedSegmentIndex
        .bind(to: valueLabel.rx.segmentedValue)
        .disposed(by: bag)
   }
}

// 스케줄러는 메인쓰레드가 기본값 설정되어 있기 때문에 대부분 설정하지 않는다.(그대로 사용한다.)
extension Reactive where Base: UILabel {
    var segmentedValue: Binder<Int> {
        return Binder(self.base) { label, index in
            switch index {
            case 0:
                label.text = "Red"
                label.textColor = UIColor.red
            case 1:
                label.text = "Green"
                label.textColor = UIColor.green
            case 2:
                label.text = "Blue"
                label.textColor = UIColor.blue
            default:
                label.text = "Unknown"
                label.textColor = UIColor.black
            }
            
        }
    }
}
