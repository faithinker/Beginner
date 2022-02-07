
import UIKit
import WebKit

class ATSViewController: UIViewController {
   
   @IBOutlet weak var webView: WKWebView!
   
   @IBAction func showMenu(_ sender: UIBarButtonItem) {
      showSiteMenu(sender)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      webView.navigationDelegate = self
   }
}

extension ATSViewController: WKNavigationDelegate {
   func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      print(error)
   }
}

extension ATSViewController {
   func go(to urlStr: String) {
      guard let url = URL(string: urlStr) else {
         return
      }
      
      let request = URLRequest(url: url)
      webView.load(request)
   }
   
   func showSiteMenu(_ sender: UIBarButtonItem) {
      let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
      let apple = UIAlertAction(title: "Apple", style: .default) { (action) in
         self.go(to: "http://www.apple.com")
      }
      menu.addAction(apple)
      
      let daum = UIAlertAction(title: "Daum", style: .default) { (action) in
        self.go(to: "http://www.daum.net")
      }
      menu.addAction(daum)
      
      let daumDic = UIAlertAction(title: "Daum Dictionary", style: .default) { (action) in
        self.go(to: "http://dic.daum.net")
      }
      menu.addAction(daumDic)
      
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      menu.addAction(cancel)
      
      if let pc = menu.popoverPresentationController {
         pc.barButtonItem = sender
      }
      
      present(menu, animated: true, completion: nil)
   }
}
