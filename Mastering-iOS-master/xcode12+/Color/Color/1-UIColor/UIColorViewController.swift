
import UIKit

class UIColorViewController: UIViewController {
    
    @IBOutlet weak var targetView: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var greenSlider: UISlider!
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        let r = CGFloat(redSlider.value)
        let g = CGFloat(greenSlider.value)
        let b = CGFloat(blueSlider.value)
        
        targetView.backgroundColor = UIColor(displayP3Red: r, green: g, blue: b, alpha: 1.0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetView.backgroundColor = UIColor(displayP3Red: 29/255, green: 161/255, blue: 242/255, alpha: 1.0)
        //UIColor.(white: <#T##CGFloat#>, alpha: <#T##CGFloat#>) Gray 표현
        //SRGB : 보편적으로 가장 많이 씀
        //DCI-P3 : srgb보다 25% 더 넓은 범위의 색깔을 표현 할 수 있다.
        //아이폰에서 찍은 사진은 이 값을 기본으로 한다.
        //HBS :
        //UIColor.red.withAlphaComponent(0.5) // 기존 컬러에 알파값만 변경
        //UIColor.clear // alpha 값 0.0
        
        var r = CGFloat(0)
        var g = CGFloat(0)
        var b = CGFloat(0)
        var a = CGFloat(0)
        
        //rgb 컴포넌트 추출, 포인터로 전달해야하기 때문에 주소를 참조한다.
        targetView.backgroundColor?.getHue(&r, saturation: &g, brightness: &b, alpha: &a)
        //UnsafeMutablePointer<CGFloat>?
        //targetView.backgroundColor?.getRed(&r, green: &g, blue: &b, alpha: &a)
        
        redSlider.value = Float(r)
        greenSlider.value = Float(g)
        blueSlider.value = Float(b)
    }
}
