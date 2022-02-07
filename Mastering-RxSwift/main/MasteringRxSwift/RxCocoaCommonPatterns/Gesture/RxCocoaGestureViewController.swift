
import UIKit
import RxSwift
import RxCocoa

// UIGestureRecognizer+Rx
// event: ControlEvent

class RxCocoaGestureViewController: UIViewController {
   
    // pinch rotation gesture 추가
   let bag = DisposeBag()
    
    
   @IBOutlet weak var targetView: UIView!
   
   @IBOutlet var panGesture: UIPanGestureRecognizer!
    @IBOutlet var pinchGesture: UIPinchGestureRecognizer!
    
   override func viewDidLoad() {
      super.viewDidLoad()
      
    
    ///// Swift Code 주석해제하면 됨
//    let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(pinchAction(_:)))
//
//    targetView.addGestureRecognizer(pinchRecognizer)
    
    /////// End
    
    
      targetView.center = view.center
      
    panGesture.rx.event
        .subscribe(onNext: { [unowned self] gesture in
            guard let target = gesture.view else { return }
            let translation = gesture.translation(in: self.view)
            
            target.center.x += translation.x
            target.center.y += translation.y
            gesture.setTranslation(.zero, in: self.view)
        })
        .disposed(by: bag)
    
    // 실행가능한 코드
    let pinchGesture2 = targetView.rx.pinchGesture().share(replay: 1)
    pinchGesture2.when(.changed)
        .asScale()
        .subscribe(onNext: { [unowned self] scale, _ in
        self.targetView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }).disposed(by: bag)
    
    // 강사님이 의도하는 코드 느낌? 아울렛을 활용해라.
    // 이벤트(제스처) 던져서 반응해서 뷰의 사이즈 변화시킨다.?
//    pinchGesture.rx.event
//        .subscribe(onNext: { [unowned self] scale in
//            guard let target =  scale.view else { return }
//            // 사이즈를 누적해서 더한다.
//            let size = CGFloat(scale.scale * scale.scale)
//            target.transform = CGAffineTransform(scaleX: scale, y: scale)
//
//        })
//        .disposed(by: bag)
      
   }
    
    @objc func pinchAction(_ sender :UIPinchGestureRecognizer){
        
        targetView.transform = targetView.transform.scaledBy(x:                    sender.scale, y: sender.scale)

       sender.scale = 1.0

    }
}



