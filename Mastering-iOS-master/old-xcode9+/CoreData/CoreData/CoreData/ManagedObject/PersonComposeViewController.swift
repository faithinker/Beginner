
import UIKit
import CoreData

class PersonComposeViewController: UIViewController {
   
   static let newPersonDidInsert = Notification.Name(rawValue: "newPersonDidInsert")
   
   var target: NSManagedObject? //ManagedObjectVC의 extension 정보는 여기에 담긴다.
  //NSManagedObject 형태라서 업데이트할 때마다 타입 캐스팅이 필요하다.
  //값이 없으면 추가하고 있으면 업데이트한다.
   
   @IBOutlet weak var nameField: UITextField!
   
   @IBOutlet weak var ageField: UITextField!
   
   @IBAction func cancelCompose(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
   
   // 입력된 값을 바인딩하는 코드
   @IBAction func save(_ sender: Any) {
      guard let name = nameField.text else { return }
      
      var age: Int?
      if let ageStr = ageField.text, let ageVal = Int(ageStr) { //String? -> Int 바꾸고 대입
         age = ageVal
      }
      
    // Target이 어떤 흐름을 가져가는지 클래스가 어떻게 변했는지 추적하고 동작방식을 이해해라!
    if let target = target as? PersonEntity {
      DataManager.shared.updatePerson(entity: target, name: name, age: age) {
        NotificationCenter.default.post(name: PersonComposeViewController.newPersonDidInsert, object: nil)
        self.dismiss(animated: true, completion: nil)
      }
    }else {
      // CreatePerson을 호출하고 입력된 값을 전달하는 코드, 분리되있던 Noti를 후행클로저로 만듦
      DataManager.shared.createPerson(name: name, age: age) {
      // Noti를 전달하고 화면을 닫는다.
      NotificationCenter.default.post(name: PersonComposeViewController.newPersonDidInsert, object: nil)
      self.dismiss(animated: true, completion: nil)
      }
    }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      //NavTitle수정
    if let target = target as? PersonEntity {
      navigationItem.title =  "Edit"
      nameField.text = target.name
      ageField.text = "\(target.age)"
    }else {
      navigationItem.title = "Add"
      nameField.text = nil
      ageField.text = nil
    }
   }
}
