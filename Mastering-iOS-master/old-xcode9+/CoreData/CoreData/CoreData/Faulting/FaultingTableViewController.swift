// Faulting and Uniquing 개념설명 2~3번 반복 듣기
//
// https://developer.apple.com/documentation/coredata/nsfetchrequest
// Fault : 잘못, 결점
//
// Faulting  : 메모리를 효율적으로 사용하는 기술
//  저장소에 데이터를 읽어오면 Context에 ManagedObjec로 등록됨
// 이때 등록되는 객체는 Placeholder Object이다. 여기에는 attribute 데이터가 저장되어 있지 않다. (최소한의 정보만 담김)
//  실제 데이터는 rawcat 이라는 특별한 저장소에 저장된다.
//
// Managed Object Fault, Placeholder Object : 아직 Attribute 값을 가져오지 않은 객체
// Fetch Actual Values, Firing Faults : 값을 가져와서 객체를 채우는 것
//
// EmployeeEntity는 Managed Object Fault 상태
// 이 상태에서 name 속성에 접근하면 Fualt가 fire 된다. CoreData는 캐시에서 값을 읽기전에 캐시를 먼저 확인한다.
// 캐시에 필요한 값이 있다면 그 값을 그대로 읽어온다. 나머지 경우에는 저장소에서 값을 가져온다음 객체를 채우고 캐시에 저장한다.
// 저장소에서 값을 가져오는것은 캐시에서 가져오는것보다 훨씬 느리다. 하지만 체감할 정도는 아니다.
// Fault가 Fire되는 과정은 ManagedObject 단위로 실행된다. name 속성 읽는다고 개별적으로 값을 가져오는 것이 아니라
// 해당 엔티티의 전체 데이터를 읽어와서 Managed Object를 채운다.
//
// Fault로 인해 성능이슈가 발생하는 경우는 거의 없다.
// 하지만 짧은시간동안 여러객체에서 개별적으로 Fault가 Fire되면 불필요한 오버헤드가 발생한다.
// 데이터를 읽어오는 시점에 값이 채워진 ManagedObject로 읽어오도록 설정해서 해결한다.
//
// Turning into Faults ManagedObject가 더이상 필요없다면 Fault로 전환해야 한다. 불필요한 메모리가 제거된다.
// 단 Fault 상태로 전환하기전에 저장되지 않은 업데이트가 있는지 확인해야 한다. 그렇지 않으면 데이터 무결성이 훼손된다.
// 항상 내용 저장 -> Fault 과정 거쳐야 한다.
//
// 4분 40초
// Uniquing : 데이터의 무결성을 유지시켜주는 기술
// Uniquing 하나의 Context 내에서 객체를 중복으로 등록하지 않는다.
// 동일한 객체 여러번 읽어와도 Context에는 하나만 등록된다. 하나의 Context에서 동일한 데이터는 한번만 등록된다는 것만 기억하자.
// 데이터 무결성이 훼손되지 않는다. Uniquing은 Context가 알아서 처리하기 때문에 개발자가 신경쓰지 않아도 된다.
//
// CoreData > Profile > Library > CoreData Faults
// cmd + i


// 6분 17초부터
import UIKit
import CoreData

class FaultingTableViewController: UITableViewController {
   
   var list = [NSManagedObject]()
   
   @IBAction func fire(_ sender: Any) {
      // mergeChanges : 객체가 fault 상태로 전환되고 속성을 저장하고 있던 메모리 공간이 해제된다.
      // 더이상 필요없는 객체를 fault상태로 전환하거나 context를 초기화하면 불필요한 메모리 낭비를 줄일 수 있다.
    list.forEach {
      DataManager.shared.mainContext.refresh($0, mergeChanges: false)
    }
   }
   
   func fetchAllEmployee() -> [NSManagedObject] {
      let context = DataManager.shared.mainContext
      var list = [NSManagedObject]()
      
      context.performAndWait {
         let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")

         let sortByName = NSSortDescriptor(key: "name", ascending: true)
         request.sortDescriptors = [sortByName]
         
         request.fetchLimit = 100
        
        // 모든 attribute에 값이 저장되어 있는 객체를 리턴한다.
         request.returnsObjectsAsFaults = false
         
        //employee entity는 모든값이 채워진 상태로 리턴되기 때문에 fault가 발생하지 않는다.
         do {
            list = try context.fetch(request)
         } catch {
            fatalError(error.localizedDescription)
         }
      }
      
      return list
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      list = fetchAllEmployee()
      tableView.reloadData()
   }
}

extension FaultingTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = list[indexPath.row]
      cell.textLabel?.text = target.value(forKey: "name") as? String
      cell.detailTextLabel?.text = target.value(forKeyPath: "department.name") as? String
      
      return cell
   }
}
