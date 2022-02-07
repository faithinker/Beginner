
import UIKit
import CoreData

class ProfileViewController: UIViewController {
   @IBOutlet weak var profileImageView: UIImageView!
   
   @IBOutlet weak var deptLabel: UILabel!
   
   @IBOutlet weak var salaryLabel: UILabel!
   
   lazy var formatter: NumberFormatter = {
      let f = NumberFormatter()
      f.locale = Locale(identifier: "en_US")
      f.numberStyle = .currency
      return f
   }()
   
   var target: NSManagedObject?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      if let target = target {
//         if let data = target.value(forKey: "photo") as? Data {
//            profileImageView.image = UIImage(data: data)
//         }
        
        if let data = target.value(forKeyPath: "profile.photo") as? Data {
           profileImageView.image = UIImage(data: data)
        }
         
         deptLabel.text = target.value(forKeyPath: "department.name") as? String
         salaryLabel.text = formatter.string(for: target.value(forKey: "salary"))
      }
   }
}
