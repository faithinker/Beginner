// https://developer.apple.com/documentation/foundation/urlrequest
// MIME-Type : https://en.wikipedia.org/wiki/Media_type
// Content-Type Header : https://developer.mozilla.org/ko/docs/Web/HTTP/Headers/Content-Type
// HTTP Request Method : https://developer.mozilla.org/ko/docs/Web/HTTP/Methods
//
// Data Task를 생성할 때 URL을 생성했다. 하지만 이번에는 URL로 데이터를 전달한다.
// URL Request Instance를 만들고 HTTP메소드와 바디 파라미터를 적절한 값으로 설정한다.
// 그다음 URL Request로 데이터 태스크를 선택해야 한다.
import UIKit

struct PostData: Codable {
   let a: Int
   let b: Int
   let op: String
}

class PostReqeustViewController: UIViewController {
   
   @IBOutlet weak var leftField: UITextField!
   @IBOutlet weak var rightField: UITextField!
   @IBOutlet weak var operatorField: UITextField!
    
   let op = ["+","-","*","/"]
   
   override func viewDidLoad() {
        super.viewDidLoad()
        operatorField.tintColor = .clear
        createPickerView()
        dismissPickerView()
        
   }
    
   func encodedData() -> Data? {
      guard let leftStr = leftField.text, let a = Int(leftStr) else {
         showErrorAlert(with: "Please input only the number.")
         return nil
      }
      
      guard let rightStr = rightField.text, let b = Int(rightStr) else {
         showErrorAlert(with: "Please input only the number.")
         return nil
      }
      guard let op = operatorField.text else {
         showErrorAlert(with: "Please input only the operator.")
         return nil
      }
      let data = PostData(a: a, b: b, op: op)
      
      let encoder = JSONEncoder()
      return try? encoder.encode(data)
   }
   
   @IBAction func sendPostRequest(_ sender: Any) {
      guard let url = URL(string: "https://kxcoding-study.azurewebsites.net/api/calc") else {
         fatalError("Invalid URL")
      }
      
      // Code Input Point #1
      var reqeust = URLRequest(url: url)
      reqeust.httpMethod = "POST"
      // Data를 json으로 보낸다고 명시적으로 표기. request 인스턴스에서 컨텐츠 타입 헤더 추가
      reqeust.addValue("application/json", forHTTPHeaderField: "Content-Type")
      //reqeust.setValue("application/json", forHTTPHeaderField: "Content-Type")
      reqeust.httpBody = encodedData()
      // 서버로 전달할 데이터는 http body 태그 안에 있다.
      let task = URLSession.shared.dataTask(with: reqeust) { (data, response, error) in
          if let error = error {
              self.showErrorAlert(with: error.localizedDescription)
              print(error)
              return
          }
          guard let httpResponse = response as? HTTPURLResponse else{
              self.showErrorAlert(with: "Invalid Response")
              return
          }
        guard (200...299).contains(httpResponse.statusCode) else {
            self.showErrorAlert(with: "\(httpResponse.statusCode)")
            return
        }
        // 서버는 하나의 문자열을 리턴. 바이너리데이터를 문자열로 출력
        guard let data = data, let str = String(data: data, encoding: .utf8) else {
              fatalError("Invalid Data")
          }
        self.showInfoAlert(with: str)        
      }
      task.resume()
      // Code Input Point #1
   }
    
    // *******  과제 : 텍스트필드 직접 만들어서 연산자 받기  *********
    func createPickerView() {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        operatorField.inputView = pickerView
    }
    func dismissPickerView() {
            let toolBar = UIToolbar()
            toolBar.sizeToFit()
            let button = UIBarButtonItem(title: "선택", style: .plain, target: self, action: #selector(self.pickdone))
            toolBar.setItems([button], animated: true)
            toolBar.isUserInteractionEnabled = true
            operatorField.inputAccessoryView = toolBar
            toolBar.resignFirstResponder()
    }
    @objc func pickdone() {
        operatorField.resignFirstResponder()
    }
}



extension PostReqeustViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return op.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return op[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        operatorField.text = op[row]
        //pickdone() // 주석하개제하면 피커뷰로 값 넘겨주고 피커뷰가 바로 사라짐
    }
    
    
}
