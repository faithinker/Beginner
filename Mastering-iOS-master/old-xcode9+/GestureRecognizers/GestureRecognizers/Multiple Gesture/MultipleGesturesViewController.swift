// 하나의 뷰에서 두개이상의 제스쳐를 처리하는 방법
//
// 하나의 뷰에서 다수의 제스처를 처리할 때 쓰는 테크닉
// 1. 제스처가 인식되는 순서를 지정한다.
// 2. 인식 순서가 고정되어 있지 않다. Delegate Pattern으로 구현
//
// 보통은 한번에 하나의 제스처만 처리한다
//
import UIKit

class MultipleGesturesViewController: UIViewController {
   
   @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
   
   @IBOutlet var rotationGesture: UIRotationGestureRecognizer!
   
   @IBAction func handleRotationGesture(_ sender: UIRotationGestureRecognizer) {
      guard let targetView = sender.view else { return }
      
      targetView.transform =  targetView.transform.rotated(by: sender.rotation)
      sender.rotation = 0
   }
   
   @IBAction func handlePinchGesture(_ sender: UIPinchGestureRecognizer) {
      guard let targetView = sender.view else { return }
      
      targetView.transform = targetView.transform.scaledBy(x: sender.scale, y: sender.scale)
      sender.scale = 1
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
    //1. 순서지정.  로테이션이 인식불가하면 핀치가 실행
    //pinchGesture.require(toFail: rotationGesture)
    
    pinchGesture.delegate = self
    rotationGesture.delegate = self
   }
}


//rotation Gesture를 먼저 인식
extension MultipleGesturesViewController : UIGestureRecognizerDelegate {

  //첫번째 파라미터가 pinchGesture이고 두번째가 Rota일때 true를 리턴하면 Rota를 먼저 인식한다.
//  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    return true
//  }
  
  //모든 제스처가 동시에 처리됨
  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true //false면 하나의 제스처만 실행
  }
  
//  func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//    if gestureRecognizer == pinchGesture && otherGestureRecognizer == rotationGesture {
//      return true
//    }
//    return false
//  }
}

//뷰를 두손가락으로 이동할 수 있도록 작성
