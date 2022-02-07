
import UIKit
import RxSwift

/*:
 # Sharing Subscription
 */

// 구독 공유를 통해서 불필요한 중복 작업을 피하는 방법



let bag = DisposeBag()



// API 서버에 접속한 다음 전달된 문자열을 방출하는 간단한 옵저버블 구현
let source = Observable<String>.create { observer in
   let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/string")!
   let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let data = data, let html = String(data: data, encoding: .utf8) {
         observer.onNext(html)
      }
      
      observer.onCompleted()
   }
   task.resume()
   
   return Disposables.create {
      task.cancel()
   }
}
.debug()
.share() //추가함



// 옵저버블에 구독자를 추가하면 시퀀스가 시작된다. 옵저버블 코드가 실행되고 서버에서 전달된 문자열이 방출된 다음 종료된다.
source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)
source.subscribe().disposed(by: bag)

// 구독자가 추가되면 새로운 시퀀스를 시작한다.
// 기본적으로 공유하지 않는다.
// 반복되면 클라이언트에서 불필요한 리소스를 낭비하게 된다.
// 네트워크 요청,DB 접근, 파일 읽기 등에 활용 할 수 있다.
// 모든 구독자가 하나의 구독을 공유하도록 한다.




