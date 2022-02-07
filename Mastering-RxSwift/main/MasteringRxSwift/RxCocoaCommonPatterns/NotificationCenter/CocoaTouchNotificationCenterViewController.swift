// TextView를 터치하면 firstResponder가 된다. keyboardWillShowNotification, keyboardDidShowNotification 순서대로 전달된다.

import UIKit

class CocoaTouchNotificationCenterViewController: UIViewController {
   
   @IBOutlet weak var textView: UITextView!
   
   var tokens = [NSObjectProtocol]()
   
   deinit {
      tokens.forEach { NotificationCenter.default.removeObserver($0) }
   }
   
   @IBAction func toggleKeyboard(_ sender: Any) {
      if textView.isFirstResponder {
         textView.resignFirstResponder()
      } else {
         textView.becomeFirstResponder()
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      var token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillShowNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
         guard let strongSelf = self else { return }
         
         if let frameValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let height = frameValue.cgRectValue.height
            
            var inset = strongSelf.textView.contentInset
            inset.bottom = height
            
            var scrollInset = strongSelf.textView.scrollIndicatorInsets
            scrollInset.bottom = height
            
            UIView.animate(withDuration: 0.3, animations: {
               strongSelf.textView.contentInset = inset
               strongSelf.textView.scrollIndicatorInsets = scrollInset
            })
         }
      })
      tokens.append(token)
      
      token = NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillHideNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
         
         guard let strongSelf = self else { return }
         
         var inset = strongSelf.textView.contentInset
         inset.bottom = 0
         
         var scrollInset = strongSelf.textView.scrollIndicatorInsets
         scrollInset.bottom = 0
         
         UIView.animate(withDuration: 0.3, animations: {
            strongSelf.textView.contentInset = inset
            strongSelf.textView.scrollIndicatorInsets = scrollInset
         })
      })
      tokens.append(token)
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      if textView.isFirstResponder {
         textView.resignFirstResponder()
      }
   }
}
