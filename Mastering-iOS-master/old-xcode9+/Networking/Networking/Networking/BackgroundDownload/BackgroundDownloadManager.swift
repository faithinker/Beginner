
import UIKit

class BackgroundDownloadManager: NSObject {
   static let shared = BackgroundDownloadManager()
   private override init() {
      super.init()
   }
   
   static let didWriteDataNotification = Notification.Name(rawValue: "BackgroundDownloadManager.didWriteDataNotification")
   static let totalBytesWrittenKey = "totalBytesWritten"
   static let totalBytesExpectedToWriteKey = "totalBytesExpectedToWrite"
   
   
   var completionHandler: (()->())?
    // 앱 델리게이트로 저장된 completionhandler를 저장하고 파일을 복사한다음 호출하기 위해서 필요한 속성이다.
   
   var targetUrl: URL {
      guard let targetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("backgroundFile.mp4") else {
         fatalError("Invalid File URL")
      }
      
      return targetUrl
   }
   
   lazy var session: URLSession = {
      let config = URLSessionConfiguration.background(withIdentifier: "SampleSession")
      
      let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
      return session
   }()
}

extension BackgroundDownloadManager: URLSessionDownloadDelegate {   
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
      print(totalBytesWritten, totalBytesExpectedToWrite)
      
      // Code Input Point #3
    
    
    let userInfo = [BackgroundDownloadManager.totalBytesWrittenKey: totalBytesWritten, BackgroundDownloadManager.totalBytesExpectedToWriteKey: totalBytesExpectedToWrite]
      NotificationCenter.default.post(name: BackgroundDownloadManager.didWriteDataNotification, object: nil, userInfo: userInfo)
      // Code Input Point #3
   }
   
   func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
      NSLog(">> %@ %@", self, #function)
      print(error ?? "Done")
   }
   
   func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
      NSLog(">> %@ %@", self, #function)
      
      guard (try? location.checkResourceIsReachable()) ?? false else {
         return
      }
      
      do {
         _ = try FileManager.default.replaceItemAt(targetUrl, withItemAt: location)
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   // Code Input Point #2
    // completion Handler를 호출 할 때는 반드시 메인 쓰레드에서 호출해야 한다.
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        NSLog(">> %@ %@", self, #function)
        DispatchQueue.main.async {
            self.completionHandler?()
        }
    }
   // Code Input Point #2
}

// console.app > 필터 : Process 설정,  Network 입력  >> 입력(NSLOG 표시)
// 앱 실행 -> 백그라운드다운로드 화면 -> 다운로드 -> XCode Stop
// appdelegate에서 세션을 생성하고 completionHandler를 싱글톤 객체에 저장
// 싱글톤 객채에서 저장한 delegate 메소드가 호출
// 싱글톤 객체에 저장해둔 completionHandler 호출
