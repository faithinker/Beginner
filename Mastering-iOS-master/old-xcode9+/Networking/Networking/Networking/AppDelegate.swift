
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   var window: UIWindow?

   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

      return true
   }
    
    // 앱이 실행되고 있지 않은 상태에서 BackgroundSession에서 시작한 task가 완료되면
    // iOS는 백그라운드에서 앱을 실행하고 이 메소드를 호출한다.
    //
    // 백그라운드 세션을 생성한다음 앱 델리게이트를 URLSession에 delegate로 지정한다.
    // 하지만 이렇게되면 동일한 기능을 수행하는 delegate를 두 파일에서 중복으로 구현한다.
    // 메소드 수정시 두 파일에서 두번해야하기 때문에 번거롭다.
    //
    // 가장 좋은 방법은 
    // 싱글톤 객체에서 백그라운드 세션을 생성한다.
    func application(_ application: UIApplication, handleEventsForBackgroundURLSession identifier: String, completionHandler: @escaping () -> Void) {
        NSLog(">> %@ %@", self, #function)
        
        _ = BackgroundDownloadManager.shared.session
        
        BackgroundDownloadManager.shared.completionHandler = completionHandler
    }
}

