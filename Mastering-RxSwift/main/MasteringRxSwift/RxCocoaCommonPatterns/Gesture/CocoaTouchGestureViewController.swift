
import UIKit

class CocoaTouchGestureViewController: UIViewController {
   
   @IBOutlet weak var targetView: UIView!
   
   @IBAction func handlePangesture(_ sender: UIPanGestureRecognizer) {
      guard let target = sender.view else { return }
    
      let translation = sender.translation(in: view)
      
      target.center.x += translation.x
      target.center.y += translation.y
      
      sender.setTranslation(.zero, in: view)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      targetView.center = view.center
   }   
}
