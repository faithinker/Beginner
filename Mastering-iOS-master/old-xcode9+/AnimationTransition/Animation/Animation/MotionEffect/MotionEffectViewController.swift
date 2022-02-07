//수평이나 수직으로 기울이면 Parrelex Effect가 나타남
//https://developer.apple.com/documentation/uikit/animation_and_haptics/motion_effects
//MotionEffects > UIMotionEffect
//              > UIMotionEffectGroup
//              > UIInterpolatingMotionEffect

//설정 > 손쉬운 사용 > 동작 줄이기 : Switch Off 일때 동작함
//이 설정 무시하고 할려면 자이로스코프 이벤트를 매번 받아서 직접 처리해야한다.

import UIKit

class MotionEffectViewController: UIViewController {
   
   @IBOutlet weak var targetImageView: UIImageView!
    
   override func viewDidLoad() {
      super.viewDidLoad()
    let x = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
    x.minimumRelativeValue = -100 //offset의 최소값
    x.maximumRelativeValue = 100 ////offset의 최대값
    
    let y = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
    y.minimumRelativeValue = -100
    y.maximumRelativeValue = 100
    
    let group = UIMotionEffectGroup()
    group.motionEffects = [x, y]
    
    targetImageView.addMotionEffect(group)
   }
}















