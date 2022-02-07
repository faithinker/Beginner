// Data를 Import 할 때는 Background에서 실행
// Batch Insert 할 때마다 데이터가 중복됨. 중복을 방지하는 코드를 작성하라
// FetchRequest를 사용하거나 Unique Index를 사용해라

import UIKit
import CoreData

class BatchInsertViewController: UIViewController {
   
   @IBOutlet weak var countLabel: UILabel!
   
   var importCount = 0
   
   @IBAction func batchInsert(_ sender: UIButton) {
      sender.isEnabled = false
      importCount = 0
      
      DispatchQueue.global().async {
         let start = Date().timeIntervalSinceReferenceDate
         
        //JSON을 파싱한다음 배열로 리턴한다.
         let departmentList = DepartmentJSON.parsed()
         let employeeList = EmployeeJSON.parsed()
         
        let context = DataManager.shared.mainContext
        context.performAndWait {
          for dept in departmentList {
            guard let newDeptEntity = DataManager.shared.insertDepartment(from: dept, in: context) else { fatalError() }
            
            // employeeList 배열에서 현재 Department에 속한 데이터만 필터링해서 새로운 상수에 저장한다.
            let employeesInDept = employeeList.filter{ $0.department == dept.id}
            
            for emp in employeeList {
              guard let newEmployeeEntity = DataManager.shared.insertEmployee(from: emp, in: context) else { fatalError() }
              
              //두 엔티티를 연결, 상대 엔티티를 연결한다.
              newDeptEntity.addToEmployees(newEmployeeEntity)
              newEmployeeEntity.department = newDeptEntity
              
              self.importCount += 1
              
              DispatchQueue.main.async {
                self.countLabel.text = "\(self.importCount)"
              }
            }
            //for문 하나씩 돌때마다 저장
            do {
              try context.save()
            } catch {
              print(error.localizedDescription)
            }
          }
          //이 라인에서는 데이터 한번에 저장. 효율적이지 않다. 그룹 100~1000개 나눠서 저장하는것이 효율적이다.
          
          //Dept에 속하지 않는 것 필터링해서 상수에 저장하고 Entity에 추가 -> 저장
          let otherEmployees = employeeList.filter{ $0.department == 0 }
          
          for emp in otherEmployees {
            _ = DataManager.shared.insertEmployee(from: emp, in: context)
            
            self.importCount += 1
            
            DispatchQueue.main.async {
              self.countLabel.text = "\(self.importCount)"
            }
          }
          
          do {
            try context.save()
          } catch {
            print(error.localizedDescription)
          }
        }
        
        //새로운 Department를 추가하고 guard문으로 상수에 바인딩한다.
        
         DispatchQueue.main.async {
            sender.isEnabled = true
            self.countLabel.text = "Done"
            
            let end = Date().timeIntervalSinceReferenceDate
            print(end - start)
         }
      }
   }
}
