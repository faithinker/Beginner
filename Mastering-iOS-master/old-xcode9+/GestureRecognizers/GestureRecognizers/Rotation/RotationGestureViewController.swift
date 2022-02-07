// Attribute Inspector > Rotation Gesture Recognizer > Rotation
// 회전값이 Radian 형식으로 저장되어 있다.


import UIKit

class RotationGestureViewController: UIViewController {
   
   @IBOutlet weak var imageView: UIImageView!
   
   //GestureView와 연결된 View를 상수에 저장한다음, Rotation속성에 저장된 값만큼 회전시킨다.
   
  @IBAction func handleRotation(_ sender: UIRotationGestureRecognizer) {
    
    guard let targetView = sender.view else { return }
    
    targetView.transform = targetView.transform.rotated(by: sender.rotation)
    
    sender.rotation = 0
    
    if sender.state == .ended {
      UIView.animate(withDuration: 0.3) {
        self.imageView.transform = CGAffineTransform.identity
      }
    }
    
  }
   
   @IBAction func reset(_ sender: Any) {
    UIView.animate(withDuration: 0.3) {
      self.imageView.transform = CGAffineTransform.identity
    }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
    imageView.isUserInteractionEnabled = true
   }
}
