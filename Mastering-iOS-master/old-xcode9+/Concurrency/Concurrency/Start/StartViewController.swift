// 앱 실행시 결과 로그
//Main Thread: Start
//Background Thread: for #0
//Main Thread: update label
//Background Thread: Done
//Background Thread: End
// DispatchQueue.global().async 실행할 코드를 전달한 다음 바로 다음 코드를 읽는다.


import UIKit

class StartViewController: UIViewController {
   
   @IBOutlet weak var countLabel: UILabel!
   
   
   @IBAction func start(_ sender: Any) {
      countLabel.text = "0"
      
    logThread(with: "Start")
    //오래 걸리는 작업은 백그라운드에서 실행하고 UIUpdate OR touchEvent 처리하는 코드는 메인쓰레드에서 구현하는 패턴을 익혀라
    DispatchQueue.global().async { //Backgorund에서 실행
        for count in 0..<3 {
            self.logThread(with: "for #\(count)")
            DispatchQueue.main.async {
                self.logThread(with: "update label")
                self.countLabel.text = "\(count)"
            }
          Thread.sleep(forTimeInterval: 0.1)
            self.logThread(with: "Done")
          //쓰레드 클래스를 통해서 쓰레드를 생성하고 제어한다. 가급적 사용하지 않는것이 좋다. sleep과 관찰은 자주 사용한다.
          //중지하는 동안 다른 이벤트(액션)을 처리 할 수 없다. == Main Thread가 Blocking 되었다.
        }
        self.logThread(with: "End")
    }
    
//    for count in 0...100 {
//      self.countLabel.text = "\(count)"
//      Thread.sleep(forTimeInterval: 0.1)
//      Code를 이렇게짜면 메인스레드에서 중지한다.
//    }
   }
   
   func logThread(with task: String) {
      if Thread.isMainThread {
         print("Main Thread: \(task)")
      } else {
         print("Background Thread: \(task)")
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
}
