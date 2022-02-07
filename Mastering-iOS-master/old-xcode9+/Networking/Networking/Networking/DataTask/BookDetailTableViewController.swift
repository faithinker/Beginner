
import UIKit

class BookDetailTableViewController: UITableViewController {
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descLabel: UILabel!
   @IBOutlet weak var dateLabel: UILabel!
   
   lazy var formatter: DateFormatter = {
      let f = DateFormatter()
      f.dateStyle = .long
      f.timeStyle = .none
      return f
   }()
   
   // Code Input Point #3
    var book: Book?
   // Code Input Point #3
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Code Input Point #4
    titleLabel.text = book?.title
    descLabel.text = book?.desc
    dateLabel.text = formatter.string(from: book!.date) //"\(book?.date)"
      // Code Input Point #4
   }
   
   override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
      guard indexPath.row == 3 else {
         return nil
      }
      
      return indexPath
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      if indexPath.row == 3 {
         // Code Input Point #6
        if let link = book?.link, let url = URL(string: link) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
            
        }
         // Code Input Point #6
      }
   }
}
