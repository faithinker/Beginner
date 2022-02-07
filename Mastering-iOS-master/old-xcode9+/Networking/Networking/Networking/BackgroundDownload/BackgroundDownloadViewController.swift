// 다시 수강 필요
// https://developer.apple.com/documentation/foundation/urlsessiondownloadtask
// https://developer.apple.com/documentation/foundation/urlsessiondownloaddelegate
//
// Download/Upload Task 기본적으로 Foreground 상태에서만 실행한다.
// 오류가 발생하거나 Background로 이동하면 바로 중지된다.
// 중지된 작업을 다시 실행하는것보다 BackgroundSession에서 실행 되도록 한다.
// BackgroundSession은 별도의 프로세스에서 실행되고 데이터 전송을 iOS가 관리한다.
// 그래서 앱이 백그라운드로 전환되거나 완전히 종료된 상태에서도 데이터 전송이 계속 진행된다.
// 데이터 전송이 완료되면 앱에 구현되어있는 Delegate 메소드를 호출한다.
// 파일전송은 BackgroundSession을 구현하는 것이 좋다.
//
// story board 하단 레이블에 생성일자와 크기가 출력
// 별도의 프로세스 debuger Navigator > Disk > Write
// Network : app process 내부에서 실행된 네트워크 task에 관한 정보만 표시된다.
//
// 앱이 Foreground, Background 실행중
// 앱이 다운로드 중에 Crash가 발생해서 Process가 종료되거나 사용자가 앱을 직접 종료한 경우


import UIKit

class BackgroundDownloadViewController: UIViewController {
   
   @IBOutlet weak var sizeLabel: UILabel!
   @IBOutlet weak var recentDownloadLabel: UILabel!
   
   lazy var sizeFormatter: ByteCountFormatter = {
      let f = ByteCountFormatter()
      f.countStyle = .file
      return f
   }()
   
   lazy var dateFormatter: DateFormatter = {
      let f = DateFormatter()
      f.dateFormat = "MM/dd HH:mm:ss.SSS"
      return f
   }()
   
   var token: NSObjectProtocol?
   
   var targetUrl: URL {
//      guard let targetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("backgroundFile.mp4") else {
//         fatalError("Invalid File URL")
//      }
//
//      return targetUrl
        return BackgroundDownloadManager.shared.targetUrl
   }
   
   var task: URLSessionDownloadTask?
   
//   lazy var session: URLSession = { [weak self] in
//      // Code Input Point #1
//
//    let config = URLSessionConfiguration.background(withIdentifier: "SampleSession")
//    // Identifier 앱을 다시 실행 할 때 동일한 세션에 접근하기 위해 필요함
//
//
//      // Code Input Point #1
//// 다른 프로세스에서 동일한 Identifier를 가진 background 세션이 실행되고 있다면
//// 61Line 에서 새로운 URLSession이 생성되지 않고 해당 세션과 연결된다.
//// 반대로 동일한 Identifier를 가진 background 세션이 없다면, 새로운 URLSession이 생성된다.
//      let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
//      return session
//   }()
    
    let session = BackgroundDownloadManager.shared.session
   
   
   @IBAction func startDownload(_ sender: Any) {
      do {
         let hasFile = try targetUrl.checkResourceIsReachable()
         if hasFile {
            try FileManager.default.removeItem(at: targetUrl)
            print("Removed")
         }
      } catch {
         print(error.localizedDescription)
      }
      updateRecentDownload()
      
      guard let url = URL(string: smallFileUrlStr) else {
         fatalError("Invalid URL")
      }
      
      task = session.downloadTask(with: url)
      task?.resume()
   }
   
   @IBAction func stopDownload(_ sender: Any) {
      session.invalidateAndCancel()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // 새로운 session을 읽고 있다. 지연 저장 속성이 초기화된다.
    // 결과적으로 session이 생성되고 viewDidLoad가 delegate로 지정된다.
      _ = session
      updateRecentDownload()
      
      // Code Input Point #4
    token = NotificationCenter.default.addObserver(forName: BackgroundDownloadManager.didWriteDataNotification, object: nil, queue: OperationQueue.main, using: { (noti) in
        guard let userInfo = noti.userInfo else { return }
        guard let downloadedSize = userInfo[BackgroundDownloadManager.totalBytesWrittenKey] as? Int64 else { return }
        guard let totalSize = userInfo[BackgroundDownloadManager.totalBytesExpectedToWriteKey] as? Int64 else { return }
        
    
        
        self.sizeLabel.text = "\(self.sizeFormatter.string(fromByteCount: downloadedSize))/\(self.sizeFormatter.string(fromByteCount: totalSize))"
//        self.recentDownloadLabel.text = "\(self.sizeFormatter.string(fromByteCount: bytesWritten))"
    })
      // Code Input Point #4
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      session.invalidateAndCancel()
      
      if let token = token {
         NotificationCenter.default.removeObserver(token)
      }
   }
}


//extension BackgroundDownloadViewController: URLSessionDownloadDelegate {
//   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
//      sizeLabel.text = "\(sizeFormatter.string(fromByteCount: totalBytesWritten))/\(sizeFormatter.string(fromByteCount: totalBytesExpectedToWrite))"
//   }
//
//   func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
//      NSLog(">> %@ %@", self, #function)
//      print(error ?? "Done")
//   }
//// 다운로드가 완료되면 location 파라미터로 임시파일이 저장되어 있는 URL이 전달된다.
//// 메소드 실행이 완료되면 임시파일이 삭제되기 때문에 컨테이너 내부로 복사해야 한다.
//// 앱이 실행되고 있지 않은 시점에 다운로드가 완료되면 delegate메소드가 호출되지 않는다. 결과적으로 임시파일이 삭제된다.
//// 앱을 실행하면 아래 함수가 다시 실행되지만 이미 이 시점에는 임시파일이 존재하지 않기 때문에 오류가 발생한다.
//// appdelegate.swift handleEventsForBackgroundURLSession 메소드
//   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
//      NSLog(">> %@ %@", self, #function)
//
//      do {
//         _ = try FileManager.default.replaceItemAt(targetUrl, withItemAt: location)
//      } catch {
//         print(error)
//         fatalError(error.localizedDescription)
//      }
//      updateRecentDownload()
//   }
//}


extension BackgroundDownloadViewController {
   func updateRecentDownload() {
      do {
         let hasFile = try targetUrl.checkResourceIsReachable()
         if hasFile {
            let values = try targetUrl.resourceValues(forKeys: [.fileSizeKey, .creationDateKey])
            //targetUrl에 파일이 있으면 사이즈와 생성일자 표기
            if let size = values.fileSize, let date = values.creationDate {
               recentDownloadLabel.text = "\(dateFormatter.string(from: date)) / \(sizeFormatter.string(fromByteCount: Int64(size)))"
            }
         }
      } catch {
         recentDownloadLabel.text = "Not Found / Unknown"
      }
   }
}
