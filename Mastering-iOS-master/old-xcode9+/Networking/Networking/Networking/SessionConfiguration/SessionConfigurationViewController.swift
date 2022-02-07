// https://developer.apple.com/documentation/foundation/urlsessionconfiguration
//
// 네트워크 연결과 관련된 속성을 설정
// 셀룰러 연결 금지, 캐시 저장 위치,  쿠키 설정 바꾸기, 타임아웃 설정
//
// Session Configuration
// URLSession을 구성하기 전에 완료해야한다 URLSession을 생성할 때 생성자로 전달함. 동일한 Configuration을 공유
// URLSession 생성 후에는 SessionConfiguration 변경 불가능
//
// 4가지 기본 Configuration 구현
// 1. SharedSessionConfiguration : SharedURLSession에서 사용. 모든 설정이 시스템 기본값으로 설정되어 있다.
//
// 2. Default SessionConfiguration : 이벤트 처리. 데이터 얻음
// Disk 캐시를 사용하여 서버의 데이터를 캐시에 저장
// 인증정보를 키체인에 저장. 쿠키를 쿠키 저장소에 저장하도록 설정되어있다.
//
// 3. Ephemeral Session Configurtion : Default와 유사 Disk에 어떤 데이터도 저장하지 않는다.
// 인증정보. 서버로 받은 데이터 쿠키 등 메모리 임시 저장. URLSession이 invalid 되는 시점에 삭제됨
// 데이터 유출 가능성이 적다. 프라이빗 브라우징(시크릿모드) 구현시 활용함
//
// 4. Background Session Configuration : 다운로드/업로드 Task에서 사용함
// 앱 실행상태에 관계없이 데이터를 전송할 수 있도록 설정되어 있다. (백그라운드 처리)

import UIKit

class SessionConfigurationViewController: UIViewController {
   
   @IBAction func useSharedConfiguration(_ sender: Any) {
      // Code Input Point #1
    sendReqeust(using: URLSession.shared)
      // Code Input Point #1
   }
   
   @IBAction func useDefaultConfiguration(_ sender: Any) {
      // Code Input Point #2
      let configuration = URLSessionConfiguration.default
      let session = URLSession(configuration: configuration)
      sendReqeust(using: session)
    
      // Code Input Point #2
   }
   
   @IBAction func useEphemeralConfiguration(_ sender: Any) {
      // Code Input Point #3
      let configuration = URLSessionConfiguration.ephemeral
      let session = URLSession(configuration: configuration)
      sendReqeust(using: session)
      // Code Input Point #3
   }
   // 백그라운드핸들러로 urlsession 구현 불가능 delegate 써야함
   @IBAction func useBackgroundConfiguration(_ sender: Any) {
      // Code Input Point #4
      let configuration = URLSessionConfiguration.background(withIdentifier: "DownTask")
      let session = URLSession(configuration: configuration)
      sendReqeust(using: session)
      // Code Input Point #4
   }
   
   @IBAction func useCustomConfiguration(_ sender: Any) {
      // Code Input Point #5
      
      //Task에서 같은 헤더를 추가했다면 이 설정은 무시됨
      let configuration = URLSessionConfiguration.default
    
      configuration.timeoutIntervalForRequest = 30
      configuration.httpAdditionalHeaders = ["ZUMO-API-VERSION" : "2.0.0"]
      configuration.networkServiceType = .responsiveData
    
      let session = URLSession(configuration: configuration)
      sendReqeust(using: session)
    
      // Code Input Point #5
   }
   
   func sendReqeust(using session: URLSession) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string") else {
         fatalError("Invalid URL")
      }
      
      let task = session.dataTask(with: url) { (data, response, error) in
         if let error = error {
            self.showErrorAlert(with: error.localizedDescription)
            print(error)
            return
         }
         
         guard let httpResponse = response as? HTTPURLResponse else {
            self.showErrorAlert(with: "Invalid Response")
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
   }
}
