// https://developer.apple.com/documentation/foundation/urlsessiondownloadtask
// https://developer.apple.com/documentation/foundation/urlsessiondownloaddelegate
//
// DataTask는 메모리에 저장(휘발성) 큰데이터 다운로드에는 적합하지 않다.
// 10mb 이상은 DownloadTask를 써라. 데이터를 파일로 저장한다. "사용가능한 저장공간" 확인 필요
//
// 파일 저장과정
// 1. 파일은 OS가 관리하는 임시폴더로 다운로드 된다.
// 2. 다운로드가 완료되면 delegate를 통해 URL로 전달된다.
// 3. URL에 접근해서 임시파일을 필요한 위치로 복사 시킨다.
//
// Stop Pause, Resume 기능이 필요한 이유
// WiFi -> 데이터 끊김 -> LTE -> WIFI -> 데이터 끊김
// 사용자 임의 취소
//
// Debug Navigator > Network
//
// 앱이 홈화면 이동하면 업/다운로드 모두 중지됨. 기본적으로 백그라운드 전송 지원 X
// 앱을 다시 실행하면 전송이 될수도 있고 아닐수도 있다.
// iOS가 앱을 강제로 종료하거나 크래시 나면 진행중인 업/다운로드가 모두 사라진다.
// 취소기능과 백그라운드 기능을 모두 활성화하자


import UIKit
import AVKit

class DownloadTaskViewController: UIViewController {
   
   @IBOutlet weak var sizeLabel: UILabel!
   
   @IBOutlet weak var downloadProgressView: UIProgressView!
   
   lazy var formatter: ByteCountFormatter = {
      let f = ByteCountFormatter()
      f.countStyle = .file
      return f
   }()
    
    // 다운로드테스크는 파일이 파일시스템으로 다운로드 된다. (데이터 테스크와 다르다.)
   var targetUrl: URL {
      guard let targetUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("downloadedFile.mp4") else {
         fatalError("Invalid File URL")
      }
      
      return targetUrl
   }
   
   // Code Input Point #1
    var task: URLSessionDownloadTask?
    
    lazy var session: URLSession = { [weak self] in
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
   // Code Input Point #1
   
   @IBAction func startDownload(_ sender: Any) {
      do {
         let hasFile = try targetUrl.checkResourceIsReachable()
         if hasFile { //실제 앱애서는 이렇게 구현 X. 사용자에게 덮어쓰기 여부 물어보고 처리함
            try FileManager.default.removeItem(at: targetUrl)
         }
      } catch {
         print(error)
      }
      
      guard let url = URL(string: smallFileUrlStr) else { // 나중에서 수정
         fatalError("Invalid URL")
      }
      
      downloadProgressView.progress = 0.0
      
      // Code Input Point #2
      task = session.downloadTask(with: url)
      task?.resume()
      
      // Code Input Point #2
   }
   
   @IBAction func stopDownload(_ sender: Any) {
      // Code Input Point #4
      task?.cancel() // 다운로드 취소하고 임시파일 삭제
      downloadProgressView.progress = 0.0
      sizeLabel.text = "- MB/ - MB"
      // Code Input Point #4
   }
   
   
   // Code Input Point #5
    var resumeData: Data? //임시 데이터
   // Code Input Point #5
   
   @IBAction func pauseDownload(_ sender: Any) {
      // Code Input Point #6
    
    task?.cancel(byProducingResumeData: { (data) in
        self.resumeData = data
         
    })

      // Code Input Point #6
   }
   
   @IBAction func resumeDownload(_ sender: Any) {
      // Code Input Point #7
      guard let data = resumeData else { return }
    
      //resumeData에는 URL과 다운로드 된 데이터가 모두 저장되어 있기 때문에 다운로드할 URL을 다시 지정할 필요는 없다.
      task = session.downloadTask(withResumeData: data)
      task?.resume()
      // Code Input Point #7
   }
   
   override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
      return (try? targetUrl.checkResourceIsReachable()) ?? false
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let playerVC = segue.destination as? AVPlayerViewController {
         let player = AVPlayer(url: targetUrl)
         playerVC.player = player
         playerVC.navigationItem.title = "Play"
      }
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      // Code Input Point #8  // 세션 invalidate
      session.invalidateAndCancel()
      // Code Input Point #8
   }
}

// Code Input Point #3

// 다운로드가 끝나면 이 순서대로 함수가 실행된다.
//urlSession(_:downloadTask:didFinishDownloadingTo:)
//urlSession(_:task:didCompleteWithError:)

// 다운로드 재개하면... 이 순서대로 호출됨
// urlSession(_:downloadTask:didResumeAtOffset:)
// urlSession(_:dowloadTask:didWriteData:)
// urlSession(_:downloadTask:didFinishDownloadingTo:)
// urlSession(_:task:didCompleteWithError:)

extension DownloadTaskViewController: URLSessionDownloadDelegate {
    
    // Dowload가 진행되는동안 반복적으로 호출
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let current = formatter.string(fromByteCount: totalBytesWritten)
        let total = formatter.string(fromByteCount: totalBytesExpectedToWrite)
        sizeLabel.text = "\(current)/\(total)"
        downloadProgressView.progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) { // fileOffset : 다운로드를 다시 시작하는 위치
//        let current = formatter.string(fromByteCount: fileOffset)
//        let total = formatter.string(fromByteCount: expectedTotalBytes)
//        sizeLabel.text = "\(current)/\(total)"
//        downloadProgressView.progress = Float(fileOffset) / Float(expectedTotalBytes)
        
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(#function)
        print(error ?? "Done")
        

    }

    // 다운로드가 완료된 파일.  메소드 -> 앱컨테이너로 파일 복사

    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print(#function)
        
        guard (try? location.checkResourceIsReachable()) ?? false else { return }
        
        // 타깃 URL에 동일한 파일이 있는지 확인하고 있으면 덮어 쓰기를 함
        do {
            _ = try FileManager.default.replaceItemAt(targetUrl, withItemAt: location)
        } catch {
            print(error)
        }
    }
}

// Code Input Point #3
