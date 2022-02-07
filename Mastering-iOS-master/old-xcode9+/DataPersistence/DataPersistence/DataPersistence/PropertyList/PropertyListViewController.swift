// PropertyList 설정정보를 저장할 때 쓴다. == Info.plist
//NewFile -> iOS>Resources>Property List
//Root는 Array Dictionary 두가지로 제한
//File 우클릭 > Open As > Source Code  XML 형태이다.


import UIKit

///커스텀 형식 저장 구현
struct Development: Codable {
    let language : String
    let os : String
}

class PropertyListViewController: UIViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
   
   @IBAction func loadFromBundle(_ sender: Any) {
    guard let url = Bundle.main.url(forResource: "data", withExtension: "plist")
    else { fatalError("not found") }
    if #available(iOS 11.0, *) { //iOS11이상부터 가능
        //plist 파일의 Root 객체 타입이 Dic인지 Arr인지 파악해라
        if let dict = try? NSDictionary(contentsOf: url, error: ()) {
            print(dict)
        }
    } else { //11미만 버전
        if let dict = NSDictionary(contentsOf: url) {
            print(dict)
        }
        //if let arr = NSArray(contentsOf: <#T##URL#>)
    }
   }
    let fileUrl : URL = {
        let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent("data").appendingPathExtension("plist")
    }()
   @IBAction func loadFromDocuments(_ sender: Any) {
    do {
        let data = try Data(contentsOf: fileUrl)
        let decoder = PropertyListDecoder()
        let dict = try decoder.decode(Development.self, from: data)
        //[String : String].self
    } catch {
        print(error)
    }
   }
   
   @IBAction func saveToDocuments(_ sender: Any) {
    do {
        //let dict  = ["language" : "Swift", "os" : "iOS"]
        let dev = Development(language: "Swift", os: "iOS")
        let encoder = PropertyListEncoder()
        let data = try encoder.encode(dev)
        try data.write(to: fileUrl)
        print("Done")
    } catch {
        print(error)
    }
       }
}
