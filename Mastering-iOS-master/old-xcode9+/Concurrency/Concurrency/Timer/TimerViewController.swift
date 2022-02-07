//Runloop : Event Processing Loop
//앱이 시작되면 Main에서 자동 실행한다. Background에서 실행 필요 할 경우 직접 구현 필요하다.
//런루프는 쓰레드에서 발생하는 이벤트 소스를 감시한다.
//iOS는 이벤트 쏘스로부터 새로운 이벤트가 도착하면, 쓰레드를 깨운다음 런루프로 이벤트를 전달한다.
//런루프는 등록된 핸들러를 통해서 이벤트를 처리한다. 처리할 이벤트가 없을 경우 쓰레드를 대기상태로 전환한다. => 런루프를 사용하는 목적
//이벤트 처리를 위해 계속 풀링할 필요가 없다. => 앱 성능 향상

//타이머는 런루프나 시스템 상태에 따라 오차가 발생 할 수 있다. 오차 인식이 어렵다.
//타이머가 제공하는 API를 활용해서 허용 오차범위 설정하면 최적화에 도움이 된다.
//허용되는 오차와 리소스 상태를 감안하여 실행시점을 조절해 최적화 작업을 한다.
//=> 배터리 조절 , 응답성을 향상
import UIKit

class TimerViewController: UIViewController {
   
   @IBOutlet weak var timeLabel: UILabel!
   
   lazy var formatter: DateFormatter = {
      let f = DateFormatter()
      f.dateFormat = "hh:mm:ss"
      return f
   }()
   
   @IBAction func unwindToTimerHome(_ sender: UIStoryboardSegue) {
      
   }
   
   func updateTimer(_ timer: Timer) {
      print(#function, Date(), timer)
      timeLabel.text = formatter.string(from: Date())
   }
   
   func resetTimer() {
      timeLabel.text = "00:00:00"
   }
   
   var timer: Timer?
   
    @objc func timerFired(_ timer: Timer) {
        updateTimer(timer)
    }
    
   @IBAction func startTimer(_ sender: Any) {
    //Start 버튼 누를 때마다 새로운 타이머 메소드가 호출되서 불필요한 리소스가 생김
    //타이머를 생성하기전에 이전 타이머를 중지하거나 이미 실행중인 타이머가 있다면 생성 할 수 없도록 구현
    guard timer == nil else { return }
    
   //타이머 클래스가 제공하는 TimeMethod
//    timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in //block 파라미터 : 반복적으로 실행할 코드
//        guard timer.isValid else {return}
//    })

    timer = Timer(timeInterval: 1, target: self, selector: #selector(timerFired(_:)), userInfo: nil, repeats: true)
    //runloop 추가한 다음, firemethod에 직접 추가한다.
    timer?.tolerance = 0.2 //iOS가 허용오차를 감안해서 실행주기를 최적화 한다. 배터리 절약 터치이벤트 반응성 향상된다.
    RunLoop.current.add(timer!, forMode: .defaultRunLoopMode)
    timer!.fire()
   }
   
   @IBAction func stopTimer(_ sender: Any) {
    timer?.invalidate()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      resetTimer()
   }
   //다른 화면 -> Timer 화면전환 : Timer를 다시 시작해야 한다.
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
    startTimer(self)
      
   }
   //Timer 화면 -> 다른 화면 전환 : Timer를 중지해야 한다.
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
    timer?.invalidate()
    timer = nil
   }
}
