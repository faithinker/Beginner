
import UIKit

class UIViewSpringAnimationViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   @IBOutlet weak var dampingSlider: UISlider!
   @IBOutlet weak var velocitySlider: UISlider!
   
   @IBAction func reset(_ sender: Any?) {
      redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
   }
   
   @IBAction func animate(_ sender: Any) {
      let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
      
    //Damping 진폭 0.0 ~ 1.0 Velocity
    UIView.animate(withDuration: 3, delay: 0, usingSpringWithDamping: CGFloat(dampingSlider.value), initialSpringVelocity: CGFloat(velocitySlider.value), options: []) {
        self.redView.frame = targetFrame
    } completion: { _ in Void.self
    }

   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      reset(nil)
   }
}













