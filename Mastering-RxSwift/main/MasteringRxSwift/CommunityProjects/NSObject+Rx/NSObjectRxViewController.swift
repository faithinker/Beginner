// disposeBag 속성을 자동으로 추가해 주는 라이브러리
// 리소스 정리를 위해서 DisposeBag을 생성하는데 클래스마다 이런 작업을 반복해야 하기 때문에 귀찮다.
// NSObject를 상속한 모든 클래스에 disposeBag 속성이 자동으로 추가된다.
// DisposeBag을 생성하는 코드를 직접 작성할 필요가 없고 rx 네임스페이스를 통해 접근 할 수 있다.
//
// UIViewController 역시 NSObject를 상속한 클래스이다.

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class NSObjectRxViewController: UIViewController {

//   let bag = DisposeBag()

   let button = UIButton(type: .system)
   let label = UILabel()

   override func viewDidLoad() {
      super.viewDidLoad()

      Observable.just("Hello")
         .subscribe { print($0) }
        .disposed(by: rx.disposeBag)

      button.rx.tap
         .map { "Hello" }
         .bind(to: label.rx.text)
         .disposed(by: rx.disposeBag)
   }
}

// NSObject를 상속하지 않기 때문에 hasDisposebag disposebag 속성을 추가해준다.
// Rx 네임스페이스를 통해 바로 접근하지 않고 바로 속성이름으로 접근한다.
// class 프로토콜로 선언되어 있다. 구조체에서 채용하는 것은 불가능하다.
class MyClass: HasDisposeBag {
//   let bag = DisposeBag()

   func doSomething() {
      Observable.just("Hello")
      .subscribe { print($0) }
      .disposed(by: disposeBag) //bag
   }
}

