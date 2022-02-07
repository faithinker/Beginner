

import UIKit

class TextViewController: UIViewController {
   
   var url: URL?
   
   @IBOutlet weak var textView: UITextView!
   
   @IBAction func close(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
    //url에 있는 txt파일을 읽은 다음에 바로 View에 표시
    if let url = url {
        textView.text = try? String(contentsOf: url)
        navigationItem.title = url.lastPathComponent
    }
      
   }
}
