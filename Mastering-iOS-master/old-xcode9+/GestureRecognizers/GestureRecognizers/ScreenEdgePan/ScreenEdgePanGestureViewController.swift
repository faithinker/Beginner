// Pan : 화면에서 -> 화면 제스처
// Screen Edge Pan : 가장자리 화면 -> 화면
// 뷰에 Screen Edge Pan Gesture가 추가 되어야 한다. 그렇지 않으면 일반적인 Pand으로 인식한다.
//
// Attribute Inspector > Edges : 옵션을 두개 이상 체크 할 수 있지만 실제로는 하나의 엣지만 처리 할 수 있다.
// 두개이상 하면 인식하지 못하기 때문에 반드시 한개의 제스처만 선택한다.
//
// EdgePanGesture의 적용사례 Safari,  LeftEdgePan : 이전화면, RightEdgePan : 다음화면
// 시스템이 EdgePan Gesture를 사용하기 때문에 잘 쓰이지 않는다.
// TopEdge : NotiCenter
// BottomEdge : HomeDisplay
// NavigationController는 LeftEdge를 사용함
// 시스템제스처를 비활성화하거나 우선순위를 후위로 밀려나게 한 다음 쓸 수 있다.


import UIKit

class ScreenEdgePanGestureViewController: UIViewController {
   
   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var redView: UIView!
   @IBOutlet weak var blueView: UIView!
   
   
  @IBAction func handleScreenEdgePanGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
    if sender.state == .ended {
      UIView.transition(with: containerView, duration: 1, options: [.transitionFlipFromRight], animations: { self.redView.isHidden = !self.redView.isHidden
                      self.blueView.isHidden = !self.blueView.isHidden
      }, completion: nil)
    }
  }
  
  @IBAction func handleBottomScreenEdgeGesture(_ sender: UIScreenEdgePanGestureRecognizer) {
    if sender.state == .ended {
      UIView.transition(with: containerView, duration: 1, options: [.transitionCurlDown], animations: {self.redView.isHidden = !self.redView.isHidden
                          self.blueView.isHidden = !self.blueView.isHidden
      }, completion: nil)
    }
  }
  
  
  override func viewDidLoad() {
      super.viewDidLoad()
      
      redView.isHidden = true
      blueView.isHidden = false
    
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
   }
  
  // UIView Controller에 있는 속성을 Overrding함
  // 모든 Edge에서 시스템 제스쳐보다 내가 작성한 코드가 우선시 됨
  // TopEdge는 작은 Indicator가 생기고 한번더 TopEdge를 Padding 해야 NotiCenter가 보인다. (두번 padding)
   
  override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
    return UIRectEdge.all
  }
  
}
