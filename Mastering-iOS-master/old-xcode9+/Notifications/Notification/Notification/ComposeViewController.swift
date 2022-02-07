
import UIKit

//다른 Notification 이름과 중복되서는 안된다.
//속성이름에 Notification 접미어를 추가한다.
extension NSNotification.Name {
    static let NewValueDidInput = NSNotification.Name("NewValueDidInputNotification")
}
class ComposeViewController: UIViewController {
   
   @IBOutlet weak var inputField: UITextField!
   
   @IBAction func close(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
   
   @IBAction func postValue(_ sender: Any) {
    guard let text = inputField.text else {
        return
    }
    //object : Noti 전달하는 객체를 전달 해야한다. post
    //Noti 전달하는 객체를 구분해야 한다면 해당 객체를 전달해야한다. Noti와 연관된 데이터를 전달하는데 쓰기도 한다.
    //userInfo : Noti와 관련된 정보를 Dic으로 전달해야한다. 값 사용시 키 사용해야함
    DispatchQueue.global().sync { //background에서 실행함
        NotificationCenter.default.post(name: NSNotification.Name.NewValueDidInput, object: nil, userInfo: ["NewValue": text])
    }
    //XCode가 MainThread Checker를 통해서 UICode를 background에서 실행 할 때 경고를 출력해준다.
    
    dismiss(animated: true, completion: nil)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      inputField.becomeFirstResponder()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      inputField.resignFirstResponder()
   }
}
