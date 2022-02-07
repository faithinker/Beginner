// https://developer.apple.com/documentation/foundation/urlsessiontask
// https://developer.apple.com/documentation/foundation/urlsessiondatatask
//
// URLLoadingSystem : URL을 통해 Network에 있는 서버와 통신하는 기술이다.
// URLSession : URL 연결을 설정하고 요청과 응답을 처리한다. 4가지 세션타입이 있다.
// 1. shared session : 기본설정 사용 완료핸들러를 통해 최종 결과를 전달받음. 구현 단순 백그라운드 전송 지원 X
// 2. Default Session : 세션을 직접 설정. Delegate를 통해 세부적인 제어 가능 서버로부터 전달된 응답은 (디스크와 메모리 캐시에 저장된다.)
// 3. Default Session과 유사하지만 캐시 쿠키 인증정보를 Disk에 저장하지 않는다. Private Browseing 기능 구현시 사용
// 4. Background Session 백그라운드 전송
// 1번을 제외하고 Session Configuration 객체를 통해 생성한다.
//
// Task : URL session을 통해 전달하는 개별요청이다. 목적에 따라 4가지로 분류됨
// Data Task : API 서버와 통신할 때 적합하다. URL Sessoion에서 사용
// Download/Upload Task : 파일전송 구현. 백그라운드 전송 지원
// Stream Task : 채팅과 같은 TCP에 적합
//
// Task는 suspended 상태로 생성되고 직접 resume 메소드를 호출해야 네트워크 요청이 시작된다.
//
// 서버에서 불러온 데이터를 처리하는 두가지 방법
// 1. Completion Handler : Task가 종료된 시점에 한번만 호출된다. 서버에서 전달된 데이터는 완료 핸들러로 한번에 전달된다.
// 2. Session Handler : Task가 실행되는 동안 다양한 이벤트를 세부적으로 처리해야 할 떄 적합함

import UIKit

class DataTaskTableViewController: UITableViewController {
   
   var list = [Book]() //[Any]
   
   @IBAction func sendRequest(_ sender: Any) {
      let booksUrlStr = "https://kxcoding-study.azurewebsites.net/api/books"
      
      // Code Input Point #1
      guard let url = URL(string: booksUrlStr) else { fatalError("Invalid URL") }
      
      let session = URLSession.shared
    
    
    // dataTask가 생성되고 task 상수에 저장된다. task가 suspended 상태이다.
    // dataTask(with : URL)
    // dataTask(with : URLRequest) : Task별로 cache 정책과 같은 네트워크 설정을 바꿔야 할 때 사용한다.
    // Code Input Point #1
    // Completion Handler로 전달
      let task = session.dataTask(with: url) { (data, response, error) in
        // data : 서버에서 전달된 바이너리 데이터
        // response : 서버 응답에 대한 정보
        if let error = error {
            self.showInfoAlert(with: error.localizedDescription)
        }
        
        // 응답코드 확인 성공코드는 200~299 사이값이다.
        guard let httpResponse = response as? HTTPURLResponse else {
            self.showErrorAlert(with: "Invalid Response")
            return
        }
        guard (200...299).contains(httpResponse.statusCode) else {
            self.showErrorAlert(with: "\(httpResponse.statusCode)")
            return
        }
        
        // 여기까지 실행되면 정상적인 데이터를 받은 것이다.
        guard let data = data else { fatalError("Invalid Data") }
        do {
            let decoder = JSONDecoder()
            // decoder를 받아서 Date로 리턴한다.
            decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
                // 파싱할 날짜 값을 decoder를 통해 가져온다.
                let container = try decoder.singleValueContainer()
                let dateStr = try container.decode(String.self)
                
                let formatter = ISO8601DateFormatter()
                formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
                return formatter.date(from: dateStr)!
            })
            
            let bookList = try decoder.decode(BookList.self, from: data)
            
            if bookList.code == 200 {
                self.list = bookList.list
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } else {
                self.showErrorAlert(with: bookList.message ?? "Error")
            }
        }catch {
            print(error)
            self.showErrorAlert(with: error.localizedDescription)
        }
      }
      task.resume()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let destVC = segue.destination as? BookDetailTableViewController {
         if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
            // Code Input Point #5
            destVC.book = list[indexPath.row]
            
            // Code Input Point #5
         }
      }
   }
}

extension DataTaskTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      // Code Input Point #2 셀에 제목 출력
      let target = list[indexPath.row]
      cell.textLabel?.text = target.title
      // Code Input Point #2
      
      return cell
   }
}
