
import UIKit

class RenderingModeViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let img = UIImage(named: "clover")?.withRenderingMode(.alwaysTemplate) {
            imageView.image = img
        }
        
    }
}
