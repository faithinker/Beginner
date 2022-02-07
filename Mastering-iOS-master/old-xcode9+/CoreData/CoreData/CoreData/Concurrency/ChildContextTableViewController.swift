// Concurrency 부분을 실행 할 때는 항상 Reset 버튼을 눌러라
//
// 두 Context를 연결하지 않은(seperate) 상태에서 backgroundContext를 저장하면 바로 영구저장소에 저장된다.
// 반면 childContext에서 데이터를 저장하면 parentContext로 내용이 전달되고 parentContext를 다시한번 저장해서 영구저장소에 저장해야한다. Context가 여러계층이라면 계층을 따라 올라가면서 모든 Context를 저장해야한다. Parent에서 저장하지 않으면 내용이 사라진다.
//
// context가 저장된 다음에 동기화가 진행된다.

import UIKit
import CoreData

class ChildContextTableViewController: UITableViewController {
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      request.fetchBatchSize = 30
      
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
      }()
   
    // 두 컨텍스트가 연결됨  mainContext(Parent), backgroundcontext(child)
   @IBAction func insertData(_ sender: Any) {
    let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    context.parent = DataManager.shared.mainContext
    
    DataManager.shared.batchInsert(in: context)
   }
// mainQueueConcurrencyType : mainContext를 직접 생성.
// privateQueueConcurrencyType : backgroundcontext를 생성할 때 전달
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         try resultController.performFetch()
      } catch {
         print(error.localizedDescription)
      }
   }
   
   deinit {
      resultController.delegate = nil
   }
}



extension ChildContextTableViewController {
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
      cell.detailTextLabel?.text = target.value(forKey: "address") as? String
      
      if let data = target.value(forKey: "photo") as? Data {
         cell.imageView?.image = UIImage(data: data)
      }
      
      return cell
   }
}


extension ChildContextTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
