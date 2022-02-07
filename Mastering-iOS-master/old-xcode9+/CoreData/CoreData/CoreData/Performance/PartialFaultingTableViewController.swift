// employ entity에는 이름을 제외한 다름 데이터도 포함되어 있다.
// context는 Entity를 Faulting 상태로 가져온 다음 필요한 시점에 전체 데이터를 채운다.
// PartialFaulting을 활용하면 특정 attribute만 채워진 상태로 데이터를 가져올 수 있다. 불필요한 메모리가 낭비되지 않는다.
//
// Product > Profile > CoreData  CMD + I
// CoreData Fetches 가져온 데이터 수를 추적 Bar가 얇아야 좋다. 두껍거나 짧은시간 반복해서 표시되면 최적화가 필요
// CoreData Caches 캐시 적중율을 추적
// CoreData Faults Fault가 Fire된 시점을 추적
// Saves 저장에 소요된 시간  Bar가 얇은게 좋다. 작은단위로 쪼개서 바가 얇고 여러번 나타나는게 좋다.
// Allocation 메모리 사용량 추적

import UIKit
import CoreData

class PartialFaultingTableViewController: UITableViewController {
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
    
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
    
      // 데이터를 가져올 때 name 값을 채워서 가져옴
      request.propertiesToFetch = ["name"]
      
    
      
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

extension PartialFaultingTableViewController {
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
      
      return cell
   }
}


extension PartialFaultingTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
