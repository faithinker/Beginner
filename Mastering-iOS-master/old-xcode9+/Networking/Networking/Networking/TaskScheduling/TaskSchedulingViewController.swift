// 네트워크 개발은 어렵다.
// Network 단점 : 오류가 발생할 가능성이 높고 디버깅도 어렵다.
// 데이터를 외부로 보내거나 받는다. 네트워크 지연시간, 대역폭, 보안과 같은 다양한 외부 요소들을 고려해야 한다.
// 모바일은 IP주소가 바뀌거나 네트워크 인터페이스가 바뀌는 경우가 많다.
// 결제정보 암호화 및 하이재킹을 금지하도록 구현해야 한다.
//
//
// Neteork Dev GuideLine
// 1. High-Level API 사용
// <-> BSD Socket : LowLevel API 구현 어려움. 프레임워크가 제공하는 보안 사용 X
// 2. 꼭 필요한 데이터만 전송 (네트워크 하드웨어에 부담주기 때문)
// 3. 캐시를 활용, 불필요한 네트워크 요청을 취소하는 기능을 구현해야 한다.
// 4. 비동기 API 사용, 동기방식 할 경우 Background에서 실행. 메인쓰레드 블록 X
// 5. 네트워크 요청을 보낼 때는 (주로)Hostname이나 IP 주소를 쓴다.
// 6. HTTPS 사용 HTTP X. IPV6 사용, IPV4 사용 금지.
// 앱과 연동하는 하드웨어 문제 때문에 반드시 IPV4를 사용해야 한다면,
// 상세 내용 첨부자료를 증빙하면 앱 심사 통과 가능
//
// URLSession Framework
// API Request, File Transfer, Authentication
//
// WebKit Framework
// Display web content, Browser Features, Script Injection
//
// GameKit Framework
// Bluetooth, Wi-Fi LAN Connection, Game Center Integration, Voice Chat
//
// MultipeerConnectivity Framework P2P
// Wi-Fi, Peer-to-Peer Wi-Fi, Bluetooth Personal Area Network
//
// Bonjour  화면공유, 음악스트리밍
// Automatic discovery of devices and services on a local network
//
//  CFNetwork 소켓 통신을 직접 구현 BSD 소켓 사용가능 그러나 권장 X
// Access Network Services. Handle changes in network configurations
//
// Network iOS12 소켓 통신 필요한 API 제공
// Direct access to TLS, TCP and UDP
//
//
// https://developer.apple.com/documentation/foundation/url_loading_system
// https://developer.apple.com/documentation/foundation/urlsession
// https://developer.apple.com/documentation/gamekit
// https://developer.apple.com/documentation/multipeerconnectivity
// https://developer.apple.com/documentation/cfnetwork
// https://developer.apple.com/bonjour/
// https://developer.apple.com/documentation/network
// https://developer.apple.com/documentation/webkit
// https://www.getpostman.com
// https://www.dropbox.com
// https://developer.mozilla.org/ko/docs/Web/HTTP/Methods


import UIKit

class TaskSchedulingViewController: UIViewController {
   @IBOutlet weak var sizeLabel: UILabel!
   
   lazy var formatter: ByteCountFormatter = {
      let f = ByteCountFormatter()
      f.countStyle = .file
      return f
   }()
   
   var task: URLSessionDownloadTask?
   
   lazy var session: URLSession = { [weak self] in
      let config = URLSessionConfiguration.background(withIdentifier: "SampleSession")
      
      // Code Input Point #2
      
      // Code Input Point #2
      
      let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
      return session
   }()
   
   @IBAction func startDownload(_ sender: Any) {
      guard let url = URL(string: bigFileUrlStr) else {
         fatalError("Invalid URL")
      }
      
      task = session.downloadTask(with: url)
      
      // Code Input Point #1
      
      // Code Input Point #1
      
      task?.resume()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      session.invalidateAndCancel()
   }
}


extension TaskSchedulingViewController: URLSessionDownloadDelegate {
   // Code Input Point #3
   
   // Code Input Point #3
   
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
      sizeLabel.text = "\(formatter.string(fromByteCount: totalBytesWritten))/\(formatter.string(fromByteCount: totalBytesExpectedToWrite))"
   }
   
   func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
      print(#function)
      print(error ?? "Done")
   }
   
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
      print(#function)
   }
}
