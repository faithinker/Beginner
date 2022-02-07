
import UIKit

extension UIViewController {
   func showInfoAlert(with message: String) {
      showErrorAlert(with: message, title: "Info")
   }
   
   func showErrorAlert(with message: String, title: String = "Error") {
      DispatchQueue.main.async {
         let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
         
         let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
         alert.addAction(okAction)
         
         self.present(alert, animated: true, completion: nil)
      }
   }
}

