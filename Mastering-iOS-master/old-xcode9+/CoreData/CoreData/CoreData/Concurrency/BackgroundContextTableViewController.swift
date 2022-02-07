// BackgroundTask와 BackgroundContext 방식은 개별적인 저장방식이다.
// Context에서 저장한 내용이 다른 Context로 전달되지 않는다. 그래서 항상 Noti를 활용하여 Merge 한다.
// Context를 생성한다음 두 Context를 Parent와 Child로 연결하면 두 Context에 저장된다.



import UIKit
import CoreData

class BackgroundContextTableViewController: UITableViewController {
   var token: NSObjectProtocol!
   
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      request.fetchBatchSize = 30
      
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
      }()
   
   @IBAction func insertData(_ sender: Any) {
    let context = DataManager.shared.backgroundContext
    DataManager.shared.batchInsert(in: context)
    
    
    // .performAndWait : 파라미터로 전달한 코드가 모두 실행될 때까지 대기
    // backgournd 메소드를 쓸 때는 항상 do 메소드를 사용한다.
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         try resultController.performFetch()
      } catch {
         print(error.localizedDescription)
      }
      // Noti로 전달된 데이터를 maincontext에 추가한다.
      token = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, queue: OperationQueue.main) { (noti) in
         DataManager.shared.mainContext.mergeChanges(fromContextDidSave: noti)
      }
   }
   
   deinit {
      if let token = token {
         NotificationCenter.default.removeObserver(token)
      }
      
      resultController.delegate = nil
   }

}


extension BackgroundContextTableViewController {
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


extension BackgroundContextTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
