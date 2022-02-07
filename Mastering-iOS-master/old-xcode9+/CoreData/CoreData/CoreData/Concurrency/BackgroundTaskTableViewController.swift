// Background Task 스토리보드 : + 버튼 클릭시 BackgroundContext에서 BatchInsert가 실행됨
// 실행전에 reset 버튼 먼저 수행


import UIKit
import CoreData

class BackgroundTaskTableViewController: UITableViewController {
   
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
   
    // backgroundContext에서 쓰레드를 실행 동일한 쓰레드에서 파라미터로 전달된 코드를 실행
   @IBAction func insertData(_ sender: Any) {
        DataManager.shared.container?.performBackgroundTask({ (context) in
            DataManager.shared.batchInsert(in: context)
        })
   }
// FetchedResultController는 MainContext와 연결되어 있다. 두 Context는 동일한 저장소와 연결되어 있지만
// Context끼리는 연결되어 있지 않다. BacgroundContext에서 데이터를 저장하더라도 메인컨텍스트에 자동으로 반영되지 않는다. 그래서 테이블뷰가 없데이트 되지 않는다. Context는 다른 Context와 독립된 개별 메모리 공간에서 작업을 처리한다.
// 여러 Context를 사용할 때는 동기화가 중요하다. Context는 자신이 관리하고 있는 객체가 업데이트 되거나 Context를 저장할 때마다 Notification을 전달한다. Noti를 활용하여 다른 Context와 동일한 데이터로 업데이트 해야한다.
    
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         try resultController.performFetch()
      } catch {
         print(error.localizedDescription)
      }
      
    token = NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextDidSave, object: nil, queue: OperationQueue.main, using: { (noti) in
        DataManager.shared.mainContext.mergeChanges(fromContextDidSave: noti)
    })
    // NSManagedObjectContextDidSave
    // NSManagedObjectContextWillSave : 저장되기 직전에 저장됨
    // NSManagedObjectContextObjectsDidChange : Context에서 업데이트가 발생될 떄마다 전달된다.
    
    // BackgorundContext를 저장하면 NSManagedObjectContextDidSave가 전달되고 mainContext에 추가된다.
    // FetchedResultController는 새로운 데이터가 추가될 때마다 테이블뷰를 reload한다.
   }
   
   deinit {
      if let token = token {
         NotificationCenter.default.removeObserver(token)
      }
      
      resultController.delegate = nil
   }
}


extension BackgroundTaskTableViewController {
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


extension BackgroundTaskTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
