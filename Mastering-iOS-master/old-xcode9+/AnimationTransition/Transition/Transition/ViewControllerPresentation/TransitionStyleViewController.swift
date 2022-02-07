
import UIKit

class TransitionStyleViewController: UIViewController {
   
   var selectedTransitionStyle = UIModalTransitionStyle.coverVertical
   
   @IBAction func styleChanged(_ sender: UISegmentedControl) {
      selectedTransitionStyle = UIModalTransitionStyle(rawValue: sender.selectedSegmentIndex) ?? .coverVertical
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let presentedVC = segue.destination
    
    presentedVC.modalTransitionStyle = selectedTransitionStyle
    
   }
   
   
   @IBAction func present(_ sender: Any) {
      let sb = UIStoryboard(name: "Presentation", bundle: nil)
      let modalVC = sb.instantiateViewController(withIdentifier: "ModalViewController")
      
      modalVC.modalTransitionStyle = selectedTransitionStyle
    
      present(modalVC, animated: true, completion: nil)
   }
}

//presentaion style이 full screen이어야 한다.
//presentedVC 에서 새로운VC를 모달 방식으로 표시 할 수 없다.

//curl 방식일 때는 full screen이어야 한다.
















