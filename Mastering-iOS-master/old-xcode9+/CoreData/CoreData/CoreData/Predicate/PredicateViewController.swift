// Data Location : Shared > Sample
//
// Predicate(서술어) - 검색조건을 구성할 때 사용. CoreDta와 Spotlight 에서 사용
// fetch : 데이터를 가져오다.
//
// guard let b = a else { return }
// b를 정의할때, a가 옵셔널이기 때문에 a가 nil이라면 코드를 중지하고 그자리에서 리턴한다
// b를 쓸 수 있다면 옵셔널이 벗겨진 상태이다.



import UIKit
import CoreData

class PredicateViewController: UIViewController {

   var list = [NSManagedObject]()
   
   @IBOutlet weak var listTableView: UITableView!
   
   func searchByName(_ keyword: String?) {
      guard let keyword = keyword else { return }
      // Predicate 포맷문자열은 대소문자 구분하지 않는다. 하지만 키워드(연산자)는 대문자로 작성하고
      // 나머지는 lowercamelCase로 작성하는 것이 관례이다.
      // %@은 두번째 파라미터로 전달된 값으로 지정된 포맷 지정이다.
      // 두번째 파라미터 : 가변인자 파라미터, 포맷지정자를 대체하는 값을 순서대로 전달해야 한다.
      // %@이 두번째 파라미터로 저장된 값으로 대체된다.
      // name attribute에 keyword가 포함된 단어(데이터)만 리턴한다.
      // [c]를 추가하면 문자열 비교에 Case-insensitive
      let predicate = NSPredicate(format: "name CONTAINS[c] %@", keyword)
      fetch(predicate: predicate)
   }
   
   func searchByMinimumAge(_ keyword: String?) {
      guard let keyword = keyword, let age = Int(keyword) else { return }
      // %K는 파라미터로 전달된 어트리뷰트 이름으로 대체된다. %앳을 사용할 경우 어트리뷰트로 인식하지 않기 때문에 무조건 써야한다.
      // % 문자열이나 참조형식에 저장된 값을 대체할 때 사용한다.
      //  %앳을 사용할려면 파라미터로 전달된 숫자를 NSNumber로 Boxing해서 전달해야한다.
      // 숫자를 전달할려면 %d, %i를 사용한다.
    
      let predicate = NSPredicate(format: "%K >= %d", #keyPath(EmployeeEntity.age),age)
      fetch(predicate: predicate)
      
    
      
   }
   
   func searchBySalaryRange(_ keyword: String?) {
      guard let keyword = keyword else { return }
      let comps = keyword.components(separatedBy: "-")
      guard comps.count == 2, let min = Int(comps[0]), let max = Int(comps[1]) else { return }
      // 30000-70000
      // BETWEEN 연산자 : 최소값과 최대값을 전달
      // { } : Swift는 딕셔너리, Predicate에서는 배열이다.
      let predicate = NSPredicate(format: "%K BETWEEN {%d, %d}", #keyPath(EmployeeEntity.salary), min, max)
      fetch(predicate: predicate)
   }
   
   func searchByDeptName(_ keyword: String?) {
      guard let keyword = keyword else { return }
      // BEGINSWITH : 접두어를 비교하는 연산자이다.
    let predicate = NSPredicate(format: "dept BEGINSWITH[c] %@", #keyPath(EmployeeEntity.department.name), keyword)
      fetch(predicate: predicate)
      
   }
   //  NSFetchRequest ->  NSPredicate
   func fetch(predicate: NSPredicate? = nil) {
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
    
    // 영구 저장소에서 만족된 데이터만 읽어온다.
      request.predicate = predicate
    // CoreData와 Realm 의 차이
      
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
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

extension PredicateViewController: UISearchBarDelegate {
   func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.text = nil
      searchBar.resignFirstResponder() //필터링 되지 않은 전체 데이터를 표시
      fetch()
   }
   
   func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      switch searchBar.selectedScopeButtonIndex {
      case 0:
         searchByName(searchBar.text)
      case 1:
         searchByMinimumAge(searchBar.text)
      case 2:
         searchBySalaryRange(searchBar.text)
      case 3:
         searchByDeptName(searchBar.text)
      default:
         fatalError()
      }
   }
}

extension PredicateViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

      let target = list[indexPath.row]
      if let name = target.value(forKey: "name") as? String, let age = target.value(forKey: "age") as? Int, let departmentName = target.value(forKeyPath: "department.name") as? String {
         cell.textLabel?.text = "\(name) (\(age))\n\(departmentName)"
      }
      
      if let salary = target.value(forKey: "salary") as? Int {
         cell.detailTextLabel?.text = "$ \(salary)"
      }
      
      return cell
   }
}
