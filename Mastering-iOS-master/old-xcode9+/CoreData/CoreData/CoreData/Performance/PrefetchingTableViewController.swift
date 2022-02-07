// 전체 직원 데이터 가져옴 그다음 부서데이터 하나씩 가져옴
//
// 마지막 Block 최적화 XCDatamodel > Employee 선택
//
// PartialFaulting으로 name 속성만 가져오면 다른 attribute 메모리 로드 안됨. 하지만 특정시간 때 salary 접근하면
// photo도 같이 로드됨. 근데 photo 안쓸껀데 로드되면 메모리 낭비가 됨
//
// photo attribute를 별도의 엔티티로 분리한 다음 employee entity와 to-One Relationship으로 맺어주면
// employ entity에서 fault가 Fire되더라도 Photo는 메모리에 로드되지 않는다. 릴레이션 접근할 때만 photo가 메모리 로드된다.
// 새로운 데이터 모델을 추가하고 Migration 해야한다. 다음강의에 한다.

import UIKit
import CoreData

class PrefetchingTableViewController: UITableViewController {
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      request.predicate = NSPredicate(format: "department != nil")
      // 처음부터 부서 이름을 가져오면 불필요한 overhead가 발생하지 않음
      request.relationshipKeyPathsForPrefetching = ["department.name"]
    
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
      }()
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         try resultController.performFetch()
      } catch {
         print(error.localizedDescription)
      }
   }
}

extension PrefetchingTableViewController {
   override func numberOfSections(in tableView: UITableView) -> Int {
      return resultController.sections?.count ?? 0
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard let sections = resultController.sections else { return 0 }
      let sectionInfo = sections[section]
      return sectionInfo.numberOfObjects
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = resultController.object(at: indexPath)
      cell.textLabel?.text = target.value(forKey: "name") as? String
      cell.detailTextLabel?.text = target.value(forKeyPath: "department.name") as? String
      
      return cell
   }
}


extension PrefetchingTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
