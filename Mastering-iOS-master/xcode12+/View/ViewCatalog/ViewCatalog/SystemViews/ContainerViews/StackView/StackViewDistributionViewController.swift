
import UIKit
//어렵다 이해 잘 안감  3번 듣자
class StackViewDistributionViewController: UIViewController {
    //StackView 2번째 강의 7분 다시듣기
    //Axis와 동일한 축에서 크기와 배치방식을 지정한다. Axis가 Horizontal이면 너비와 수평방식 지정, Vertical이면 높이와 수직
    //stackView가 어떻게 배치되는가에 따라 달라진다.
    
    //StackView>Distribution
    //Fill : intrinsic size, Fill equally : 모든 SubView가 가장 큰 너비로 통일
    //Eqaul Centering : SubView센터와 센터 사이의 간격이 같아진다.
    
    //Size Inspector에 있는 기능
    //CH: Content Hugguing Priority
    //CR: Content Compression Resistance Priority
    
    //stack View의 너비가 고정되어 있다. View를 배치할 공간이 필요 이상으로 크거나 작은경우 발생
    //Distribution Fill일시 오류 발생, CH와 CR을 다르게 설정 또는 버튼의 너비제약 직접 추가
    
    //Fill Proportionally : intrinsic size의 크기에 따라 나뉘어짐
    //Equal spacing : subView를 intrinsic size로 배치한다.
    //Eqaul Centering : 동일하게 spacing을 설정하고  framedml center를 기준으로 추가한다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}
