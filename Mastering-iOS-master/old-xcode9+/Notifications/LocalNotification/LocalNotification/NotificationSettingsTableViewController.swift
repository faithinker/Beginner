
import UIKit
import UserNotifications

class NotificationSettingsTableViewController: UITableViewController {
   
   @IBOutlet weak var authorizationStatusLabel: UILabel!
   @IBOutlet weak var alertStyleLabel: UILabel!
   @IBOutlet weak var showPreviewsLabel: UILabel!
   @IBOutlet weak var alertLabel: UILabel!
   @IBOutlet weak var badgeLabel: UILabel!
   @IBOutlet weak var soundLabel: UILabel!
   @IBOutlet weak var notificationCenterLabel: UILabel!
   @IBOutlet weak var lockScreenLabel: UILabel!
    
    
    //개별 속성 확인, 레이블 출력
   func update(from settings: UNNotificationSettings) {
    switch settings.authorizationStatus {
    case .notDetermined:  //사용자가 허가여부를 명시적으로 지정하지 않았다.
        authorizationStatusLabel.text = "Not Determined"
    case .authorized:  //허가된 상태
        authorizationStatusLabel.text = "Authorized"
    case .denied:  //금지된 상태
        authorizationStatusLabel.text = "Denied"
    default:
        break
    }
    
    //권한을 추가할 떄 사운드 옵션을 추가하지 않으면 설정에 사운드 옵션이 포함되지 않는다.
    switch settings.soundSetting {
    case .enabled:
        soundLabel.text = "Enabled"
    case .disabled:
        soundLabel.text = "Disenabled"
    case .notSupported:
        soundLabel.text = "Not Supported"
    default:
        break
    }
    badgeLabel.text = settings.badgeSetting.stringValue
    lockScreenLabel.text = settings.lockScreenSetting.stringValue
    notificationCenterLabel.text = settings.notificationCenterSetting.stringValue
    alertLabel.text = settings.alertSetting.stringValue
    switch settings.alertStyle {
    case .banner: //temporary
        alertStyleLabel.text = "Banner"
    case .alert: //persistent
        alertStyleLabel.text = "Alert"
    case .none:
        alertStyleLabel.text = "None"
    default:
        break
    }
    if #available(iOS 11, *) {
        switch settings.showPreviewsSetting {
        case .always: //노티피케이션에 타이틀과 바디 모두 표시함
            showPreviewsLabel.text = "Alaways"
        case .whenAuthenticated: //잠금이 해제된 상태에서만 타이틀과 바디를 표시함,
            //잠금화면에서는 앱이름과 타이틀만 표시한다. 바디 부분에는 도착한 Noti의 숫자를 표시한다.
            showPreviewsLabel.text = "When Authenticated"
        case .never: //body는 표시되지 않는다. 사용자가 pull-down해서 바디 확인해야함
            showPreviewsLabel.text = "Never"
       
        default:
            break
        }
    }
   }
    //UsernotificationFramework가 제공하는 메소드를 통해서 설정을 읽어온 다음 레이블에 표시하도록 한다.
    //UNNotification settings 클래스에는 Notification 설정을 나타내는 다양한 속성이 선언 되어있다.
   @objc func refresh() {
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        DispatchQueue.main.async {
            self.update(from: settings)
        }
    }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
    //Scene에 진입하거나 앱이 foreground로 전활 될 떄 refresh()메소드 호출
      refresh()
      
      NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
    
    //UserNotificationCenter는 설정에 관계없이 Noti를 예약한다. 전달되지 못한 Noti가 한꺼번에 전달되기 때문에 사용자가 원치 않는 Noti폭탄을 맞게 된다. 따라서 설정을 확인하고 활성화된 상태에서 localNoti를 예약하도록 코드를 구현해야한다.
    UNUserNotificationCenter.current().getNotificationSettings { (settings) in
        guard settings.authorizationStatus == .authorized else {
            return
        }
        //localNotification을 예약하는 코드를 구현
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "Have a nice day :)"
        content.sound = UNNotificationSound.default()
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "HelloNoti", content: content, trigger: trigger)
        
        //localNoti의 예약 결과는 error파라미터를 통해 확인 할 수 있다 정상적이면 nil, 에러면 관련된 오류 객체가 전달됨
        UNUserNotificationCenter.current().add(request) { (error) in
            print(error)
        }
        //예약된 LocalNoti의 목록을 주기적으로 확인하고 원하는 시점에 전달 되지 않았거나 잘못된 내용의 Noti가 있다면 직접 삭제하는 것이 좋다.
        //Push-Noti의 경우 위와같은 패턴을 적용해야 한다. 앱을 실행하는 시점마다 Noti의 설정을 Provider-Server로 전송하고 APNS로 Noti를 전송하기 전에 Noti 설정을 확인해야한다.
    }
   }
}

extension UNNotificationSetting {
   var stringValue: String {
      switch self {
      case .notSupported:
         return "Not Supported"
      case .enabled:
         return "Enabled"
      case .disabled:
         return "Disabled"
      }
   }
}


















