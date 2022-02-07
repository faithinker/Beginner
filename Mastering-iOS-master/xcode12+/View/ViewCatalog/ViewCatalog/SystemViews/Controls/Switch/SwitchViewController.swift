
import UIKit

class SwitchViewController: UIViewController {
    
    @IBOutlet weak var bulbImageView: UIImageView!
    
    @IBOutlet weak var testSwitch: UISwitch!
    //UISwitch는 setOn 메서드를 제공
    @IBAction func stateChanged(_ sender: UISwitch) {
        bulbImageView.isHighlighted = sender.isOn
    }
    
    
    @IBAction func toggle(_ sender: Any) {
        //testSwitch.isOn.toggle()
       //testSwitch의 상태를 반대로 줘야 움직인다. 이유는 모름
        testSwitch.setOn(!testSwitch.isOn, animated: true)
        stateChanged(testSwitch)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        testSwitch.isOn = bulbImageView.isHighlighted
    }
}
