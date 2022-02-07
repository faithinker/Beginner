//앱 실행상태에 따라 다르게 처리된다.
//App이 백그라운드거나 아예 실행상태 아니라면 iOS가 직접 Noti를 표시한다
//앱이 foreground에서 실행중이면 delegate메소드를 호출한다. => App delegate
import UIKit

class LocalNotificationViewController: UIViewController {
   var interval: TimeInterval = 1
   
   @IBOutlet weak var inputField: UITextField!
   
   @IBAction func schedule(_ sender: Any) {
      let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = inputField.text ?? "Empty body"
        content.badge = 12
        content.sound = UNNotificationSound.default()
    
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false)
    
    let request = UNNotificationRequest(identifier: "Test", content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request) { (error) in
        if let error = error {
            print(error)
        }else {
            print("Done")
        }
    }
    inputField.text = nil
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      //singleton instance에 접근가능
    UIApplication.shared.applicationIconBadgeNumber = 0
      
   }
}


extension LocalNotificationViewController: UIPickerViewDataSource {
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      return 60
   }
}

extension LocalNotificationViewController: UIPickerViewDelegate {
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      return "\(row + 1)"
   }
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
      interval = TimeInterval(row + 1)
   }
}




















