// RxSwift에서 네트워크 요청 처리방법 3가지
// 1.옵저버블을 직접 생성   2. RxCocoa가 제공하는 extension을 사용   3.깃허브에 공개되어 있는 라이브러리 사용 Alamofire, Moya



import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

enum ApiError: Error {
   case badUrl
   case invalidResponse
   case failed(Int)
   case invalidData
}

class RxCocoaURLSessionViewController: UIViewController {
   
    @IBOutlet weak var listTableView: UITableView!

    let list = BehaviorSubject(value: [Book]())


    override func viewDidLoad() {
        super.viewDidLoad()

        list
        .bind(to: listTableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
        cell.textLabel?.text = element.title
        cell.detailTextLabel?.text = element.desc
        }
        .disposed(by: rx.disposeBag)

        fetchBookList()
    }


    /* CocoaTouch Refactoring -> func fetchBookList() {
        let response = Observable<[Book]>.create { observer in
            guard let url = URL(string: booksUrlStr) else {
            observer.onError(ApiError.badUrl)
            return Disposables.create() //s 붙이는거!!
            }

            let session = URLSession.shared

            let task = session.dataTask(with: url) { [weak self] (data, response, error) in
            // 전달된 응답을 검증하고 있다.
                if let error = error {
                    observer.onError(error)
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    observer.onError(ApiError.invalidResponse)
                    return
                }

                guard (200...299).contains(httpResponse.statusCode) else {
                    observer.onError(ApiError.failed(httpResponse.statusCode))
                    return
                }

                guard let data = data else {
                    observer.onError(ApiError.invalidData)
                    return
                }
                // JSONDecoder를 통해 파싱하고 있다.
                do {
                    let decoder = JSONDecoder()
                    let bookList = try decoder.decode(BookList.self, from: data)

                    if bookList.code == 200 { //결과를 속성에 저장하는 것이 아니라 next 이벤트로 방출
                    observer.onNext(bookList.list)
                } else {
                    observer.onNext([])
                }

                    observer.onCompleted()
                } catch {
                    observer.onError(error)
                }
            }
            task.resume()
            // 보통 Dispose 시점에는 현재 실행중인 dataTask를 취소하도록 구현한다.
            return Disposables.create {
                task.cancel()
            }
        }
        .asDriver(onErrorJustReturn: [])
        
        // 옵저버블이 방출하는 데이터는 테이블뷰에 바인딩 된다. Driver로 바꾸면 더 효율적이다.
        response
            .drive(list)
            .disposed(by: rx.disposeBag)
        
        // 시퀀스가 시작하는 시점에 true를 방출하고 response에서 next이벤트를 방출하면 그 값을 false로 바꿔서 방출한다.
        // 방출되는 Boolean값을 isNetworkActivityIndicatorVisible 값과 바인딩하고 있다.
        response
            .map { _ in false }
            .startWith(true)
            .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: rx.disposeBag)
    }  */
    
    func fetchBookList() {
        
        
        
        // 문자열을 방출하는 옵저버블이 data 메소드가 리턴하는 옵저버블로 대체되고 서버에서 전달된 데이터가 데이터 형식으로 전환된다.
        let response = Observable.just(booksUrlStr)
            .map { URL(string: $0)! } // $0.asURL()
            .map { URLRequest(url: $0) }
            .flatMap { URLSession.shared.rx.data(request: $0) }
            .map(BookList.parse(data:)) //parse메소드 : Data를 파라미터로 받아서 JSONDecoder로 파싱한다음 [Book]을 리턴한다.
            .asDriver(onErrorJustReturn: [])
        
        
        // urlrequest Instance를 생성한 다음 바로 데이터 메소드로 전달해도 문제가 없다. map과 flatMap을 사용하지 않아도 되기 때문에 코드가 더 짧아진다.
        // response 메소드와 JSon메소드로 응답을 처리하는 코드도 직접 처리해봐라.
    }
    
    
}

//  ** Pods > RxCocoa > URLSession.swift  **
//
// extension Reactive where Base: URLSession
//
//  public func response(request: URLRequest) -> Observable<(response: HTTPURLResponse, data: Data)>
// URLRequest 인자로 받아 옵저버블을 리턴하고, 옵저버블을 HTTPURLResponse객체와 Data 객체를 튜플에 담아서 방출한다.
//
// Boilerplate code :  최소한의 변경으로 여러곳에서 재사용되며, 반복적으로 비슷한 형태를 띄는 코드
// 구독자를 추가한 다음 응답과 데이터만 처리하면 된다.
//
// data(request: 메소드는 상태 코드를 확인하고 옵저버블을 통해 데이터만 방출한다.
// 응답을 확인하는 Boilerplate code가 작성되어 있어
// 구독자는 데이터만 처리하면 되고 그만큼 코드가 단순해지고 => 가독성, 개발속도 등이 더욱더 빨라진다.
//
// json(request: , options: ) -> Observable<Any>
// 응답에 포함된 데이터를 json으로 직렬화해서 방출하는 옵저버블을 리턴한다.
// 타입파라미터가 Any이지만 실제로는 딕셔너리 형식으로 방출된다. 타입캐스팅이 필요하기때문에 자주 사용하지는 않는다.
//
//
// 응답을 확인할 때 상태코드를 확인하는 것으로 충분하다면 data 메소드를 사용해라.
// 응답을 학인하는 부분을 직접 구현하고 싶다면 response(request:) 메소드를 사용하면 된다.





