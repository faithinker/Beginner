
import UIKit
//UIView.animate API iOS4에서 도입된 오래된 API이다.
//iOS10부터는 propertyAnimator를 사용한다.
class AnimationOptionsViewController: UIViewController {   
   @IBOutlet weak var redView: UIView!
   
   @IBAction func reset(_ sender: Any?) {
      redView.backgroundColor = UIColor.red
      redView.alpha = 1.0
      redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
   }
   
   @IBAction func stop(_ sender: Any) {
    redView.layer.removeAllAnimations()
    reset(nil)
   }
   
   @IBAction func animate(_ sender: Any) {
      let animations: () -> () = {
         var frame = self.redView.frame
         frame.origin = self.view.center
         frame.size = CGSize(width: 100, height: 100)
         self.redView.frame = frame
         self.redView.alpha = 0.5
         self.redView.backgroundColor = UIColor.blue
      }
    //options : UIViewAnimationOptions 배열로 다양한 옵션(반복, 터치 등)을 넣을 수 있다.
    UIView.animate(withDuration: 3, delay: 0, options: [.curveEaseOut, .repeat, .autoreverse, .allowUserInteraction, .beginFromCurrentState], animations: animations, completion: nil)
   }
    
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      reset(nil)
   }
}












