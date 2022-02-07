//PropertyAnimator
//애니메이션 상태 제어(자동실행, 직접중지), 일시중지 완정중지 메소드 제공
import UIKit

//기능이 구현 안된다. 이상하다. Ani - Property 다시 해봐야함
class PropertyAnimatorViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   var animator: UIViewPropertyAnimator?
   
   func moveAndResize() {
      let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
      redView.frame = targetFrame
   }
   
   @IBAction func reset(_ sender: Any?) {
      redView.backgroundColor = UIColor.red
      redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
   }
   
   @IBAction func pause(_ sender: Any) {
    animator?.pauseAnimation()
    //이미 실행된 애니메이션 비율
    print(animator?.fractionComplete)
      
   }
   
   @IBAction func animate(_ sender: Any) {
    UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 3, delay: 0, options: []) {
        self.moveAndResize()
    } completion: { position in
        switch position {
        case .start:
            print("St")
        case .end:
            print("end")
        case .current:
            print("current")
        }
    }
    //Bezier Timing Curve
    //UIViewPropertyAnimator(duration: <#T##TimeInterval#>, controlPoint1: <#T##CGPoint#>, controlPoint2: <#T##CGPoint#>, animations: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
    //UIViewAnimationCurve
    animator = UIViewPropertyAnimator(duration: 7, curve: .linear, animations: {
        self.moveAndResize()
    })
    
    animator?.addCompletion({ (position) in
        print("Done \(position)")
    })
    
    //TimingCurve를 상세히 지정
    //UIViewPropertyAnimator(duration: <#T##TimeInterval#>, timingParameters: <#T##UITimingCurveProvider#>)

   }
   
   @IBAction func resume(_ sender: Any) {
    animator?.startAnimation()
   }
   
   @IBAction func stop(_ sender: Any) {
    //true => Ani is stop. state is inactive
    //false => state is stopped
    animator?.stopAnimation(false)
    //false 사용시 함께 씀. 31번째 줄 completion method call한다. and State is inactive
    animator?.finishAnimation(at: .current)
   }
   
   @IBAction func add(_ sender: Any) {
    //parameteer로 전달한 animation block을  property animator가 관리하는 실행 스택에 추가한다.
    //Inactive 상태에서 추가하면 원본 애니메이션과 동리한 시간동안 실행된다.
    //Active 상태에서 추가하면 남은시간동안 실행된다. Stopped 상태에서 실행되면 Crash가 발생하고 App down됨
    //반드시 Inactive나 Active상태에서 호출해야 한다.
    animator?.addAnimations({
        self.redView.backgroundColor = UIColor.blue
    }, delayFactor: 0)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }   
}
