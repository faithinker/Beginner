
import UIKit
import RxSwift
import RxCocoa

class RxCocoaAlertViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var colorView: UIView!
   
   @IBOutlet weak var oneActionAlertButton: UIButton!
   
   @IBOutlet weak var twoActionsAlertButton: UIButton!
   
   @IBOutlet weak var actionSheetButton: UIButton!
   
    
    // 액션 버튼을 생성할 때 전달하는 클로저의 역할 :
    // Cocoa Touch 버튼과 연관된 코드를 직접 작성
    // RxCocoa 옵저버블로 랩핑한 다음에 액션에서 이벤트를 방출한다.
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
        // 버튼을 탭하면 경고창 표시
        oneActionAlertButton.rx.tap
            //탭 속성이 전달하는 이벤트 대신 alertAction에서 전달하는 이벤트를 전달함
            .flatMap { [unowned self] in self.info(title: "Current", message: self.colorView.backgroundColor?.rgbHexString)}
            
            .subscribe(onNext: { [unowned self] actionType in
            switch actionType {
            case .ok:
                print(self.colorView.backgroundColor?.rgbHexString ?? "")
            default:
                break
            }
        })
        .disposed(by: bag)
    
        twoActionsAlertButton.rx.tap
            .flatMap { [unowned self] in self.alert(title: "Rest Color", message: "Reset to black color?")}
            .subscribe(onNext: { [unowned self] actionType in
            switch actionType {
            case .ok:
                self.colorView.backgroundColor = UIColor.black
            default:
                break
            }
        })
        .disposed(by: bag)
    
        actionSheetButton.rx.tap
            .flatMap { [unowned self] in
            self.colorActionSheet(colors: MaterialBlue.allColors, title: "Change Color", message: "Choose one")
        }
        .subscribe(onNext: { [unowned self] color in
            self.colorView.backgroundColor = color
        })
        .disposed(by: bag)
      
   }
}

enum ActionType {
   case ok
   case cancel
}

//리턴 타입 : 액션타입을 방출하는 옵저버블
// 추가적인 행동이 필요 없다면 <Void> <Completable>? 로 선언


extension UIViewController {
    func info(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                // action과 연관된 기능을 구현하는게 아니라 이벤트를 전달하도록 구현한다.
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)

            self?.present(alert, animated: true, completion: nil)
            
            // 생성 시점에 클로저를 전달하고 alertControl을 dismiss 한다.
            return Disposables.create {
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    func alert(title: String, message: String? = nil) -> Observable<ActionType> {
        return Observable.create { [weak self] observer in
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
                // action과 연관된 기능을 구현하는게 아니라 이벤트를 전달하도록 구현한다.
                observer.onNext(.ok)
                observer.onCompleted()
            }
            alert.addAction(okAction)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onNext(.cancel)
                observer.onCompleted()
            }
            alert.addAction(cancelAction)
            
            self?.present(alert, animated: true, completion: nil)
            
            // 생성 시점에 클로저를 전달하고 alertControl을 dismiss 한다.
            return Disposables.create { //Disposable가 아니라 Disposables이다.
                alert.dismiss(animated: true, completion: nil)
            }
        }
    }
    // 다수의 alertAction을 actionsheet에 표시하고 구독자에서 개별 액션을 처리함
    // 액션시트에서 컬러를 선택하면 UIView.background color를 바꾸는 것이 목적이다. 구독자에게 필요한 것은 UIColor이다.
    func colorActionSheet(colors: [UIColor], title: String, message: String? = nil) -> Observable<UIColor> {
        return Observable.create { [weak self] observer in
            
            let actionSheet = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            
            for color in colors {
                let colorAction = UIAlertAction(title: color.rgbHexString, style: .default) { _ in
                    observer.onNext(color)
                    observer.onCompleted()
                }
                actionSheet.addAction(colorAction)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                observer.onCompleted()
            }
            actionSheet.addAction(cancelAction)
            
            self?.present(actionSheet, animated: true, completion: nil)
            
            return Disposables.create {
                actionSheet.dismiss(animated: true, completion: nil)
            }
        }
    }
}

