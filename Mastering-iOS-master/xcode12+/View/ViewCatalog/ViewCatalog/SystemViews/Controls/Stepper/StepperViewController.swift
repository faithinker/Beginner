
import UIKit

class StepperViewController: UIViewController {
    //지정된 범위 내에서 값을 증가시키거나 감소시키는 컨트롤이다.
    //Stepper>Behavior>Autorepeat : stepper를 터치하는 동안(길게누르면) 값이 반복적으로 업데이트(계속 증가또는 감소)된다.
    //Continuous : value changed가 전달되는 시점을 설정한다. 체크시 터치할때마다 값 변경 전달(즉시 이벤트 전달)
    //언체크시 터치이벤트가 종료되는 시점에 한번만 전달한다.
    //Wrap : 최소값 또는 최대값에 도달한 시점에서 다음값을 처리하는 방법을 결정함
    //언체크시 : 최소최대시 다음 값 처리하지 않음
    //체크시 : 값이 순환한다. 최소 -> 최대 // 최대 -> 최소
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var valueStepper: UIStepper!
    @IBOutlet weak var autorepeatSwitch: UISwitch!
    @IBOutlet weak var continuousSwitch: UISwitch!
    @IBOutlet weak var wrapSwitch: UISwitch!
    
    
    
    @IBAction func valueChanged(_ sender: UIStepper) {
        valueLabel.text = "\(sender.value)"
    }
    
    @IBAction func toggleAutorepeat(_ sender: UISwitch) {
        valueStepper.autorepeat = sender.isOn
    }
    
    @IBAction func toggleContinuous(_ sender: UISwitch) {
        valueStepper.isContinuous = sender.isOn
    }
    
    @IBAction func toggleWrap(_ sender: UISwitch) {
        valueStepper.wraps = sender.isOn
    }

    override func viewDidLoad() { //모든 스위치를 stepper의 현재 속성으로 초기화
        super.viewDidLoad()
        autorepeatSwitch.isOn = valueStepper.autorepeat
        continuousSwitch.isOn = valueStepper.isContinuous
        wrapSwitch.isOn = valueStepper.wraps
    }
}











