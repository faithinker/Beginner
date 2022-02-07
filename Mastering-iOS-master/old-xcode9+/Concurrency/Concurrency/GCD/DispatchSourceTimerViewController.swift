//  DispatchSourceTimer : 다양한 시스템 이벤트를 감시하고 DispatchQueue를 통해 핸들러를 제공하는 api를 제공

import UIKit

class DispatchSourceTimerViewController: UIViewController {
   
   @IBOutlet weak var timeLabel: UILabel!
   
   lazy var formatter: DateFormatter = {
      let f = DateFormatter()
      f.dateFormat = "hh:mm:ss"
      return f
   }()
   
    var timer : DispatchSourceTimer?
    
   @IBAction func start(_ sender: Any) {
    if timer == nil {
        timer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.main)
        //실행시점과 실행주기 설정
        timer?.schedule(deadline: .now(), repeating: 1)
        //이벤트 핸들러 구현
        timer?.setEventHandler(handler: {
            self.timeLabel.text = self.formatter.string(from: Date())
            print(self.timeLabel.text ?? "")
        })
    }
    timer?.resume()
   }
   
   @IBAction func suspend(_ sender: Any) {
    timer?.suspend()
   }
   
   @IBAction func stop(_ sender: Any) {
    timer?.cancel()
    timer = nil
   }
   
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    timer?.resume()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      timer?.suspend()
      //stop(self) 화면벗어나면 타이머 취소
   }
}
