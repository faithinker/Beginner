// https://developer.apple.com/documentation/foundation/urlsessionuploadtask
// upload : 파일 업로드 completionhandler를 통해 결과를 처리
// upload with progress : 업로드 된 크기를 레이블에 출력하고 진행률을 프로그레스에 반영한다.
//
// 업로드 안됨 Endpoint.swift 설정해줌  NetworkOverview 강의 참고
// Upload Task 강의 참고
//


import UIKit


class UploadTaskViewController: UIViewController {
   
   @IBOutlet weak var sizeLabel: UILabel!
   
   @IBOutlet weak var uploadProgressView: UIProgressView!
   
   lazy var formatter: ByteCountFormatter = {
      let f = ByteCountFormatter()
      f.countStyle = .file
      return f
   }()
   
   var dropboxUploadRequest: URLRequest {
      guard let apiUrl = URL(string: "https://content.dropboxapi.com/2/files/upload") else {
         fatalError("Invalid URL")
      }
      
      var request = URLRequest(url: apiUrl)
      request.httpMethod = "POST"
      request.setValue("Bearer \(dropBoxAccessToken)", forHTTPHeaderField: "Authorization")
      request.setValue("{\"path\": \"/intro.mp4\",\"mode\": \"overwrite\",\"autorename\": true,\"mute\": false,\"strict_conflict\": false}", forHTTPHeaderField: "Dropbox-API-Arg")
      request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
      
      return request
   }
   
   // Code Input Point #2 Upload 진행상태 표시
    var uploadTask: URLSessionUploadTask?
    
    lazy var session: URLSession = { [weak self] in
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
        return session
    }()
   // Code Input Point #2
   
   @IBAction func uploadWithProgress(_ sender: Any) {
      guard let resourceUrl = Bundle.main.url(forResource: "intro", withExtension: "mp4") else {
         fatalError("Invalid Resource")
      }
      
      guard let data = try? Data(contentsOf: resourceUrl) else {
         fatalError("Invalid Data")
      }
      
      uploadProgressView.progress = 0.0
   
      // Code Input Point #3
      uploadTask = session.uploadTask(with: dropboxUploadRequest, from: data)
      uploadTask?.resume()
      // Code Input Point #3
   }
   
   @IBAction func upload(_ sender: Any) {
      guard let resourceUrl = Bundle.main.url(forResource: "intro", withExtension: "mp4") else {
         fatalError("Invalid Resource")
      }
      
      guard let data = try? Data(contentsOf: resourceUrl) else {
         fatalError("Invalid Data")
      }
      
      // Code Input Point #1 단순 업로드
    let task = URLSession.shared.uploadTask(with: dropboxUploadRequest, from: data) { (data, response, error) in // completionHandler는 업로드가 완료된 다음 한번만 호출된다. 전송률 알기 힘들다.
        if let error = error {
            self.showErrorAlert(with: error.localizedDescription)
            return
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            self.showErrorAlert(with: "Invalid response")
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            self.showErrorAlert(with: "\(httpResponse.statusCode)")
            return
        }
        
        guard let data = data, let str = String(data: data, encoding: .utf8) else {
            fatalError("Invalid Data")
        }
        self.showInfoAlert(with: str)
    }
    task.resume()
      // Code Input Point #1
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)

      // Code Input Point #5
    session.invalidateAndCancel()
      // Code Input Point #5
   }
}

// Code Input Point #4


extension UploadTaskViewController: URLSessionTaskDelegate {
    // 데이터가 업로드 되는 동안 반복적으로 호출됨
    // bytesSent : 메소드가 호출되는 시점에 데이터 크기가 전달됨
    // totalBytesSent : 지금까지 전송된 전체크기가 전달됨
    // totalBytesExpectedToSend : 전송 할 전체크기
    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let current = formatter.string(fromByteCount: totalBytesSent)
        let total = formatter.string(fromByteCount: totalBytesExpectedToSend)
        sizeLabel.text = "\(current)\(total)"
        
        uploadProgressView.progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
    }
    // 업로드가 완료되거나 오류 실행시 호출되는 함수
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error ?? "Done") // nil이라면 Done 표시
    }
}
// Code Input Point #4
