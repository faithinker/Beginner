//동일한 컨테이너에 속한 서브 뷰들 사이에 실행된다.
//alt + return 시 블록 자료형 안없어짐
import UIKit

class ViewTransitionViewController: UIViewController {
   
   @IBOutlet weak var containerView: UIView!
   @IBOutlet weak var redView: UIView!
   @IBOutlet weak var blueView: UIView!
   
   @IBAction func startTransition(_ sender: Any) {
//트래진션이 실행될 컨테이너뷰를 전달한다.
    //애니메이션 블록 구현패턴.
    //1. 사라지는 뷰를 뷰계층에서 제거하고 새롭게 추가될 뷰를 뷰계층에서 추가한다.
    //제거된 뷰는 약한참조로 연결되어 있고 다른 소유자가 없다면, 메모리에서 즉시 제거됨
    //나중에 다시 추가하려면 outlet으로 strong 연결 해야한다.
    
    //2. isHidden 속성을 토글한다. 뷰 계층에 영향을 주지 않고 트랜지션 구현가능
    //2번째를 주로 쓴다. 첫파라미터를 트랜지션 제어할 상위 컨테이너뷰
    //애니메이션에서 트랜지션 할 뷰 직접 제어
    
//    UIView.transition(with: containerView, duration: 1, options: [.transitionCrossDissolve]) {
//        self.redView.isHidden = !self.redView.isHidden
//        self.blueView.isHidden = !self.blueView.isHidden
//    } completion: { _ in
//        Void.self
//    }
    
    //트랜지션 대상뷰를 직접 파라미터로 전달, 대시엔 애니메이션 블록이 없다. from : 제거할 뷰
    //to : 새롭게 추가할 뷰 /. 두개 모두 동일한 계층 뷰에 속해야 한다.
    UIView.transition(from: redView, to: blueView, duration: 1, options: [.transitionFlipFromLeft, .showHideTransitionViews]) { finished in
        UIView.transition(from: self.blueView, to: self.redView, duration: 1, options: [.transitionFlipFromRight, .showHideTransitionViews]) { _ in
            Void.self
        }
    }
//앱이 동작하나, 구현이 제대로 안될 떄는 하단 BreakPoint 옆 Debug View Hierarchy를 봐라

   }
//showHideTransitionViews는 메소드가 뷰 계층을 조작하지 않고 isHidden속성을 토글한다.
    //뷰 계층을 제거하고 싶으면 completion handler에서 제거하면 된다.
    //새로 추가할 뷰는 메소드를 호출하기 전에 뷰 계층에 미리 추가하면 된다.
    //트랜지션 하는동안 뷰가 제거되지 않기 때문에(=hidden된다.) outlet을 약하게 연결해도 된다.
   override func viewDidLoad() {
      super.viewDidLoad()
      //view계층에서 추가하거나 삭제할 때는 hidden 옵션을 해체해야한다.
    blueView.isHidden = false
      
   }
}
