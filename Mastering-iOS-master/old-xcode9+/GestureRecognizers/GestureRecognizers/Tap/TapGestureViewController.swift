// Tab, Pan(=Drag), Pinch, Rotation, Swipe(Slide), LongPress(3D touch)
// User Screen Touch -> Window -> GestureRecognizer -> View
// 터치가 발생하면 윈도우 객체로 전달, 윈도우는 터치가 발생한 위치에 어떤 뷰가 있는지 파악한 다음 뷰와 연관된 제스쳐리코그가 있는지 확인한다. 제스처리코그가 있다면 터치 시퀀스를 전달,
// 제스처리코그는 전달된 시퀀스를 파악하고 자신이 인식할 수 있는제스처라면 직접 처리한다.
// 인식 불가한 제스쳐라면 연결되어있는 뷰로 터치시퀀스를 전달한다.
//
//
// 제스처 코드
// 1. InterfaceBuilder 또는 Code로 GestureRecognizer 생성자 생성
// 2. 제스처를 처리 할 뷰와 제스처리코그를 연결, 제스처리코그는 반드시 하나 이상의 뷰와 연결해야 하고, 뷰는 두개이상 제스쳐리코그를 가질 수 있다.
// 3. 제스처 인식시 실행할 코드를 구현한다. 그리고 제스처리코그와 액션을 연결한다.
//
// 모든 제스처는 Discrete 또는 Continuous에 속한다.
// Discrete : 단일동작인 제스처, 제스처가 완료된 다음 하나의 액션을 전달
// Continuous : 지속적인 제스처, 제스처시퀀스가 진행되는 동안 액션을 반복적으로 전달
//
// 제스처리코그가 전달하는 액션에는 현재 "상태"를 나타내는 값이 저장되어 있다.
// 제스처의 상태 : Possible Began Changed Ended Cancelled Failed Recognized
// Possible : 모든 제스처의 초기단계, Began : Continuous 제스처일시, Changed : 제스처 시퀀스가 계속됨
// Ended : 제스처 시퀀스가 완료 액션을 전달하고 Possible 상태로 전환,
// Cancelled : 제스처시퀀스가 취소될 때 , Failed : 제스처가 인식불가 (커스텀 구현할 때 빼고는 신경 ㄴㄴ),
// Recognized : 멀티터치 시퀀스를 제스처를 인식한 경우에 리코그나이즈드로 전달됨


// 라이브러리에서 제스처 추가하면 Scene Dock 에 제스처가 추가된다.
// -> 씬독 또는 도큐먼트 아웃라인에서 ctrl + 드래그해서 액션 연결
// Attribute Inspector > Tap Gesture Recognizer > Recognize
// > Taps : 숫자 싱글탭, 혹은 더블탭(더블클릭)을 처리한다는 뜻
// > Touches : 제스처에 필요한 터치의 갯수, 2일시 두손가락 탭
// Label 우클릭하면 Connection Panel이 나타남
// Label > Attribute Inspector > View > Interaction > User Interaction Enabled : Check

import UIKit

class TapGestureViewController: UIViewController {
  var count = 0
  
  @IBAction func handleTap(_ sender: UITapGestureRecognizer) {
    if sender.state == .ended { //터치 끝난후 실행, state로 상태 확인하고 값 전달하자!
      count += 1
      countLabel.text = "\(count)"
    }
  }
  
   
   @IBOutlet weak var countLabel: UILabel!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      countLabel.text = "\(count)"
   }
   
   
   
}
