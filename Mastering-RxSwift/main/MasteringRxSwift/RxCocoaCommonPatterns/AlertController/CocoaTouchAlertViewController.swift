
import UIKit

class CocoaTouchAlertViewController: UIViewController {
   
   @IBOutlet weak var colorView: UIView!
   
   @IBAction func showAlertWithAction(_ sender: Any) {
      let alert = UIAlertController(title: "Current Color", message: colorView.backgroundColor?.rgbHexString, preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (action) in
         print(self?.colorView.backgroundColor?.rgbHexString ?? "")
      }
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
   }
   
   @IBAction func showAlertWithTwoActions(_ sender: Any) {
      let alert = UIAlertController(title: "Reset Color", message: "Reset to black color?", preferredStyle: .alert)
      
      let resetAction = UIAlertAction(title: "Reset", style: .destructive) { [weak self] (action) in
         self?.colorView.backgroundColor = UIColor.black
      }
      alert.addAction(resetAction)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
   }
   
   @IBAction func showActionSheet(_ sender: Any) {
      let actionSheet = UIAlertController(title: "Change Color", message: "Choose one", preferredStyle: .actionSheet)
      
      for color in MaterialBlue.allColors {
         let colorAction = UIAlertAction(title: color.rgbHexString, style: .default) { [weak self] (action) in
            self?.colorView.backgroundColor = color
         }
         actionSheet.addAction(colorAction)
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      actionSheet.addAction(cancelAction)
      
      present(actionSheet, animated: true, completion: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Do any additional setup after loading the view.
   }   
}
