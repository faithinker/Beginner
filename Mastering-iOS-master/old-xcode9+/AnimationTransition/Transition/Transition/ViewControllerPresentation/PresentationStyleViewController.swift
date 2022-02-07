
import UIKit

// presenting 표시하는  (아래쌓인 뷰)
// presented  표시받는 (새로 위에 쌓여진 뷰)

class PresentationStyleViewController: UIViewController {
   
   @IBAction func present(_ sender: UIButton) {
      let sb = UIStoryboard(name: "Presentation", bundle: nil)
      let modalVC = sb.instantiateViewController(withIdentifier: "ModalViewController")
    
      let style = UIModalPresentationStyle(rawValue: sender.tag) ?? .fullScreen
      modalVC.modalPresentationStyle = style
      
      // popover를 할 때는 sourceView barButtonItem을 설정해야한다. 
      if let pc = modalVC.popoverPresentationController {
        pc.sourceView = sender
        modalVC.preferredContentSize = CGSize(width: 500, height: 300)
      }
    
      
      
      printPresentationStyle(for: modalVC)
      present(modalVC, animated: true, completion: nil)
   }
   

   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      print(String(describing: type(of: self)), #function)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      print(String(describing: type(of: self)), #function)
   }
}

//아이패드로 시뮬레이터 돌려서 확인해보기 (가로모드)
extension PresentationStyleViewController {
   func printPresentationStyle(for vc: UIViewController) {
      print("\n\n============== ", separator: "", terminator: "")
      
      switch vc.modalPresentationStyle {
      case .fullScreen:
         print("Full Screen")
      case .pageSheet:
        print("Page Sheet") // 많은 내용 표시, 스크롤이 필요
      case .formSheet:
         print("Form Sheet") //간단한 입력, 적은 내용 표시
      case .currentContext:
         print("Current Sheet")
      case .overFullScreen:
         print("Over Full Screen")
      case .overCurrentContext:
         print("Over Current Context")
      case .popover:
         print("Popover")
      default:
         print("")
      }
   }
}
