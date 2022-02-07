// Visual Effect View 
// Attribute Inspector > Min Duration : X초 이상 누르면 LongPress로 인식
// > Tolerance : 오차범위 화면을 X초(Min Duration옵션만큼) 이상 누르고
// 터치의 이동범위가 10p 보다 작을 때, LongPress로 인식

import UIKit

class LongPressGestureViewController: UIViewController {
   
  @IBOutlet weak var blurView: UIVisualEffectView!
   
  @IBAction func handleLongPressGesture(_ sender: UILongPressGestureRecognizer) {
    
    //Continuous Gesture이다.
    if sender.state == .began {
      blurView.isHidden = true
    } else if sender.state != .changed {
      //changed에서는 실행하지 않고 정상적으로 완료되거나 에러로 중지되는 경우에 실행된다.
      blurView.isHidden = false
    }
  }
 
   
   
   
}
