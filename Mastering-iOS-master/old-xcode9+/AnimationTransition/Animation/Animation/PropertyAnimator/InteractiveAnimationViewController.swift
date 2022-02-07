//사용자 터치에 반응해서 움직이는 애니메이션
import UIKit

class InteractiveAnimationViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   var animator: UIViewPropertyAnimator?
   
   func moveAndResize() {
      let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
      redView.frame = targetFrame
      redView.backgroundColor = UIColor.blue
   }
   
   @IBAction func animate(_ sender: Any) {
      animator?.startAnimation()
   }
   
   @IBAction func sliderChanged(_ sender: UISlider) {
    animator?.fractionComplete = CGFloat(sender.value)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      animator = UIViewPropertyAnimator(duration: 7, curve: .linear, animations: {
         self.moveAndResize()
      })
   }
}
