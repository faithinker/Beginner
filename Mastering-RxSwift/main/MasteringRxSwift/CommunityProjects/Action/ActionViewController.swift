
import UIKit
import RxSwift
import RxCocoa
import Action
import NSObject_Rx

class ActionViewController: UIViewController {
   
   @IBOutlet weak var runButton: UIButton!
   
   @IBOutlet weak var enabledSwitch: UISwitch!
   
      
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
      enabledSwitch.rx.value
         .bind(to: runButton.rx.isEnabled)
         .disposed(by: rx.disposeBag)
   }
}
