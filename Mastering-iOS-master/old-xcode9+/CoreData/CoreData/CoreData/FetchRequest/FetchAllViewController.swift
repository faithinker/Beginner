// Fetch : CoreData에서 Data를 읽어오는 작업
// Fetch Request : 읽어올 데이터 종류와 필터링 조건, 정렬 방식 등을 지정하는 객체
// Reques 접미어 : 데이터를 직접 가져오지 않고 CoreData Stack으로 전달한다. Context에게 요청 전달
// Context가 조건에 맞는 데이터를 가져와서 지정된 형식으로 리턴한다.
//
// Fetch Request 생성방법 데이터 정렬, 리턴하는 것이 이번 목표!

import UIKit
import CoreData

class FetchAllViewController: UITableViewController {
   
   var list = [NSManagedObject]()
    
   @IBAction func fetch(_ sender: Any?) {
      let context = DataManager.shared.mainContext
      
//      fetch 생성 4가지 방법. 보통 2번과 3번 방법을 사용한다.
//
//      1. NSFetchRequest를 생성하고 Entity를 속성으로 지정. entity를 직접 생성해야해서 잘 쓰지 않는다.
//       NSManagedObject, NSFetchRequestResultProtocol
//      let request = NSFetchRequest<NSManagedObject>()
//      let entity = NSEntityDescription.entity(forEntityName: "Employee", in: context)
//      request.entity = entity
//
//      2. 생성자로 entity 이름을 전달한다. 엔티티 이름에서 오타 발생 유의
//      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
//
//      3. entity Class가 제공하는 타입 메소드 사용. 형식추론 사용 X. 형식파라미터로 동일한 형식 전달
        let request: NSFetchRequest<EmployeeEntity> = EmployeeEntity.fetchRequest()
        do {
            list = try context.fetch(request) ////  fetchRequst로 요청한 데이터를 배열로 리턴
            tableView.reloadData()
        } catch {
            fatalError(error.localizedDescription)
        }
    
//       4. Stored Fetch Request를 사용한다.
       
      
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      fetch(nil)
   }
}


extension FetchAllViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      cell.textLabel?.text = list[indexPath.row].value(forKey: "name") as? String
      
      return cell
   }
}
