import UIKit

class ColorSetViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //let c = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) //color Literal 상수 저장, 파라미터 전달 가능 / 더블클릭시 팝업 뜸
        
        //version에 따른 Code 분기
        if #available(iOS 11.0, *) {
            view.backgroundColor = UIColor(named: "PrimaryColor") ?? UIColor.white
        } else {
            
        }
        
    }
}
