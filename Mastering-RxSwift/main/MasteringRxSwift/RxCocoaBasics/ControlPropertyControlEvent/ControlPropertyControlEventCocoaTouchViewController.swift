
import UIKit

class ControlPropertyControlEventCocoaTouchViewController: UIViewController {
   
   @IBOutlet weak var colorView: UIView!
   
   @IBOutlet weak var redSlider: UISlider!
   @IBOutlet weak var greenSlider: UISlider!
   @IBOutlet weak var blueSlider: UISlider!
   
   @IBOutlet weak var redComponentLabel: UILabel!
   @IBOutlet weak var greenComponentLabel: UILabel!
   @IBOutlet weak var blueComponentLabel: UILabel!
   
   @IBAction func sliderChanged(_ sender: Any) {
      let redComponent = CGFloat(redSlider.value) / 255
      let greenComponent = CGFloat(greenSlider.value) / 255
      let blueComponent = CGFloat(blueSlider.value) / 255
      
      let color = UIColor(red: redComponent, green: greenComponent, blue: blueComponent, alpha: 1.0)
      colorView.backgroundColor = color
      
      updateComponentLabel()
   }
   
   @IBAction func resetColor(_ sender: Any) {
      colorView.backgroundColor = UIColor.black
      
      redSlider.value = 0
      greenSlider.value = redSlider.value
      blueSlider.value = redSlider.value
      
      updateComponentLabel()
   }
   
   private func updateComponentLabel() {
      redComponentLabel.text = "\(Int(redSlider.value))"
      greenComponentLabel.text = "\(Int(greenSlider.value))"
      blueComponentLabel.text = "\(Int(blueSlider.value))"
   }
}
