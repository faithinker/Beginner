
import UIKit
import UserNotifications
//Attachments에는 png jpg gif 형식만 사용가능하다. 10mb 이하만 가능하다.
class AttachmentsViewController: UIViewController {
   
   @IBAction func addImageAttachment(_ sender: Any) {
      let content = UNMutableNotificationContent()
      content.title = "Hello"
      content.body = "Image Attachment"
      content.sound = UNNotificationSound.default()
      
      //File URL
    guard let url = Bundle.main.url(forResource: "hello", withExtension: "png") else {
        return
    }
    //option은 딕셔너리 형태, 배너 썸네일 이미지 숨기겠다.
    let options = [UNNotificationAttachmentOptionsThumbnailHiddenKey : true]
    
    //UNnotification attachment 생성자 호출 식별자와 url 전달, options 파라미터 썸네일 표시 방식 설정
    guard let imageAttachment = try? UNNotificationAttachment(identifier: "hello-image", url: url, options: options) else {
        return
    }
    //attachment 전달
    content.attachments = [imageAttachment]
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      let request = UNNotificationRequest(identifier: "Image Attachment", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
   
    //banner를 pull-down하면 재생 url이 실행된다. MP3, MP4Audio Wave 형식만 지원 5mb 이하만 가능
   @IBAction func addAudioAttachment(_ sender: Any) {
      let content = UNMutableNotificationContent()
      content.title = "Hello"
      content.body = "Audio Attachment"
      content.sound = UNNotificationSound.default()
      
    guard let url = Bundle.main.url(forResource: "bell", withExtension: "aif") else {
        return
    }
    guard let audioAttachment = try? UNNotificationAttachment(identifier: "audio", url: url, options: nil) else {
        return
    }
    content.attachments = [audioAttachment]
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      let request = UNNotificationRequest(identifier: "Audio Attachment", content: content, trigger: trigger)
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
   
    //mpeg2 mepg4 avi 형식 지원 50mb 이하만 가능
   @IBAction func addVideoAttachment(_ sender: Any) {
      let content = UNMutableNotificationContent()
      content.title = "Hello"
      content.body = "Video Attachment"
      content.sound = UNNotificationSound.default()

    guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {
        return
    }
    guard let videoAttachment = try? UNNotificationAttachment(identifier: "video", url: url, options: nil) else {
        return
    }
      
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      let request = UNNotificationRequest(identifier: "Video Attachment", content: content, trigger: trigger)      
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
}






















