
import UIKit

class PresentationContextViewController: UIViewController {

  //storyboard segue 클릭 > Inspector > Presentation : Current Context
  // 새로운 화면을 표시할 프레임을 제공한다. Root View, ContainerView, NavigationView
    
//UIKit은 presentation이 시작되기 전에 VC에서 definesPresentationContext 값이
    //true로 설정된 controller를 검색한다.
  
   @IBAction func switchChanged(_ sender: UISwitch) {
    //switch가 on 일때 현재씬을 presentation Context로 지정
    definesPresentationContext = sender.isOn
    
   }
    //상황 : Presentation을 NaviVC로 하는냐 아니면 VC로 하느냐에 따라 새로운 presented 하고 제거할 때 결과가 달라짐
    //current context style은 presenting 뷰 컨트롤러를 뷰 계층에서 제거한다.
    // 해결방법
    // 1. 이전화면 돌아가기 전에 presented vc를 제거한다.
    // 2. over current context 스타일로 지정한다. => storyboard
}




























