// Data Model에서 FetchRequest를 구성하고 실행해본다.
// Shared > Sample DataModel > Add Entity 1초이상 클릭 (옵션) > Add Fetch Request
//
// + 버튼 Custom Predicate 조건을 지정하는 객체
// department.name BEGINSWITH $deptName
// $를 붙이면 변수명으로 인식
//
// All of the following are true : 조건 위쪽에 조건을 평가하는 메뉴
// All 모두 만족, Any 최소 한개를 만족, None : 모든 조건을 만족시키지 않는 데이터가 나옴 (Not이랑 비슷?)
//
// FetchRequest는 연봉이 8만달러 이상이고 지정된 부서에 속한 직원을 필터링하고 100개의 데이터만 출력
// Department > FetchProperty > Inspector 클릭 : destination predication 설정

import UIKit
import CoreData

class StoredFetchRequestTableViewController: UITableViewController {
   
   var list = [NSManagedObject]()
   
    // NSFetchRequest Instance를 직접 생성 X. DataModel에 선언되어 있는 FetchMethod를 가져온다.
    
   func fetch() {
    guard let model = DataManager.shared.container?.managedObjectModel else {  fatalError("Invalid Model") }
    
    //DataModel에 포함되어 있는 FetchRequest를 이름과 함께 리턴한다.
    
    
//  immutabl(불변) 객체
//    guard let request = model.fetchRequestTemplate(forName: "highSalary") as? NSFetchRequest<NSManagedObject> else { fatalError("Not Found") }
    
    // 모델에서 fetchRequest를 가져와서 속성을 변경하려면  FromTemplate 메소드를 사용해라.
    // substitutionVariables : 대체변수 키-값
    guard let request = model.fetchRequestFromTemplate(withName: "highSalary", substitutionVariables: ["DeptName":"Dev"]) as? NSFetchRequest<NSManagedObject> else { fatalError("Not Found") }
    
    let sortBySalaryASC = NSSortDescriptor(key: #keyPath(EmployeeEntity.salary), ascending: true)
    
    request.sortDescriptors = [sortBySalaryASC]
    
    do {
        list = try DataManager.shared.mainContext.fetch(request)
        tableView.reloadData()
    } catch {
        print(error)
    }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      fetch()
   }
}


extension StoredFetchRequestTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = list[indexPath.row]
      if let name = target.value(forKey: "name") as? String, let deptName = target.value(forKeyPath: "department.name") as? String {
         cell.textLabel?.text = "\(name)\n\(deptName)"
      }
      
      cell.detailTextLabel?.text = "$ \((target.value(forKey: "salary") as? Int) ?? 0)"
      
      return cell
   }
}
