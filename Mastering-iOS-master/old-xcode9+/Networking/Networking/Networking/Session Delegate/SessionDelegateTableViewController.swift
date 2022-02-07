// 서버에서 전달된 데이터를 처리하는 두가지 방법
// 1. Completion : Task가 완료된 시점에 한번만 호출.
// 모든 데이터가 한번에 전달됨 (인증과 관련된 델리게이트를 제외하고 나머지 메소드는 호출되지 않음)
// 2. SessionDelegate : Task가 실행되는 동안 발생하는 다양한 이벤트를 세부적으로 처리
// 동시에 사용 불가능. 둘 중 하나만 선택


import UIKit

class SessionDelegateTableViewController: UITableViewController {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descLabel: UILabel!
   
   var session: URLSession!
   
   // Code Input Point #3
    var buffer: Data?
   // Code Input Point #3
   
   @IBAction func sendReqeust(_ sender: Any) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/books/3") else {
         fatalError("Invalid URL")
      }
      
      // Code Input Point #1
      let configuration = URLSessionConfiguration.default
      session = URLSession(configuration: configuration, delegate: self, delegateQueue: OperationQueue.main)
      
      buffer = Data()
    
      let task = session.dataTask(with: url)
      task.resume()
      // Code Input Point #1
   }
   
    // URLSession을 직접 생성하고 Delegate를 직접 설정하면 두 객체가 강한 참조로 연결된다.
    // Session을 사용한다음 Resource를 정리해야 한다. 그렇지 않으면 메모리 leak이 발생한다.
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      // Code Input Point #6
      
      session.finishTasksAndInvalidate() // Task 끝날때까지 기다렸다 삭제
      session.invalidateAndCancel() // 모든 리소스를 삭제하고 실행중인 Task 취소
      // Code Input Point #6
   }
}

// Code Input Point #2

extension SessionDelegateTableViewController: URLSessionDataDelegate {
    // 서버로부터 최초로 응답을 받았을떄 호출되는 함수. response 응답정보
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
            completionHandler(.cancel)
            return }
        completionHandler(.allow)
    }
    
    // 서버에서 데이터가 전송될 때마다 반복적으로 호출. 데이터축적 후 파싱
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
    }
    // 전송이 끝난다음 호출
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) { // 오류없이 잘 통과되었다면 error 가 nil 이다.
        if let error = error {
            showErrorAlert(with: error.localizedDescription)
            print(error.localizedDescription)
        }else {
            parse()
        }
    }
}
// Code Input Point #2

extension SessionDelegateTableViewController {
   func parse() {
      // Code Input Point #4
    guard let data = buffer else { fatalError("Invalid Buffer") }
      // Code Input Point #4
      
      let decoder = JSONDecoder()
      
      decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
         let container = try decoder.singleValueContainer()
         let dateStr = try container.decode(String.self)
         
         let formatter = ISO8601DateFormatter()
         formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
         return formatter.date(from: dateStr)!
      })
      
      // Code Input Point #5
    do {
        let detail = try decoder.decode(BookDetail.self, from: data)
        
        if detail.code == 200 {
            titleLabel.text = detail.book.title
            descLabel.text = detail.book.desc
            tableView.reloadData()
        }else {
            showErrorAlert(with: detail.message ?? "Error")
        }
    } catch {
        print(error)
    }
      // Code Input Point #5
   }
}
