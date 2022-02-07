
import UIKit

class AutoLayoutAnimationViewController: UIViewController {

   @IBOutlet weak var redView: UIView!
   
   @IBOutlet weak var widthConstraint: NSLayoutConstraint!

   @IBOutlet weak var heightConstraint: NSLayoutConstraint!
   
   @IBAction func animate(_ sender: Any) {
    //Frame을 통해 크기를 업데이트 하면 가로회전시 초기화됨
//      let targetFrame = CGRect(x: view.center.x - 100, y: view.center.y - 100, width: 200, height: 200)
//
//      UIView.animate(withDuration: 0.3) {
//         self.redView.frame = targetFrame
//      }
    //제약 자체를 업데이트 해야한다.
    //항상 애니를 시작하기전에 제약을 업데이트 해야한다.
        self.widthConstraint.constant = 200
        self.heightConstraint.constant = 200
        redView.setNeedsUpdateConstraints()
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
   }
}













