

import UIKit
//subview VS arrangedsubview
class StackViewArrangedSubviewsViewController: UIViewController {
    //여러 뷰를 수직이나 수평으로 배치하는 컨테이너 뷰이다.
    //중요 uiview 추가시 rootview 놓으면 =>  subview
    //stackview 놓으면 => arrangedsubview
    //stackview에는 영향을 받지만 subviews에는 영향을 받지 않는다.
    //var subviews:[UIView] {get}
    //var arrangedSubviews: [UIView] {get}
    @IBOutlet weak var stackView: UIStackView!
    
    //addArrangedSubview, insertArrangedSubview는 subview와 arrangedsubview에는
    //추가하지만 removeArrangedSubview는 arrangedsubview는 삭제하지만 subview를 삭제하지는 않는다.
    @IBAction func add(_ sender: Any) {
        //오른쪽에서 뷰를 추가한다.
        let v = generateView()
        stackView.addArrangedSubview(v)
        
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    @IBAction func insert(_ sender: Any) {
        //왼쪽에서 뷰를 추가한다.
        let v = generateView()
        stackView.insertArrangedSubview(v, at: 0)
        
        UIView.animate(withDuration: 0.3) {
            self.stackView.layoutIfNeeded()
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        guard stackView.arrangedSubviews.count > 0 else {
            return
        }
        //랜덤으로 뷰를 선택한 다음 삭제한다.
        let index = Int.random(in: 0..<stackView.arrangedSubviews.count)
        let v = stackView.arrangedSubviews[index]
        stackView.removeArrangedSubview(v)
        //v.removeFromSuperview()  //subview와 arrangedsubview 모두 배열에서 삭제
        
        //애니메이션이 끝난 뒤 삭제 함수 호출
        UIView.animate(withDuration: 0.3) {
            v.isHidden = true
        } completion: { finished in
            self.stackView.removeArrangedSubview(v)
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let v = generateView()
        v.frame = stackView.bounds //프레임지정?
        stackView.addSubview(v)
    }
}

extension StackViewArrangedSubviewsViewController {
    private func generateView() -> UIView {
        let v = UIView()
        
        let r = CGFloat(arc4random_uniform(256)) / 255
        let g = CGFloat(arc4random_uniform(256)) / 255
        let b = CGFloat(arc4random_uniform(256)) / 255
        v.backgroundColor = UIColor(red: r, green: g, blue: b, alpha: 1.0)
        
        return v
    }
}
