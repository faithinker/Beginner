
import UIKit

class ButtonStateViewController: UIViewController {
    
    @IBOutlet weak var stateLabel: UILabel!
    
    @IBOutlet weak var btn: UIButton!
    
    //label에 button의 state 표시함
    @IBAction func report(_ sender: UIButton) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            self.stateLabel.text = sender.state.debugString
        }
    }
    
    @IBAction func stateChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            btn.isEnabled = true
            btn.isSelected = false
            btn.isHighlighted = false
        case 1:
            btn.isHighlighted.toggle()
        case 2:
            btn.isSelected.toggle()
        case 3:
            btn.isEnabled = false
        default:
            break
        }
        report(btn)
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stateLabel.text = btn.state.debugString
    }
}




extension UIControl.State {
    var debugString: String {
        var list = [String]()
        if contains(.normal) {
            list.append("Normal")
        }
        if contains(.highlighted) {
            list.append("Highlighted")
        }
        if contains(.disabled) {
            list.append("Disabled")
        }
        if contains(.selected) {
            list.append("Selected")
        }
        
        return list.joined(separator: ", ")
    }
}
