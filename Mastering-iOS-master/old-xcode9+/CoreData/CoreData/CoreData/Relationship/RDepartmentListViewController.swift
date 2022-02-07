//

import UIKit
import CoreData

class RDepartmentListViewController: UIViewController {
   
   @IBOutlet weak var listTableView: UITableView!
   
   var list = [DepartmentEntity]() //NSManagedObject
   
  //table View에서 선택한 Department를 다음화면으로 전달하는 코드
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let cell = sender as? UITableViewCell, let indexPath = listTableView.indexPath(for: cell) {
         if let vc = segue.destination as? REmployeeListViewController {
            vc.department = list[indexPath.row]
         }
      }
   }   
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      //Department데이터를 List에 저장하고 테이블 뷰를 reload
    list = DataManager.shared.fetchDepartment()
    listTableView.reloadData()
   }
}

extension RDepartmentListViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
    let dept = list[indexPath.row]
    cell.textLabel?.text = dept.name
    cell.textLabel?.text = "\(dept.employees?.count ?? 0)"
      
      return cell
   }
}
