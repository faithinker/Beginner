//  https://developer.apple.com/library/archive/documentation/General/Reference/InfoPlistKeyReference/Articles/CocoaKeys.html
// textfield에 FilesOwner 끌어당겨서 delegate 지정
// http 사용하게 하려면 app TransferSecurity 에서 바꿔야 한다.
//
// ATS (App Trasnport Security) : HTTP 거부
// 데이터를 암호화해서 전송하는 HTTPS
//
// Plist > App TransportSecuritySettings > Allow Arbitrary Loads : 모든 http 허용
// Exception Domains > 예외 도메인명 입력 > NSExceptionAllowsInsecureHTTPLoads, NSIncludesSubdomains
// NSTemporaryExceptionAllowsInsecureHTTPLoads
//
//
//
//
//<dict>
//    <key>NSAppTransportSecurity</key>
//    <dict>
//        <key>NSExceptionDomains</key>
//        <dict>
//            <key>induk.ac.kr</key>
//            <dict>
//                <key>NSIncludesSubdomains</key>
//                <true/>
//                <key>NSExceptionAllowsInsecureHTTPLoads</key>
//                <true/>
//            </dict>
//        </dict>
//    </dict>
//<dict>
//
//  ATS Configuration Basics
//NSAppTransportSecurity : Dictionary {
//    NSAllowsArbitraryLoads : Boolean
//    NSAllowsArbitraryLoadsForMedia : Boolean
//    NSAllowsArbitraryLoadsInWebContent : Boolean
//    NSAllowsLocalNetworking : Boolean
//    NSExceptionDomains : Dictionary {
//        <domain-name-string> : Dictionary {
//            NSIncludesSubdomains : Boolean
//            NSExceptionAllowsInsecureHTTPLoads : Boolean
//            NSExceptionMinimumTLSVersion : String
//            NSExceptionRequiresForwardSecrecy : Boolean   // Default value is YES
//            NSRequiresCertificateTransparency : Boolean
//        }
//    }
//}
// ATS 활성화 상태 설정. 보안포기함
// 미디어 연결에 대해 안전하지 않은 연결 허용.
// 단 AVFoundation Framework에 대해 사용해야 하고 미디어 자체가 FairPlay나 HLS를 통해 암호화 되있어야 한다.
//
// WebView에서 HTTP요청을 허용할 때
// LocalNetwork 접속 허용



import UIKit
import WebKit

class WebContentViewController: UIViewController {
   
   @IBOutlet weak var urlField: UITextField!
   @IBOutlet weak var webView: WKWebView!
   
    // WebView는 링크를 타고 이동할 때마다 history를 자동으로 저장한다.
   @IBAction func goBack(_ sender: Any) {
      // Code Input Point #3
      if webView.canGoBack {
            webView.goBack()
      }
      // Code Input Point #3
   }
   
   @IBAction func reload(_ sender: Any) {
      // Code Input Point #5
      webView.reload()
      // Code Input Point #5
   }
   
   @IBAction func goForward(_ sender: Any) {
      // Code Input Point #4
      if webView.canGoForward {
          webView.goForward()
      }
      // Code Input Point #4
   }
   
   func go(to urlStr: String) {
      // Code Input Point #2
      guard let url = URL(string: urlStr) else { fatalError("Invalid URL") }
      let request = URLRequest(url: url)
      webView.load(request)
      // Code Input Point #2
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationItem.largeTitleDisplayMode = .never
      webView.navigationDelegate = self
      
      // Code Input Point #1
      urlField.text = "https://www.apple.com"
      // Code Input Point #1
   }
}

extension WebContentViewController: UITextFieldDelegate {
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      guard let str = textField.text else { return true }
      go(to: str)
      textField.resignFirstResponder()
      return true
   }
}

extension WebContentViewController: WKNavigationDelegate {
   func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
      print(error)
   }
}
