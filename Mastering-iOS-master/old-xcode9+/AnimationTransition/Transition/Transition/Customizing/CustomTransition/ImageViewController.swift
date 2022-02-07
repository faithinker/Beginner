
import UIKit

class ImageViewController: UIViewController {
   
   @IBOutlet weak var imageView: UIImageView!
   
   var image: UIImage?
   
   @IBOutlet weak var topConstraint: NSLayoutConstraint!
   
    func showCloseButton() {
        topConstraint.constant = 40
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    // 버튼이 이동하고 트랜지션이 실행
   @IBAction func dismiss(_ sender: Any) {
    //dismiss(animated: true, completion: nil)
    
    // 버튼을 화면 위로 올린다음 트랜지션 실행
    topConstraint.constant = -100
    
    UIView.animate(withDuration: 0.3) {
        self.view.layoutIfNeeded()
    } completion: { finishied in
        self.dismiss(animated: true, completion: nil)
    }

    
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      topConstraint.constant = -100 //버튼을 보이지 않는 위치로 이동
      imageView.image = image
   }
}
// SimplePresentationController
