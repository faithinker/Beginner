
import UIKit

class TextButtonViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    //button의 distribution에서 State config : Highlighted로 설정해준다.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // button은 titlelabel에 접근하여 text와 textColor를 바꾸는 것을 허용하지 않는다.
        //UIButton이 제공하는메서드를 사용해야 한다.
        
        //btn.titleLabel?.text = "Hello"
        //btn.titleLabel?.textColor = UIColor.red
        
        //마지막 파라미터로 state를 묻는다.
        btn.setTitle("Hello", for: .normal)
        btn.setTitle("Haha", for: .highlighted)
        
        btn.setTitleColor(.systemRed, for: .normal)
        
        btn.titleLabel?.backgroundColor = UIColor.yellow
        //print(type(of: btn.titleLabel?.backgroundColor))
    }
}
