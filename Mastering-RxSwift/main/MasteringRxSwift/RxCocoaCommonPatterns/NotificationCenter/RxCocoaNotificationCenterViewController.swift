// 옵저버 추가 제거가 자동으로 되기 때문에 CocoaTouch에 비해 단순해진다.
import UIKit
import RxSwift
import RxCocoa

class RxCocoaNotificationCenterViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var textView: UITextView!
   
   @IBOutlet weak var toggleButton: UIBarButtonItem!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      toggleButton.rx.tap
         .subscribe(onNext: { [unowned self] in
            if self.textView.isFirstResponder {
               self.textView.resignFirstResponder()
            } else {
               self.textView.becomeFirstResponder()
            }
         })
         .disposed(by: bag)
      
    // willhide Noti도 처리하고 하단 여백도 바꿔야 한다. merge해서 처리한다.
    let willShowObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
        .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height ?? 0} //키보드 높이 리턴
    
    
    let willHideObservable = NotificationCenter.default.rx.notification(UIResponder.keyboardWillHideNotification)
        .map { noti -> CGFloat in 0 }
    
    // 구독자에게 높이값 전달 inset으로 변환해서 전달
    Observable.merge(willShowObservable, willHideObservable)
        .map { [unowned self] height -> UIEdgeInsets in
            var inset = self.textView.contentInset
            inset.bottom = height
            return inset
        }
        .subscribe(onNext: { [weak self] inset in
            UIView.animate(withDuration: 0.3) {
                self?.textView.contentInset = inset
            }
        })
        .disposed(by: bag)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      if textView.isFirstResponder {
         textView.resignFirstResponder()
      }
   }
}
