
import UIKit

class UIViewKeyframeAnimationViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   func phase1() {
      let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
      redView.frame = targetFrame
   }
   
   func phase2() {
      redView.backgroundColor = UIColor.blue
   }
   
   func phase3() {
      let targetFrame = CGRect(x: 50, y: 100, width: 50, height: 50)
      redView.frame = targetFrame
      redView.backgroundColor = UIColor.red
   }
   
   
   @IBAction func animate(_ sender: Any) {
//      UIView.animate(withDuration: 1, animations: {
//         self.phase1()
//      }, completion: { finished in
//         UIView.animate(withDuration: 1, animations: {
//            self.phase2()
//         }, completion: { finished in
//            UIView.animate(withDuration: 1, animations: {
//               self.phase3()
//            })
//         })
//      })
    UIView.animateKeyframes(withDuration: 3, delay: 0, options: []) {
        //StartTime 시작시간, Duration실행시간
        UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.3) {
            self.phase1()
        }
        //첫번째 애니 다음에 실행된다.
        UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.3) {
            self.phase2()
        }
        UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.3) {
            self.phase3()
        }
    } completion: { _ in Void.self}

   }
}












