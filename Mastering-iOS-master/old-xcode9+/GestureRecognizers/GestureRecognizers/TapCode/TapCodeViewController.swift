

import UIKit

class TapCodeViewController: UIViewController {
   
   var count = 0
   
   @IBOutlet weak var countLabel: UILabel!
   
   var tapGesture : UITapGestureRecognizer?
  
  @objc func handleTap(_ tap: UITapGestureRecognizer) {
    if tap.state == .ended {
      count += 1
      countLabel.text = "\(count)"
    }
  }
  
   override func viewDidLoad() {
      super.viewDidLoad()
      
      countLabel.text = "\(count)"
        //Action 메소드가 구현되어있는 인스턴스를 전달
    tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
    
    tapGesture?.numberOfTapsRequired = 1
    tapGesture?.numberOfTouchesRequired = 1
    
    // Gesture를 처리할 뷰에 GestureRecognizer를 추가해야 한다.
    countLabel.addGestureRecognizer(tapGesture!)
    
    countLabel.isUserInteractionEnabled = true
   }
}
