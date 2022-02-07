// 구조체와 클래스 모두 지원, JSON 파싱에서도 자주 사용한다.
// 기본구현을 제공하기 때문에 코드가 단순해진다.
//. https://devmjun.github.io/archive/NSCoding
import UIKit

//class CodableLanguage: NSSecureCoding {
//    static var supportsSecureCoding: Bool {
//        return true
//    }
//
//    func encode(with coder: NSCoder) {
//        coder.encode(name)
//    }
//
//    required init?(coder: NSCoder) {
//        <#code#>
//    }
//
//
//}

struct CodableLanguage: Codable { //대부분의 기본형식들이 Codable을 채용하고 있어서 멤버 구현을 생략할 수 있다.
   let name: String
   let version: Double
   let logo: Data
}


class CodableViewController: UIViewController {
   
   @IBOutlet weak var imageView: UIImageView!
   
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var versionLabel: UILabel!
   
   let fileUrl: URL = {
      let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
      return documentsDirectory.appendingPathComponent("ios").appendingPathExtension("data")
   }()
   
   @IBAction func encodeObject(_ sender: Any) {
      do {
         guard let url = Bundle.main.url(forResource: "ioslogo", withExtension: "png") else {
            return
         }
         
         let data = try Data(contentsOf: url)
         
         let obj = CodableLanguage(name: "iOS", version: 12.0, logo: data)
         
        let archiver: NSKeyedArchiver
        
        if #available(iOS 11.0, *) {
            archiver = NSKeyedArchiver(requiringSecureCoding: false)
        } else {
            archiver = NSKeyedArchiver()
            archiver.requiresSecureCoding = false
        }
         //instance encoding
        try archiver.encodeEncodable(obj, forKey: NSKeyedArchiveRootObjectKey)
        try archiver.encodedData.write(to: fileUrl)
        
        archiver.finishEncoding()
        print("Done")
      } catch {
         print(error)
      }
   }
   
   
   @IBAction func decodeObject(_ sender: Any) {
      do {
         let data = try Data(contentsOf: fileUrl)
         
         var language: CodableLanguage?
         
        let unarchiver: NSKeyedUnarchiver
        
        if #available(iOS 11.0, *) {
            unarchiver = try NSKeyedUnarchiver(forReadingFrom: data)
        }else {
            unarchiver = try NSKeyedUnarchiver(forReadingWith: data)
        }
         
        unarchiver.requiresSecureCoding = false
        //instance에 저장되어있는 데이터를 디코딩한다.
        language = unarchiver.decodeDecodable(CodableLanguage.self, forKey: NSKeyedArchiveRootObjectKey)
        
        unarchiver.finishDecoding()
        
         if let language = language {
            self.imageView.image = UIImage(data: language.logo)
            self.nameLabel.text = language.name
            self.versionLabel.text = "\(language.version)"
         }
      } catch {
         print(error)
      }
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
}
