//중요한 내용이다. 한번 더 들을 것
//built-in Presentation
import UIKit

class PresentationViewController: UIViewController {
   
   @IBAction func unwindToHere(_ sender: UIStoryboardSegue) {      
   }
   
   @IBAction func present(_ sender: Any) {
    //withIdentifier : VC의 스토리보드 ID
    guard let modalVC = storyboard?.instantiateViewController(withIdentifier: "ModalViewController") else { return }
    //completion : 트랜지션이 완료된 후에 전달할 코드
    present(modalVC, animated: true, completion: nil)
    
    
    //show(UIViewController, sender: Any?) //push Segue
    //showDetailViewController(UIViewController, sender: Any?)
   }
}

//Container에 Embedding : Navigation View, Split view, scroll view
// View -> View로 이동















