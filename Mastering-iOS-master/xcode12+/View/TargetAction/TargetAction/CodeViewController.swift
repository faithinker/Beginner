
import UIKit

class CodeViewController: UIViewController {
    
    @IBOutlet weak var btn: UIButton!
    
    @IBOutlet weak var slider: UISlider!
    
    func action(){
        
    }
    @objc func action(_ sender: Any) {
        print(#function) //자기자신 함수를 호출함
    }
    @objc func action(_ sender: Any, forEvent event: UIEvent) {
        
    }
    //#selector로 형변환 할 때는 objc 특성을 argument 해줘야 한다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let sel = #selector(action(_:))
        btn.addTarget(self, action: sel, for: .touchUpInside)
        
        let sel2 = #selector(action(_:forEvent:))
        slider.addTarget(self, action: sel2, for: .valueChanged)
        
    }
}
