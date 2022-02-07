import UIKit

class ImageButtonViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let normalImage = UIImage(named: "plus-normal")
        let highlitedImage = UIImage(named: "plus-highlited")
        
        btn.setBackgroundImage(normalImage, for: .normal)
        btn.setBackgroundImage(highlitedImage, for: .highlighted)
        
    }
}
