
import UIKit

class AddTextFieldViewController: UIViewController {
    //반투명 눌러도 사라지지 않음
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBAction func show(_ sender: Any) {
        let controller = UIAlertController(title: "Sign In to iTunes Store", message: nil, preferredStyle: .alert)
        controller.addTextField { (idField) in
            idField.placeholder = "Apple ID"
        }
        controller.addTextField { (passwordField) in
            passwordField.placeholder = "Password"
            passwordField.isSecureTextEntry = true
        }
        let okAction = UIAlertAction(title: "Ok", style: .default) { [weak self] (action) in
            if let fieldList = controller.textFields {
                if let idField = fieldList.first {
                    self?.idLabel.text = idField.text
                }
                if let passwordField = fieldList.last {
                    self?.passwordLabel.text = passwordField.text
                }
            }
        }
        controller.addAction(okAction)
        
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel, handler: nil)
        controller.addAction(cancelAction)
        
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}


























