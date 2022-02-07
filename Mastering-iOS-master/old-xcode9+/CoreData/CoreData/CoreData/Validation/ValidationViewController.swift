// https://developer.apple.com/documentation/coredata/modeling_data/configuring_attributes?language=objc
//
//  https://developer.apple.com/documentation/coredata/nsmanagedobject

// Validation and Error Handling : 데이터 검증과 오류처리
// 코어데이터에서 데이터를 검증하는 방법은 두가지.
// 1. 데이터 모델에서 검증 방식을 설정한다. 허용되는 값의 범위를 설정하거나
// 정규식을 활용해서 패턴을 지정한다.
// 2. 검증 코드를 직접 구현한다.
//  NSManagedObject를 subClassing한다. 관련된 메소드를 재정의하는 방식으로 구현한다. 검증에 사용되는 접두어는 validate~ 형식이다.
//
// Datamodel > Inspector > Attribute : Optional 체크하면 값 저장하지 않아도 된다. 반대로 언체크하면 필수 attribute가 된다.
// Default Value : 기본값 (널값일시 대체)
// Reg. Ex. 검증에 사용할 정규식



import UIKit
import CoreData

class ValidationViewController: UIViewController {

   let departmentList = DataManager.shared.fetchDepartment()
   var selectedDepartment: DepartmentEntity?

   @IBOutlet weak var nameField: UITextField!

   @IBOutlet weak var ageSlider: UISlider!
   @IBOutlet weak var ageValueLabel: UILabel!

   @IBOutlet weak var departmentButton: UIButton!

   var checkValid = false
    
   @IBAction func save(_ sender: Any) {
    //context에서 save 메소드를 호출하면 내부적으로 검증이 실행된다.
    // 저장코드와 오류코드 모두 해봐라.
    
    if checkValid {
        guard let name = nameField.text else { return }
        guard let department = departmentButton.currentTitle else { return }
        let age = Int16(ageSlider.value)
        
        let context = DataManager.shared.mainContext
        let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
        newEmployee.setValue(name, forKey: "name")
        newEmployee.setValue(department, forKey: "department")
        newEmployee.setValue(age, forKey: "age")
        
        DataManager.shared.saveMainContext() // 저장함수
    }else {
        let msg = "Validate를 실행하세요"
        showAlert(message: msg)
    }
    
   }


   @IBAction func validate(_ sender: Any) {
      guard let name = nameField.text else { return }
      let age = Int16(ageSlider.value)
      let context = DataManager.shared.mainContext
    // 입력된 값을 검증하는 코드
      let newEmployee = EmployeeEntity(context: context)
      newEmployee.name = name
      newEmployee.age = age
      newEmployee.department = selectedDepartment

      do {
          try newEmployee.validateForInsert()
          checkValid = true  //valid 여부 확인
      } catch let error as NSError {
        
//          print("Domain ==========")
//          print(error.domain)   //CoreData에서 발생 할 수 있는 오류
//          print("Code ============")
//          print(error.code) //코드 속성에는 오류의 종류를 나타내는 정수
//          print("Description ==========")
//          print(error.localizedDescription) // 오류에 대한 설명 그러나 원인파악 힘듦
//          print("User Info =============")
//          print(error.userInfo) //상세한 정보가 Dic 으로 담김. 오류파악에 도움이 됨
        
        // NSValidationErrorKey 검증에 실패한 Attribute 이름이 저장되어 있다.
        // NSValidationErrorValue 검증에 사용한 값이 저장되어 있다.
        // NSValidationErrorObject 검증에 실패한 객체가 저장되어 있다.
        //  NSValidationStringTooShortError
        //
        // 검증할 Attribute가 두개 이상이라면 userInfo 속성을 통해 Attribute를 확인하고 각각의 오류 처리를 해야 한다.
        switch error.code {
        case NSValidationStringTooShortError, NSValidationStringTooLongError:
            if let attr = error.userInfo[NSValidationKeyErrorKey] as? String, attr == "name" {
                showAlert(message: "Please enter a name between 2 and 30 charcters")
            }
            else {
                showAlert(message: "Please enter a valid value")
            }
        // Shared > EmployeeEntity+CoreDataClass 파일에서 작성한 메소드 실행
        case NSValidationNumberTooLargeError, NSValidationNumberTooSmallError :
            if let msg = error.userInfo[NSLocalizedDescriptionKey] as? String {
                showAlert(message: msg)
            }else {
                showAlert(message: "Please enter a valid value")
            }
//        case NSValidationInvalidAgeAndDepartment:
//            if let msg = error.userInfo[NSLocalizedDescriptionKey] as? String {
//                showAlert(message: msg)
//            }
        default:
            break
        }
        
      }
    
      context.rollback()
   }


   @IBAction func sliderChanged(_ sender: UISlider) {
      ageValueLabel.text = "\(Int(sender.value))"
   }

   @IBAction func selecteDepartment(_ sender: Any) {
      showDepartmentList()
   }

   override func viewDidLoad() {
      super.viewDidLoad()
    // iOS CoreData는 UndoManager 자동 지원 안함 인스턴트 직접 할당
    // Undo 메소드를 통해 작업을 취소하거나  Redo 메소드를 통해 취소된 작업을 다시 실행 할 수 있다.
    // Rollback 메소드를 통해 전체 내용을 버리고 초기상태로 돌아갈 수 있다.
      DataManager.shared.mainContext.undoManager = UndoManager()
   }

   deinit {
      DataManager.shared.mainContext.undoManager = nil
   }
}


extension ValidationViewController {
   func showDepartmentList() {
      let alert = UIAlertController(title: nil, message: "Select Department", preferredStyle: .alert)

      for dept in departmentList {
         let departmentAction = UIAlertAction(title: dept.name, style: .default) { (action) in
            self.selectedDepartment = dept
            self.departmentButton.setTitle(dept.name, for: .normal)
         }
         alert.addAction(departmentAction)
      }

      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
         self.selectedDepartment = nil
         self.departmentButton.setTitle("None", for: .normal)
      }
      alert.addAction(cancelAction)

      present(alert, animated: true, completion: nil)
   }
   
   func showAlert(message: String) {
      let alert = UIAlertController(title: "Validation", message: message, preferredStyle: .alert)
      
      let okAction = UIAlertAction(title: "Ok", style: .cancel) { (action) in
      }
      alert.addAction(okAction)
      
      present(alert, animated: true, completion: nil)
   }
}

// Custom Validation 구현
// Validation Logicd은 Entity에서 구현해야 한다.
// Entity Class를 수동으로 생성
// datamodel > Employee  클릭 > Inspector codegen : Manual None
// Menu > Editor > Create NSManagedObject Subclass : Next Next 저장위치 Next
