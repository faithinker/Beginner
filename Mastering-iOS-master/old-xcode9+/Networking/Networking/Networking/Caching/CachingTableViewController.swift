// https://developer.apple.com/documentation/foundation/urlcache
// https://developer.apple.com/documentation/foundation/urlrequest
// https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Cache-Control
//
// 네트워크 접속은 고비용의 작업이다. 무선기술을 통해 네트워크에 접속하기 때문에
// 배터리 소모가 빠르다. 요청과 응답사이에 시간차가 존재하고 서버 리소스를 사용한다.
// iOS는 서버에서 다운로드한 데이터를 디스크와 메모리에 저장한다.
// 캐시를 사용하면 불필요한 네트워크 트래픽이 감소하고 배터리 성능이 향상된다. 네트워크 요청에 필요한 시간과 비용도 절약된다.
// URL Loading System이 캐싱에 필요한 모든 Infra를 제공한다.
// 캐시 사용방식 : Cache Policy
// 4가지 캐시정책을 제공한다.
// 1. useProtocolCachePolicy : 프로토콜 특성에 따른 기본 정책을 사용함
// 서버에서 Cache-Control Header를 전달하면 기본값을 그대로 사용한다.
// 2. reloadIgnoringLocalCacheData : 로컬 캐시를 무시한다. 요청을 시작할 때마다 매번 네트워크에 연결한다. 배터리 성능에 영향을 준다. 영구정책 사용을 권장하지 않는다.
// 3. returnCacheDataDontLoad : 서버의 데이터 갖고오지 않고 무조건 캐시에 있는것만 사용한다. 로컬 캐시가 없다면 요청이 실패하기 때문에 캐시를 저장한 후에 사용해야 한다.
// 서버에서 보내는 데이터가 항상 고정되어 있을 때 사용한다.
// 4. returnCacheDataElseLoad : 먼저 캐시가 저장되어 있는지 확인하고 있으면 그대로 사용하고 없으면 네트워크에 연결한다.
//
//
// Server : Cache-Control
// 캐시에 저장된 응답이 10초동안 사용된다. 10초이내 동일한 API를 사용하면 로컬캐시를 사용한다.
// 서버에서 Cache-Control 지정해주면 클라이언트(앱)에서 지정할 필요가 없다.
// 캐시의 장점 : 네트워크 트래픽 감소. 배터리 사용량 감소. 사용자 데이터 사용량 감소. 서버 리소스 절약
//

import UIKit


class CachingTableViewController: UITableViewController {
   
   @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var descLabel: UILabel!
   @IBOutlet weak var lastUpdateDateLabel: UILabel!
   
   var buffer: Data?
   
   var lastDate = Date()
   
   lazy var formatter: ByteCountFormatter = {
      let f = ByteCountFormatter()
      f.countStyle = .file
      return f
   }()
   
   lazy var dateFormatter: DateFormatter = {
      let f = DateFormatter()
      f.dateFormat = "HH:mm:ss.SSS"
      return f
   }()
   
   lazy var session: URLSession = { [weak self] in
      let config = URLSessionConfiguration.default
      
      // Code Input Point #3
      // session configuration 정책은 configuration에 정의되어 있는 requestCachePolicy 속성을 통해 적용한다.
      // 여기에서 설정한 정책은 세션을 통해 생성된 모든 Task에 공통적으로 적용된다.
    //
    // config에서 설정한 정책보다 request에서 설정한 정책이 우선순위가 높다. 99Line
      config.requestCachePolicy = .reloadIgnoringLocalCacheData
      
      // Code Input Point #3
      
      let session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue.main)
      return session
      }()
   
   @IBAction func sendRequestCacheControl(_ sender: Any) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/cache") else {
         fatalError("Invalid URL")
      }
      
      print(#function)
      
      buffer = Data()
      
      var request = URLRequest(url: url)
      
      // Code Input Point #1
      // 캐시 정책을 직접 설정하면 서버에서 전달된 캐시컨트롤을 무시한다.
      // API가 업데이트 되어도 이전 로컬캐시 계속 사용하므로 비추
      // 따라서 캐시 만료기간 설정하고 만료된 캐시를 직접 삭제하는것을 추천한다.
      // request.cachePolicy = .returnCacheDataElseLoad
        request.cachePolicy = .useProtocolCachePolicy
    // 해당 요청에 대해 세션 정책을 무시하고 cacheControl에 지정된 시간만큼 캐시를 유지한다.
      // Code Input Point #1
      
      let task = session.dataTask(with: request)
      task.resume()
   }
   
   @IBAction func sendReqeust(_ sender: Any) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/cache/nocache") else {
         fatalError("Invalid URL")
      }
      
      print(#function)
      
      buffer = Data()
      
      var request = URLRequest(url: url)
      request.cachePolicy = .returnCacheDataElseLoad
      
      // Code Input Point #2
    // 만료된 캐시를 직접 삭제. urlcache Class는 캐시를 삭제하는 다양한 메소드를 제공함
    // 그러나 정상적으로 동작하지 않아 전체캐시메소드를 삭제하는 것 외에는 쓰지 않는다.
    // 그래서 캐시를 직접 삭제하지 않고 캐시 정책을 임시로 바꾸는 트릭을 쓴다.
    if lastDate.timeIntervalSinceNow < -5 {
        request.cachePolicy = .reloadIgnoringLocalCacheData
        lastDate = Date()
    }else {
        request.cachePolicy = .returnCacheDataElseLoad
    }
      // Code Input Point #2
      
      let task = session.dataTask(with: request)      
      task.resume()
   }
   
   @IBAction func removeAllCache(_ sender: Any) {
      // Code Input Point #5
    // 세션이 사용하고 있는 캐시 저장소는 configuration을 통해 접근한다.
    // 전체삭제를 제외한 메소드는 정상적으로 동작하지 않는다.
    // 캐시를 삭제해야 한다면 request에 캐시정책을 바꾸는 트릭을 사용하거나 전체 캐시를 삭제한다.
    session.configuration.urlCache?.removeAllCachedResponses()
      // Code Input Point #5
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      
      session.invalidateAndCancel()
   }
}

extension CachingTableViewController: URLSessionDataDelegate {
   // Code Input Point #4
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, willCacheResponse proposedResponse: CachedURLResponse, completionHandler: @escaping (CachedURLResponse?) -> Void) {
        guard let url = proposedResponse.response.url else {  completionHandler(nil)
            return }
        
        if url.host == "kxcoding-study.azurewebsites.net" {
            completionHandler(proposedResponse)
        } else if url.scheme == "https" {
            let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .allowedInMemoryOnly)
            completionHandler(response)
            //.allowedInMemoryOnly 메모리에 저장 .allowed disk에 저장
        } else {
            let response = CachedURLResponse(response: proposedResponse.response, data: proposedResponse.data, userInfo: proposedResponse.userInfo, storagePolicy: .notAllowed)
            completionHandler(response)
        }
    }
   // Code Input Point #4
   
   func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
      guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
         completionHandler(.cancel)
         return
      }
      
      completionHandler(.allow)
   }
   
   func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
      buffer?.append(data)
   }
   
   func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
      if let error = error {
         showErrorAlert(with: error.localizedDescription)
      } else {
         parse()
      }
   }
}

extension CachingTableViewController {
   func parse() {
      guard let data = buffer else {
         fatalError("Invalid Buffer")
      }

      let decoder = JSONDecoder()

      decoder.dateDecodingStrategy = .custom({ (decoder) -> Date in
         let container = try decoder.singleValueContainer()
         let dateStr = try container.decode(String.self)

         let formatter = ISO8601DateFormatter()
         formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
         return formatter.date(from: dateStr)!
      })

      do {
         let detail = try decoder.decode(BookDetail.self, from: data)

         if detail.code == 200 {
            titleLabel.text = detail.book.title
            descLabel.text = detail.book.desc

            let date = dateFormatter.string(from: Date())
            lastUpdateDateLabel.text = "Last Update\n\(date)"
            tableView.reloadData()
         } else {
            showErrorAlert(with: detail.message ?? "Error")
         }
      } catch {
         showErrorAlert(with: error.localizedDescription)
         print(error)
      }
   }
}

