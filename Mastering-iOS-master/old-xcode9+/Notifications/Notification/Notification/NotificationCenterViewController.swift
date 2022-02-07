//Notification 하나의 프로그램 내에서 객체들이 주고받는 메세지 특정 이벤트에 대한 옵저버를 등록하고
//이벤트가 브로드캐스팅 되면 원하는 코드를 실행하는 패턴을 구현할 때 사용한다.
//Local Notification 지정된 시간에 사용자에게 알림을 제공한다. (시계 등)
//Remote Notification Push Noti, 외부서버에서 전달하는 알림



//프로그램 내에서 객체들이 주고받기 때문에 사용자에게 시각적으로 표현되지 않는다.
// Local과 Push는 배너와 뱃지를 통해 사용자에게 시각적으로 제공한다. 알림사운드가 재생된다.
//



// Noti의 Noti Center는 Singleton Instance로 객체가 전달한 Notification을  옵저버로 전달한다.
//NSNotification Class 이름을 통해 Noti의 종류를 구분할 수 있다.
//UserInfoDictionary를 통해 연관된 데이터를 함께 전달 할 수 있다.
// 권한 요청부터 Noti의 처리까지 모든 부분을 지원한다.
// Local : UNNotable

import UIKit

//Obeserver 등록 Noti에서 전달된 텍스트를 label에 표시한다.
//1. 특정 객체와 메소드를 옵저버로 등록한다.
//2. Closure를 옵저버로 등록한다. => 옵저버 해제가 중요하다.
// 각각에 따라 옵저버 해제 deinit이 달라진다.
class NotificationCenterViewController: UIViewController {
   
   @IBOutlet weak var valueLabel: UILabel!
   //ComposeVC에 있는 userInfo에있는 정보를 NotiCenter는 Noti instance에 담아서 파라미터로 전달한다.
    @objc func process(notification: Notification) {
        //thread check
        print(Thread.isMainThread ? "Main Thread" : "Background Thread")
        
        //textfield에 담긴 값을 String으로 타입캐스팅
        guard let value = notification.userInfo?["NewValue"] as? String else {
            return
        }
        
        DispatchQueue.main.async { //main thread에서 실행
            self.valueLabel.text = value
        }
        
        print("#1", #function) //자신함수명 호출
    }
    
    var token : NSObjectProtocol?
    
   override func viewDidLoad() {
      super.viewDidLoad()
    //1번 방법 : 특정 객체와 메소드를 옵저버로 등록
    //첫번째파라미터 : 옵저버로 지정할 객체를 전달
    //selector : 실행할 메소드를 셀렉터로 지정
    // object : sender를 제한할 때 사용, composeVC-postValue-noti-object에서 nil을 전달했으므로 여기도 nil로 전달해야 noti 처리 가능
    NotificationCenter.default.addObserver(self, selector: #selector(process(notification:)), name: NSNotification.Name.NewValueDidInput, object: nil)
    
    //NSObjectProtocol, using : 실행할 코드 전달, Closure의 파라미터로 전달
    //queue : closure에서 실행 할 oprate Queue를 전달
    token = NotificationCenter.default.addObserver(forName: NSNotification.Name.NewValueDidInput, object: nil, queue: OperationQueue.main) { [weak self] (notification) in
        guard let value = notification.userInfo?["NewValue"] as? String else {
            return
        }
        //closure capture list를 통해 deinit 시킴
        //self를 옵저버로 등록하지 않아서 계속 dispatchQueue에 쌓인다.
        self?.valueLabel.text = value
        
        
        print("#2 Handling \(notification.name)") //자신함수명 호출
    }
    
   }
   
   deinit { //메모리 해제, 소멸자
      //특정 Noti처리하는 옵저버만 해제 할 수 있다.
    //NotificationCenter.default.removeObserver(<#T##observer: Any##Any#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
    if let token = token {
        NotificationCenter.default.removeObserver(token)
    }
    NotificationCenter.default.removeObserver(self)
      print(#function)
   }
}


//Notification Center and Notification

//Foundation framework - Notification Center
//iOS Notification
