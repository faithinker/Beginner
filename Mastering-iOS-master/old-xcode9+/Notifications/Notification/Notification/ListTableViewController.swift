import UIKit

class ListTableViewController: UITableViewController {
   
   @objc func postNotification() {
//    NotificationCenter.default.post(name: NSNotification.Name.NewValueDidInput, object: nil, userInfo: ["NewValue":"dummy"])
   }

   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Post", style: .plain, target: self, action: #selector(postNotification))
   }
}
