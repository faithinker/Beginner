//UIView Class는 Animation에 쓰인는 메소드를 타입메소드로 제공한다.
//Block-based-api
//frame, bounds center, transform, alpha, backgroundColor
//simulatoer > Debug > Slow animation : cmd + T

import UIKit

class SimpleUIViewAnimationViewController: UIViewController {
   
   @IBOutlet weak var redView: UIView!
   
   @IBAction func reset(_ sender: Any?) {
      redView.backgroundColor = UIColor.red
      redView.alpha = 1.0
      redView.frame = CGRect(x: 50, y: 100, width: 50, height: 50)
   }
   
   @IBAction func animate(_ sender: Any) {
        var frame = redView.frame
        frame.origin = view.center
        frame.size = CGSize(width: 100, height: 100)
    //animate의 animations의 Parameter는 Inline closure, trailing Closure 형태이다.
//    UIView.animate(withDuration: 3) {
//        self.redView.frame = frame
//        self.redView.alpha = 0.5
//        self.redView.backgroundColor = UIColor.blue
//    }
    
    UIView.animate(withDuration: 3) {
        self.redView.frame = frame
        self.redView.alpha = 0.5
        self.redView.backgroundColor = UIColor.blue
    } completion: { finished in
        //completion : animation이 정상적으로 작동되면 true
        UIView.animate(withDuration: 3, animations: {
        self.reset(nil)
        })
      }
    }
    
//animation의 중요한 요소는 Curve이다.
//EaseInOut Curve : 천천히 -> 빠르게 -> 천천히
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      reset(nil)
   }
}
