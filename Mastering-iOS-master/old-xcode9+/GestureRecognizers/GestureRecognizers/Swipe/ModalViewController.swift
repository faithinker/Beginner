// Simulator 두개터치 조작법
// Opt + Shift + Drag = Swipe, Pan
// Opt + Mouse : Rotate, Pinch

import UIKit

class ModalViewController: UIViewController {
   
  //handle Gesture는 Discrete Gesture이다.
  @IBAction func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
    
    if sender.state == .ended {
      dismiss(animated: true, completion: nil)
    }
  }
  
  
  
   
  
   
}
