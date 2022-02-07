import UIKit

class ResizableImageViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    let btnImage = UIImage(named: "btn")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = btnImage {
            let capInet = UIEdgeInsets(top: 14, left: 14, bottom: 14, right: 14)
            let bgImage = img.resizableImage(withCapInsets: capInet, resizingMode: .stretch)
            btn.setBackgroundImage(bgImage, for: .normal)
        }
        
    }
}
