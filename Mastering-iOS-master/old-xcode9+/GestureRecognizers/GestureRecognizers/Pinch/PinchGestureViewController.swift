// Attribute Inspector > PinchGesture Reconizer > Scale
// 원래 비율에 대한 상대적인 크기 1보다 크면 확대, 1보다 작으면 축소이다.
//
// User Interaction Enabled 체크
//
// simulator Gesture 사용법
// opt + 트랙패트 스크롤 : Pinch
// opt + 트랙패트 원형 : Rotate
import UIKit

class PinchGestureViewController: UIViewController {
   
   @IBOutlet weak var imageView: UIImageView!
   
   
  @IBAction func handlePinch(_ sender: UIPinchGestureRecognizer) {
    
    guard let targetView = sender.view else { return }
    
    //Frame을 변경하지 않고 transform 속성으로 affine 변환을 수행한다.
    targetView.transform = targetView.transform.scaledBy(x: sender.scale, y: sender.scale)
    
    // scale 값이 누적되면서 변하기 때문에 급격하게 확대된다. 따라서 scale을 초기화 해줘야 한다.
    // 확대 -> 초기화 -> 확대 -> 초기화 반복
    sender.scale = 1
    
    if sender.state == .ended {
      UIView.animate(withDuration: 0.3) {
        self.imageView.transform = CGAffineTransform.identity
      }
    } 
  }
  
  
  
   @IBAction func reset(_ sender: Any) {
    //확대 축소 회전과 같은 것들이 모두 초기화 됨
    UIView.animate(withDuration: 0.3) {
      self.imageView.transform = CGAffineTransform.identity
    }
   }

}
