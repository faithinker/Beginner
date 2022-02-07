
import UIKit

class CustomView: UIView {
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        var frame = CGRect(x: 10, y: 10, width: 100, height: 100)
        context?.addRect(frame)
        UIColor.red.setStroke() //border
        context?.strokePath()
        
        frame = CGRect(x: 10, y: 200, width: 100, height: 100)
        context?.addRect(frame)
        UIColor.blue.setFill() //paint
        context?.fillPath()
    }
}

class CustomDrawingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
