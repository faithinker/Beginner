
import UIKit
import CoreData

class REmployeeListViewController: UIViewController {
   var department: DepartmentEntity? //NSManagedObject?
   var list = [EmployeeEntity]() //[NSManagedObject]
   
   @IBOutlet weak var listTableView: UITableView!
   //Department에 속한 Entity 출력
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let nav = segue.destination as? UINavigationController, let vc = nav.viewControllers.first as? RDepartmentComposerTableViewController {
         vc.department = department
      }
   }
   
   // Scene에 진입할 때마다 업데이트 되도록 viewWillAppear에서 구현
   // department에 Employee 정보 담겨있다. 단 배열이 아닌 Set이기 때문에 배열로 바꾸고 직접 정렬해야한다.
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
    // 배열로 바꾸고 상수에 저장
    guard let employeeList = department?.employees?.allObjects as? [EmployeeEntity] else { return }
    
    list = employeeList.sorted { $0.name! < $1.name!} //사용법 익히자
    listTableView.reloadData()
   }
}

extension REmployeeListViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
    let employee = list[indexPath.row]
    cell.textLabel?.text = employee.name
    //cell.detailTextLabel?.text = employee.address
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      switch editingStyle {
      case .delete:
        //Cell Swipe시 data 삭제 dept,emp 양쪽에서
        guard let dept = department else { fatalError() }
        let employee = list[indexPath.row]
        
        dept.removeFromEmployees(employee)
        employee.department = nil
        //entity-hierarchy-relationship : 29분 30초부터
      default:
         break
      }
   }
}
