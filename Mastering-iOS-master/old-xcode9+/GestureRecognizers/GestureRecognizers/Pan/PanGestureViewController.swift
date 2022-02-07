// RootView에 Gesture 추가하면 if 빨간색 Frame에만 제스쳐 반응하도록 해야한다. 귀찮다.
// 빨간객 뷰에만 제스쳐 추가하면 편하다. 이동거리를 계산할 뷰만 알려주면 얼마만큼 이동했는지 알아서 처리한다.
//
//
import UIKit

class PanGestureViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   //시작과 끝을 구분해야 한다면 began changed Ended 필터 적용해서 처리
  @IBAction func handlePanGesture(_ sender: UIPanGestureRecognizer) {
    
    //제스처가 발생한 뷰를 확인하고 상수에 저장
    guard let targetView = sender.view else { return }
    
    //이동거리 Root뷰 내에서 터치가 얼마나 이동했는지 리턴해준다.
    let translation = sender.translation(in: view)
    targetView.center.x += translation.x
    targetView.center.y += translation.y
    
    //View를 이동시킨 다음 이동거리를 초기화시켜주면 누적되서 과하게 이동하지 않게 된다.
    //마지막 메소드가 호출된 시점부터 현재까지 이동한 거리만 리턴해준다.
    sender.setTranslation(.zero, in: view)

    if sender.state == .ended {
      targetView.center = (CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height / 2))
    }
  }
  
   override func viewDidLoad() {
      super.viewDidLoad()
      
      redView.layer.cornerRadius = 50
      redView.clipsToBounds = true
   }
}
