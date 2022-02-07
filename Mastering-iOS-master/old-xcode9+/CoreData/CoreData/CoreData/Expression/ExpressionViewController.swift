// CoreData에서 집계기능을 이용할 때는 Expression을 사용해야 한다.
//
// 포맷 문자열 대신 Class로 검색조건을 지정할 때 쓴다.
// Predicate에 비해 자주 쓰이지는 않지만 높은 성능 제공
// 평균 합계와 같은 집계연산에서 Fetch 연산이 비약적으로 높음
// 코드 양 많고 동작원리 어렵다.
//
//  NSExpressionDescription Class 공부 : 저장소에서 연산한다.
//
//  Predefined Functions : 46, 56Line  forFunction
//  https://developer.apple.com/documentation/foundation/nsexpression/1413747-init
//
//  https://developer.apple.com/documentation/foundation/nsexpression
//  https://developer.apple.com/documentation/coredata/nsexpressiondescription

import UIKit
import CoreData

class ExpressionViewController: UIViewController {
   lazy var formatter: NumberFormatter = {
      let f = NumberFormatter()
      f.locale = Locale(identifier: "en_US")
      f.numberStyle = .currency
      return f
   }()
   
   var list = [Any]()
   
   @IBOutlet weak var listTableView: UITableView!
   
   func fetch() {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Department")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      // resultType은 항상 딕셔너리 타입
      request.resultType = .dictionaryResultType
      
      // NSExpression을 만들고 저장
      
      let employeeCountExprDescription = NSExpressionDescription()
      employeeCountExprDescription.name = "count"
      // forFunction : 약속된 method를 써야한다.
      let countArg = NSExpression(forKeyPath: "employees")
      let countExpr = NSExpression(forFunction: "count:", arguments: [countArg])
      employeeCountExprDescription.expression = countExpr
      employeeCountExprDescription.expressionResultType = .integer64AttributeType
    
      // 평균
      let averageSalaryExprDescription = NSExpressionDescription()
     
      averageSalaryExprDescription.name = "avg"
      
      let salaryAvg = NSExpression(forKeyPath: "employees.salary")
      let salaryExpr = NSExpression(forFunction: "average:", arguments: [salaryAvg])
      averageSalaryExprDescription.expression = salaryExpr
      averageSalaryExprDescription.expressionResultType = .decimalAttributeType
      
      request.propertiesToFetch = ["name", employeeCountExprDescription, averageSalaryExprDescription]
    
      
      
      do {
         list = try DataManager.shared.mainContext.fetch(request)
         listTableView.reloadData()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      fetch()
   }
}


extension ExpressionViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
    // 릴레이션에 포함된 모든 객체를 context로 가져와야 해서 속도가 상대적 느리다.
    // Product > Profile > CoreData > Library > CoreData Faults : 타임라인에 드로그앤 드롭
    // Cache Miss : 캐시에 저장된 데이터가 없어 반복적으로 저장소에 접근하고 있다. 이런회수 증가할수록 성능 떨어짐
    // Faults : 평균에 필요한 데이터를 개별적으로 가지고옴 불필요한 overhead 증가
    // 아래에 표시되는 로그?가 적게 표시되어야 하고 타임라인은 얇게 표시되어야 좋은 성능을 가진 코드이다.
    // Expression을 사용하면 저장소에서 직접계산한다.
      if let target = list[indexPath.row] as? NSManagedObject {
         let count = target.value(forKeyPath: "employees.@count.intValue") as? Int
         let avg = target.value(forKeyPath: "employees.@avg.salary.doubleValue") as? Double
         
         if let name = target.value(forKey: "name") as? String, let count = count {
            cell.textLabel?.text = "\(name)\n\(count) employees"
         }
         
         let avgStr = formatter.string(for: avg ?? 0) ?? "0"
         cell.detailTextLabel?.text = avgStr
      } else if let target = list[indexPath.row] as? [String: Any] {
         let count = target["count"] as? Int
         let avg = target["avg"] as? Double
         
         if let name = target["name"] as? String, let count = count {
            cell.textLabel?.text = "\(name)\n\(count) employees"
         }
         
         let avgStr = formatter.string(for: avg ?? 0) ?? "0"
         cell.detailTextLabel?.text = avgStr
      }
      
      
      return cell
   }
}
