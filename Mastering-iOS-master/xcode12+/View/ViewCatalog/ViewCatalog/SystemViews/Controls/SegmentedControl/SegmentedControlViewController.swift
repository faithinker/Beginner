
import UIKit

class SegmentedControlViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var momentarySwitch: UISwitch!
    
    @IBAction func toggleMomentary(_ sender: UISwitch) {
        alignmentControl.isMomentary = sender.isOn
    }
    @IBOutlet weak var alignmentControl: UISegmentedControl!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //segment selected 속성이 가운데로
        alignmentControl.selectedSegmentIndex = label.textAlignment.rawValue
        momentarySwitch.isOn = alignmentControl.isMomentary
        alignmentControl.setTitle("왼쪽", forSegmentAt: 0)
        alignmentControl.setTitle("가운데", forSegmentAt: 1)
        alignmentControl.setTitle("오른쪽", forSegmentAt: 2)
    }
    
    @IBAction func alignmentChanged(_ sender: UISegmentedControl) {
        //segment 클릭시 hello 레이블 위치가 변경됨
        label.textAlignment = NSTextAlignment(rawValue: sender.selectedSegmentIndex) ?? .center
    }
    //segment Attribute Inspector 속성 : momentary  value changed는 발생하지만 선택상태가 유지되지 않는다.
    
}














