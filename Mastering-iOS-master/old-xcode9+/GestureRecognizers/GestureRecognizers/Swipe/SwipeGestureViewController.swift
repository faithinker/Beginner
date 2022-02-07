// 화면전환, 화면을 터치한 상태에서 지정한 방향으로 일정거리 이상 움직인 경우에 해당된다.
// 속도가 중요하다. 속도 거리 방향 상관관게를 파악해야 한다. 속소 거리 비례, 방향은 반비례
// 속도↓면 거리↓어도 Swipe로 인식하지만 방향 정확성 요구.
// 속도↑ 방향이↓(부정확해도) 되지만 거리↑를 많이 움직여야 한다.

// Swipe는 한 방향만 인식하기 때문에 여러 제스처를 인시갛고 싶으면 Gesture를 여러개 추가해야 한다.
//
import UIKit

class SwipeGestureViewController: UIViewController {
   
  @IBAction func handleSwipeGesture(_ sender: UISwipeGestureRecognizer) {
    if sender.state == .ended {
      let modalVC = self.storyboard?.instantiateViewController(withIdentifier: "modalVC") //StoryBoard ID 연결
      modalVC?.modalTransitionStyle = .coverVertical
      self.present(modalVC!, animated: true, completion: nil)

      //let modalVC = ModalViewController()
      //self.addChild(modalVC)

    }
    
  }
  override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
   
}
