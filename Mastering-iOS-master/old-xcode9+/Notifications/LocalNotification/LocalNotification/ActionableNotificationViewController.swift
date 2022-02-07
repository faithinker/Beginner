
import UIKit
import UserNotifications
//banner를 pull-down해서 간단한 행동 가능함. 추천/비추천/댓글 등
//카테고리를 선언하고 액션을 추가한다. 앱 시작 시점에 UNCenter에 카테고리를 등록해야 한다.
//카테고리와 액션은 문자열 식별자로 구분한다.
class ActionableNotificationViewController: UIViewController {
   @IBOutlet weak var imageView: UIImageView!
   
   @IBAction func schedule(_ sender: Any) {
      let content = UNMutableNotificationContent()
      content.title = "Hello"
      content.body = "KxCoding just shared a photo."
      content.sound = UNNotificationSound.default()
    
    content.categoryIdentifier = CategoryIdentifier.imagePosting
    
      guard let url = Bundle.main.url(forResource: "hello", withExtension: "png") else {
         return
      }
      
      guard let imageAttachment = try? UNNotificationAttachment(identifier: "logo-image", url: url, options: nil) else {
         return
      }
      content.attachments = [imageAttachment]
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      let request = UNNotificationRequest(identifier: "Image Attachment", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
    //app이 백그라운드 일떄하고 아예 실행하지 않을떄 모두 고려해야 한다.
   @objc func updateSelection() {
        switch UserDefaults.standard.string(forKey: "usersel") {
        case .some(ActionIdentifier.like):
            imageView.image = UIImage(named: "thumb-up")
        case .some(ActionIdentifier.dislike):
            imageView.image = UIImage(named: "thumb-down")
        default:
            imageView.image = UIImage(named: "question")
        }
    }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
    NotificationCenter.default.addObserver(self, selector: #selector(updateSelection), name: NSNotification.Name.UIApplicationDidBecomeActive, object: nil)
   }
    //uiapplicationDidbecome update
    //A신에 있다가 홈화면 나가고 알림 action 실행 해도 viewWillAppear 함수가 실행되지 않는다.
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        updateSelection()
    }
}
















