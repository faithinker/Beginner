
import UIKit

class PatternImageViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let img = UIImage(named: "pattern") {
            let patternColor = UIColor(patternImage: img)
            view.backgroundColor = patternColor
            //개별 크기를 바꾸고 싶으면 이미지 자체를 고쳐야한다. 속성으로 못바꿈
        }
    }
}
