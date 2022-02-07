
import UIKit

class CGColorCIColorViewController: UIViewController {
    
    @IBOutlet weak var blueView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //UIColor => CG, CI color
        
        blueView.layer.borderWidth = 10
        blueView.layer.borderColor = UIColor.yellow.cgColor
                                    //UIColor.yellow.ciColor
        //UIColor로 쉽게 색깔 만들고 UIColor가 cgColor를 제공해줘서 쓰면 cgColor형으로 바뀜
        //UIColor보다 섬세한 처리 필요 ColorSpace를 상세히 설정, Color에 bit값을 설정
        
        
        //CG, CI => UIColor color
        
        //UIColor(cgColor: <#T##CGColor#>)
        //UIColor(ciColor: <#T##CIColor#>)
        //para CGColorspace를 전달해야하고 개별 component는 Pointer를 전달해야한다.
        //UIColor보다 복잡해서 UIColo로 원하는 색을 설정한다음 CGColor로 바꾸는 방법을 주로 사용한다.
        //ciImage 주로 filter효과를 적용할 때 사용한다.
    }
}
