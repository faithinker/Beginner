// ControlProperty : 데이터를 특정 UI에 바인딩 할 때 사용하는 특별한 옵저버
import UIKit

class BindingCocoaTouchViewController: UIViewController {
     
   @IBOutlet weak var valueLabel: UILabel!
   
   @IBOutlet weak var valueField: UITextField!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      valueLabel.text = ""
      valueField.delegate = self // VC가 텍스트필드의 델리게이트로 지정됨
      valueField.becomeFirstResponder()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      valueField.resignFirstResponder()
   }
}

extension BindingCocoaTouchViewController: UITextFieldDelegate {
   func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
      
      guard let currentText = textField.text else {
         return true
      }
      
      let finalText = (currentText as NSString).replacingCharacters(in: range, with: string)
      valueLabel.text = finalText
      
      return true
   }
}
