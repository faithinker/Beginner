// 어렵다. Secure부분 약 10분? 이후부터
//Secure는 항상 클래스 형식으로 디코딩하고 인코딩해야한다.

// https://developer.apple.com/documentation/foundation/archives_and_serialization
// Archiving과 Serialize
// Decoding : 바이너리 코드를 읽어서 객체를 생성하는 코드
// Encoding : 속성에 저장된 값을 바이너리 형태로 저장함

// 객체를 파일로 저장하고 싶으면 NSObject, NSCoding으로 상속하고 프로토콜을 구현해라
// Struct(구조체)는 swift4에서 도입된 EncodableProtocol, DecodableProtocol 로 구현해라

import UIKit
//취약점 보완
class Language: NSObject, NSCoding, NSSecureCoding {
    static var supportsSecureCoding: Bool {
        return true
    }
    func encode(with coder: NSCoder) { //name과 version이 구조체라 에러남
        coder.encode(name as NSString, forKey: "name") //클래스로 박싱한다.
        coder.encode(version as NSNumber, forKey: "version")
        coder.encode(logo, forKey: "logo")
    }
    
    required init?(coder: NSCoder) { ///기본 Decode방식을 Secure방식으로 전환
        
        //guard let name = coder.decodeObject(forKey: "name") as? String else {return nil}//Any형이라 타입캐스팅 필요
        //self.name = name
        //self.version = coder.decodeDouble(forKey: "version")
        //guard let logo = coder.decodeObject(forKey: "logo") as? UIImage else { return nil }
        //self.logo = logo
        
        
        //첫번째 파라미터 구조체 전달이 안되서 클래스로 구현된 형식(OBJ-C)을 전달해야 한다.
        guard let name = coder.decodeObject(of: NSString.self, forKey: "name") else { return nil }
        self.name = name as String
        guard let version = coder.decodeObject(of: NSNumber.self, forKey: "version") else { return nil }
        self.version = version.doubleValue
        guard let logo = coder.decodeObject(of: UIImage.self, forKey: "logo") else { return nil }
        self.logo = logo
        
        
    }
    
   let name: String
   let version: Double
   let logo: UIImage
   
   init(name: String, version: Double, logo: UIImage) {
      self.name = name
      self.version = version
      self.logo = logo
   }
}


class NSCodingViewController: UIViewController {
   
   @IBOutlet weak var imageView: UIImageView!
   
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var versionLabel: UILabel!
   
   let fileUrl: URL = {
      let documentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
      return documentsDirectory.appendingPathComponent("swift").appendingPathExtension("data")
   }()
   
   //language instance를 파일로 저장
   @IBAction func encodeObject(_ sender: Any) {
    do {
        guard let url = Bundle.main.url(forResource: "swiftlogo", withExtension: "png") else {
            return
        }
        let data = try Data(contentsOf: url)
        guard let img = UIImage(data: data) else { return }
        
        let obj = Language(name: "Swift", version: 5.0, logo: img)
        
        
        //file로 저장
        if #available(iOS 11.0, *) {
            let archiveData = try NSKeyedArchiver.archivedData(withRootObject: obj, requiringSecureCoding: true)
            try archiveData.write(to: fileUrl)
        } else {
            NSKeyedArchiver.archiveRootObject(obj, toFile: fileUrl.path)
        }
        
        
        print("Done")
    } catch {
        print(error)
    }
    
   }
    
   //파일에서 데이터를 읽어온 다음, language instance를 생성하고 이미지뷰와 레이블에 속성을 표시한다.
   @IBAction func decodeObject(_ sender: Any) {
    do {
        let data = try Data(contentsOf: fileUrl)
        var language : Language?
        
        //Secure에서는 디코딩 형식 시점을 명확하게 한다.
        //데이터에 저장된 값을 Language형식으로 Decoding 할 수 있다면 디코딩 될 인스턴스가 리턴되고, 반대로 디코딩 불가능하면
        //에러를 던지고 중지한다. NSCoding에 비해 더 이른 시점에 데이터 형식을 파악하고 형식이 일치하는 경우에만 디코딩을 수행하기 때문에 코드에서 오류가 발생하거나 취약점이 발생할 가능성이 낮아진다.
        
        //파일 읽을때는 NSKeyedUnarchiver 클래스 디코딩이 완료된 객체를 타입캐스팅
        language = NSKeyedUnarchiver.unarchiveObject(with: data) as? Language
        
        if let language = language {
            self.imageView.image = language.logo
            self.nameLabel.text = language.name
            self.versionLabel.text = "\(language.version)"
        }
    } catch {
        print(error)
    }

    
   }
}
