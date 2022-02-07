
import UIKit

class CustomDrawingView: UIView {
    let starImg = UIImage(systemName: "star")
    let bellImg = UIImage(systemName: "bell")
    let umbrellaImg = UIImage(systemName: "umbrella")
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        starImg?.draw(at: CGPoint(x: 0, y: 0)) //크기 지정안하면 원본크기 출력
        bellImg?.draw(in: CGRect(x: 0, y: 80, width: 100, height: 100))
        umbrellaImg?.drawAsPattern(in: rect)
        //이미지의 크기가 프레임보다 작다면 패턴 형태로 나온다.
    }
}



class CustomImageDrawingViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
