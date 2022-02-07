// 필요이상의 데이터를 읽어오는 경우를 고침
//
// 뉴욕에 사는 직원 중 연봉 상위 10명만을 게시함

import UIKit
import CoreData

class FetchLimitTableViewController: UITableViewController {
   
   lazy var formatter: NumberFormatter = {
      let f = NumberFormatter()
      f.locale = Locale(identifier: "en_US")
      f.numberStyle = .currency
      return f
   }()
   
   var list = [NSManagedObject]()
   
   // SortDescriptor를 사용해서 원하는 순서대로 정렬
   func fetchTop10SalaryInNewYork() {
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortBySalary = NSSortDescriptor(key: "salary", ascending: false)
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortBySalary, sortByName]
      
      request.predicate = NSPredicate(format: "address CONTAINS 'NY'")
      
      //request 갯수 제한
      request.fetchLimit = 10
      
      do {
//         let result = try DataManager.shared.mainContext.fetch(request)
//         list = Array(result[0..<10])
         list = try DataManager.shared.mainContext.fetch(request)
         
         tableView.reloadData()
      } catch {
         print(error.localizedDescription)
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      fetchTop10SalaryInNewYork()
   }
}

extension FetchLimitTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = list[indexPath.row]
      if let name = target.value(forKey: "name") as? String, let salary = target.value(forKey: "salary") as? Double, let str = formatter.string(for: salary) {
         cell.textLabel?.text = "\(name) (\(str))"
      }
      
      cell.detailTextLabel?.text = target.value(forKey: "address") as? String
      
      return cell
   }
}
