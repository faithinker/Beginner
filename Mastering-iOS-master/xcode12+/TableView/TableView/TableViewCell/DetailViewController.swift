
import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var valueLabel: UILabel!
    
    
    var value: String?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        valueLabel.text = value
    }
}
