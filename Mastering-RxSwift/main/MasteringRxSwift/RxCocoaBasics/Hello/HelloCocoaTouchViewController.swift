
import UIKit


class HelloCocoaTouchViewController: UIViewController {
   
   @IBOutlet weak var valueLabel: UILabel!
   
   @IBAction func onTap(_ sender: Any) {
        valueLabel.text = "Hello, Cocoa Touch"
   }   
}
