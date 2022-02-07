
import UIKit

class SystemNotificationViewController: UIViewController {
   //NSNotification.Name 문서보고 메소드 처리 해보기
    
    //과제 옵저버 등록 해제 해봐라
   override func viewDidLoad() {
      super.viewDidLoad()
    NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationWillChangeStatusBarFrame, object: nil, queue: OperationQueue.main) { (noti) in
        print(noti.userInfo)
        //simulator CMD+Y Hardware - toggle in-call ~
    }
      
   }   
}
