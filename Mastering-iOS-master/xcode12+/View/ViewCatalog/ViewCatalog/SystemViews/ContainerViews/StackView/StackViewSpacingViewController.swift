
import UIKit

class StackViewSpacingViewController: UIViewController {
    
    @IBOutlet weak var redView: UIView!
    @IBOutlet weak var horizontalStackView: UIStackView!
    @IBOutlet weak var spacingLabel: UILabel!
    @IBOutlet weak var spacingSlider: UISlider!
    
    @IBAction func spacingChanged(_ sender: UISlider) {
        UIView.animate(withDuration: 0.3) {
            self.horizontalStackView.spacing = CGFloat(sender.value)
        }
        updateLabel()
    }
    
    private func updateLabel() {
        spacingLabel.text = "\(Int(horizontalStackView.spacing))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabel()
        spacingSlider.value = Float(horizontalStackView.spacing)
        //custom spacing의 우선순위가 더 높아서 변하지 않는다.
        horizontalStackView.setCustomSpacing(60, after: redView)
    }
}
