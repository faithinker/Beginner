// RxCocoa : Cocoa 프레임워크에 Reactive의 장점을 더해준 라이브러리이다.
// RXSwift를 기반으로 하는 별도의 라이브러리이다.
//
// Pod > RxCocoa > UIButton+Rx.swift
// extension Reactive where Base: UIButton {
// 여기서 Reactive가 어떻게 구성되어있는가를 본다.
//
// public struct Reactive<Base> {
// Base object to extend.
// public let base: Base
//
// Reactive : RXSwift 라이브러리의 제너릭 구조체로 선언됨. 형식을 reactive 방식으로 확장할 때 사용한다.
// base 확장할 형식의 인스턴스가 저장된다.
//
// extension ReactiveCompatible {
// ReactiveCompatible : 기존 형식에 Rx라는 속성을 추가한다. Rx라는 nameSpace를 추가하는 것과 같다.
//
// public static var rx: Reactive<Self>.Type {   rx라는 타입 프로퍼티
// public var rx: Reactive<Self> {   인스턴스 프로퍼티가 자동으로 추가된다.
//
// extension NSObject: ReactiveCompatible { }
// NSObject가 Reactive Protocol을 채용하도록 선언했다.
// NSObject Cocoa프레임워크에 있는 모든 클래스가 상속하는  root클래스 이기 때문에 모든 클래스에 rx라는 속성
// 즉 네임스페이스가 자동으로 추가된다.
//
// extension Reactive where Base: UIButton {
// Base를 UIButton으로 제한하고 있다. UIButto은 NSObject를 상속한 클래스이기 때문에 자동으로 rx가 추가된다.
//
// public var tap: ControlEvent<Void> {
// return controlEvent(.touchUpInside)
// tap이라는 멤버가 ControlEvent 형식으로 선언 되어 있고 ControlEvent는 RxCocoa가 제공하는 Trait 이다.
// Trait는 UI 처리에 특화된 옵저버블이고 ControlEvent뿐만 아니라 Driver, Signal과 같은 고유한 특성을 가진 Trait를 제공한다.
//
// RxCocoa > UILabel+RX의 text, attributeText 등의 속성은 UIKit > UILabel에 있는 속성과 동일하다.
// 하나의 형식에 같은 이름을 가진 멤버가 두개이상 존재할 수 있지만 문제가 없다.
// 왜냐하면 rx namespace에 추가되기 때문이다.
// let label = UILabel()
// label.text => 인스턴스 이름을 통해 바로 접근 (UIKit > UILabel)
// label.rx.text => rx라는 namespace가 붙음 (RxCocoa가 제공하는 텍스트 속성에 접근)
//
// Binder : 인터페이스 바인딩에 사용되는 특별한 옵저버



import UIKit
import RxSwift
import RxCocoa

class HelloRxCocoaViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var valueLabel: UILabel!
   
   @IBOutlet weak var tapButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
        tapButton.rx.tap
            .map { "Hello RXCocoa"}
            .bind(to: valueLabel.rx.text)
            .disposed(by: bag)
   }
}
