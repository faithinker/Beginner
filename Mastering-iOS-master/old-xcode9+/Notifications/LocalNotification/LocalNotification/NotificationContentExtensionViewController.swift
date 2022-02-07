//RemoteNotification 1번째 강의
//애플이 관리하는 서버 APNs
//remote noti 전달하는 서버는 APNs이다.
//Provider(서버, 클라우드) -> APNs -> Device

//Local의 경우
//UNMutableNotification Content class의 instance를 생성 instance 속성 통해 필요한 정보를 구성 한 다음,
//UserNotificationCenter로 전달한다. UserNotiCenter가 예약된 시점에 Noti를 전달한다.

//RemoteNoti의 경우
//Provider에서 JSON 정보를 구성하고 -> APNs로 전달한다. json으로 구성된 정보를 payload라고 부른다.
//APNs가 디바이스로 네트워크를 통해 Noti를 전달한다.

//디바이스 네트워크 끊겨 있거나 전원 꺼져있으면 전달이 안된다. APNs가 대기목록에 저장했다가 시차를 두고 재전달한다.
//대기목록에 이미 저장된 항목이 있다면 가장 최근의 것으로 대체하고 이전의 것 삭제한다.
//대기시간이 길어진다면 모든 대기목록을 삭제한다.
//전송률이 100%가 아니라는 점과 지연이 발생 할 수 있다는 점을 감안해서 구현해야 한다.

//LocalNoti는 사용자에게 권한을 얻는것으로 초기화가 완료된다.
//RemoteNoti는 몇가지 작업이 더 필요하다. Provisnig Portal에서 앱 ID를 만든 다음 인증서를 생성하고,
//project에서 RemoteNoti를 사용하도록 설정해야한다. 사용자에게 권한 얻고 APNs에 디바이스를 등록하고 토큰을 토큰을 발급받는 과정과
//토큰을 전송하는 과정이 추가되어야 한다. 토큰은 APNs를 구분하기 위해 사용한다.

//크게 세단계 1. 인증서 생성 : 개발용 맥에서 인증서 생성 인증서 서명 요청 파일을 만들고
//iOS Provisinig Portal에서 push인증서를 생성한다. download한 인증서를 키체인에 저장한다.

//2.Push 서버 구성
//1에서 만든 인증서를 통해 APNs와 통신 할 수 있도록 만든다.

//3. Client 구현
//provider의 device를 등록하고 push를 받을 수 있도록 구현한다.

//개발용 Push Hub는 Sandbox
//배포용(실제) Push Hub는 Production이어야 한다.

//https://helloworld.fingerpush.com/ios-sdk-manual/

import UIKit
import UserNotifications

class NotificationContentExtensionViewController: UIViewController {
   
   
   @IBAction func schedule(_ sender: Any) {
      let content = UNMutableNotificationContent()
      content.title = "Hello"
      content.body = "Have a nice day :)"
      content.sound = UNNotificationSound.default()
      content.categoryIdentifier = CategoryIdentifier.customUI
      
      guard let url = Bundle.main.url(forResource: "hello", withExtension: "png") else {
         return
      }
      
      guard let imageAttachment = try? UNNotificationAttachment(identifier: "logo-image", url: url, options: nil) else {
         return
      }
      
      content.attachments = [imageAttachment]
      
      let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
      
      let request = UNNotificationRequest(identifier: "Hello", content: content, trigger: trigger)
      
      UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }
}



//Extension 강의
//ContentExtesnsion 폴더 안에 있는 plist파일
//NSExtension > NSExtensionAttributes > UNNotificationCategory : Value
//Value값을 내가 지정한 카테고리 이름 CATEGORY_CUSTOM_UI
//카테고리가 2개 이상이라면 키의 타입을 Array로 바꾸고 sub키로 추가해야 한다.
// > UNNotificationContentSizeRatio 배너의 너비를 기준으로 CUSTOM_UI의 높이를 설정한다.
// 내가 설정한 높이와 비슷한 비율 0.4 ~ 0.6정도로 한다.
// > UNNotificationExtensionDefaultContentHidden 직접추가, TYPE : Boolean , Value : Yes
// 기본타이틀과 바디가 표시되지 않는다.

//Extension의 storyboard > Files On > Inspector > 사이즈 변경


