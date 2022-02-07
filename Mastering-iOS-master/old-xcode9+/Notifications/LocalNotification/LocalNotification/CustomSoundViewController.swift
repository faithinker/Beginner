
import UIKit
import UserNotifications
//custom sound 할려면 무조건 자기프로젝트/Sound/파일명.  형식으로 저장해라
//Linear PCM MA4 uLaw aLaw 형식만 지원한다 최대 30초까지만 가능하다.
class CustomSoundViewController: UIViewController {
   @IBAction func useCustomSound(_ sender: Any) {
      let content = UNMutableNotificationContent()
      content.title = "Hello"
      content.body = "Custom Sound"
    content.sound = UNNotificationSound(named: "bell.aif")
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      
      let request = UNNotificationRequest(identifier: "CustomSound", content: content, trigger: trigger)
      
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
}

























