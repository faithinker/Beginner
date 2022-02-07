
import UIKit

class StackViewAxisViewController: UIViewController {
    //https://www.hackingwithswift.com/example-code/uikit/how-to-animate-views-using-animatewithduration
    //axis 축의 기준이 수직이면 spacing은 세로 간격, 수평이면 가로간격
    @IBOutlet weak var stackView: UIStackView!
    
    
    @IBAction func toggleAxis(_ sender: Any) {
        UIView.animate(withDuration: 0.3) { [self] in
            // NSLayoutConstraint 열거형
            if stackView.axis ==  .horizontal {
                stackView.axis = .vertical
            }else {
                stackView.axis = .horizontal
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
