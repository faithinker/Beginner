
import UIKit

class NonContinuousSliderViewController: UIViewController {
    
    @IBOutlet weak var valueLabel1: UILabel!
    @IBOutlet weak var slider1: UISlider!
    
    @IBOutlet weak var valueLabel2: UILabel!
    @IBOutlet weak var slider2: UISlider!
    
    
    //storyboard inspector : Events Continious Update
    //체크하면 계속 값 업데이트, 언체크하면 손 뗼데 값 업데이트
    
    @IBAction func sliderChanged1(_ sender: UISlider) {
        valueLabel1.text = String(format: "%.1f", sender.value)
    }
    
    @IBAction func sliderChanged2(_ sender: UISlider) {
        valueLabel2.text = String(format: "%.1f", sender.value)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slider2.isContinuous = false //Continious Update 언체크 하고 같음
        
    }
    
}
