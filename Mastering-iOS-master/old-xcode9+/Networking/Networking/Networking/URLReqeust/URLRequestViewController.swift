
import UIKit

class URLRequestViewController: UIViewController {
   
   @IBOutlet weak var imageView: UIImageView!
   
   @IBAction func sendRequest(_ sender: Any) {
      imageView.image = nil
      
      // Code Input Point #1
    guard let url = URL(string: picUrlStr) else {
        fatalError("Invalid URL")
    }

// 이 코드가 쓰레기인 이유
//
// 동기 API : 이미지를 다운로드하고 데이터 인스턴스를 초기화 할 때까지 리턴하지 않는다. (버튼이 disable됨)
// 메인쓰레드에서 실행하기 때문에 이 구문 끝날 때까지 블로킹이 걸린다.
//
//    do {
//        let data = try Data(contentsOf: url)
//        imageView.image = UIImage(data: data)
//    } catch {
//        print(error)
//    }
    
    
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
            print(error)
        }else if let data = data {
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
    task.resume()
    
      // Code Input Point #1
   }
}
