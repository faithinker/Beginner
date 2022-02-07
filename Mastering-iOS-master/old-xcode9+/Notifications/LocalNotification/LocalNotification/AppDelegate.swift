
import UIKit
import UserNotifications

struct ActionIdentifier {
    static let like = "ACTION_LIKE"
    static let dislike = "ACTION_DISLIKE"
    static let unfollow = "ACTION_UNFOLLOW"
    static let setting = "ACTIION_SETTING"
    private init() {}
}
struct CategoryIdentifier {
    static let imagePosting = "CATEGORY_IMAGE_POSTING"
    static let customUI = "CATEGORY_CUSTOM_UI"
    private init() {}
}
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?
   //ActionableNotification identifier(식별자)을 문자열 직접 지정보다는 상수로 선언하고 전달하는 것이 좋다.
    //오타의 오류 적어짐(Xcode가 도와줌), Code의 가독성이 높아짐
    func setupCategory() {
        //action버튼 표시할 텍스트 , Action을 표시하는 방식과 동작방식을 지정
        let likeAction = UNNotificationAction(identifier: ActionIdentifier.like, title: "Like", options: [])
        let dislikeAction = UNNotificationAction(identifier: ActionIdentifier.dislike, title: "Dislike", options: [])
        //authenticationRequired : 잠금이 해쩨된 상태에서만 액션을 처리한다.
        //destructive : 다른 옵션들과 다른 색깔로 표시된다.
        let unfollowAction = UNNotificationAction(identifier: ActionIdentifier.unfollow, title: "Unfollow", options: [.authenticationRequired, .destructive])
        
        //사용자가 전달된 noti를 더 이상 받고 싶지 않다고 가정, 액션을 선택하면 앱 실행함.
        let settingAction = UNNotificationAction(identifier: ActionIdentifier.setting, title: "Setting", options: [.foreground])
        //CustomDismiss와 DefaultAction 모두 기본액션이다. 카테고리에 CustomDismiss를 추가한 경우에만 처리 할 수 있다.
        //DefaultAction 별도의 옵션을 추가하지 않아도 항상 처리 할 수 있다.
        var options = UNNotificationCategoryOptions.customDismissAction
        
        
        if #available(iOS 11.0, *) { //iOS 11 이상에서만 실행
            options.insert(.hiddenPreviewsShowTitle)
        }
        
        //중요도가 높은 액션을 배열 앞부분에 추가한다. intentIdentifiers은 siri와 관련되어있다.
            let imagePostingCategory = UNNotificationCategory(identifier: CategoryIdentifier.imagePosting, actions: [likeAction,dislikeAction,unfollowAction,settingAction], intentIdentifiers: [], options: [])
        //UserNotificationCenter에 카테고리를 등록
            UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory])

        let customUICategory = UNNotificationCategory(identifier: CategoryIdentifier.customUI, actions: [likeAction, dislikeAction], intentIdentifiers: [], options: [])
        
        //UNNotificationCeter에 Category를 등록하기 전에 ContentExstension을 지원하는지 확인해야 한다.
       //지원하는 경우에만 등록하도록 코드 작성
        if UNUserNotificationCenter.current().supportsContentExtensions {
            UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory, customUICategory])
        } else {
            UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory])
        }
    }
    
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.alert, .badge, .sound]) { (granted, error) in
        if granted {  //클로저는 반복적으로 호출된다.
            self.setupCategory() //초기화 시점에 setupCategory 메소드가 호출된다.
            UNUserNotificationCenter.current().delegate = self
        }
        print("granted \(granted)")
    }
      return true
   }

}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        let trigger = notification.request.trigger
        
        completionHandler([UNNotificationPresentationOptions.alert])
    }
    
    //Noti 배너를 터치 혹은 NotiCenter에서 Noti를 터치시 앱이 실행하며 호출되는 함수
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        let trigger = response.notification.request.trigger
        
        //Actionable : 배너 자체를 탭하면 앱이 실행되지만 Action을 탭하면 앱이 실행되지 않는다 대신 delegate 메소드가
        //현재 함수가 호출된다. response.actionIdentifier을 통해서 어떤 action이 선택 됐는지 확인 가능
        //이 메소드가 호출 될 때는 Scene이 존재하지 않을 수 있다. 기능 구현에 필요한 데이터를 저장해두고 화면에 진입하는 시점이나 앱리 foreground로 진입하는 시점에 UI를 업데이트하거나
        //연관된 기능을 실행하도록 구현해야한다.
        switch response.actionIdentifier {
        case ActionIdentifier.like:
            print("tab like")
        case ActionIdentifier.dislike:
            print("tab dislike")
        case UNNotificationDismissActionIdentifier:
            print("Custom Dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("launch from noti")
        default:
            return
        }
        //UserDefaults에 액션아이디를 저장
        UserDefaults.standard.set(response.actionIdentifier, forKey: "usersel")
        UserDefaults.standard.synchronize()
        
        completionHandler()
    }
}


























