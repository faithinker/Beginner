
import UIKit

//3개이상을 표현할 때 Action Sheet
class AlertViewController: UIViewController {
    
    @IBAction func show(_ sender: Any) {
        let controller = UIAlertController(title: "Hello", message:"Have a nice day", preferredStyle: .alert)
        
        //style의 옵션에는   cancel(bold체, preferred), default, destructive(data change, 빨간색 tint color됨)
        let okAction = UIAlertAction(title: "ok", style: .default) { (action) in
            print(action.title) //action 버튼을 누르면 실행할 Code 내용
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            print(action.title)
        }
        let destructiveAction = UIAlertAction(title: "destructive", style: .destructive) { (action) in
            print(action.title)
        }
        
        controller.addAction(okAction)
        controller.addAction(cancelAction)
        controller.addAction(destructiveAction)
        
        //button의 우선순위도 높아지고(버튼이 VerticalStack일 때 위에 쌓임) 시각적으로도 bold체가 된다.
        controller.preferredAction = okAction
        //preferredAction으로 지정하기 전에 alertControl에 Action을 추가해야 crash가 발생하지 않는다.
        //actionSheet에서는 사용되지 않는다.
        
        present(controller, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}










































