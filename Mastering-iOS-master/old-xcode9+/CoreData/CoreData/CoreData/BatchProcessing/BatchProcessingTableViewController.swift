// 데이터 추가하는 작업 앱 설치후 최초 한번만 하면 된다.
//
// CoreData에서 실행되는 작업은 대부분 Context를 통해 실행된다.
// 새로운 데이터를 저장 할 떄는 Context에서 새로운 객체를 생성한 다음 저장을 요청함
// 데이터를 편집 할 때는 FetchRequest를 통해 원하는 데이터를 읽어온 다음 Context에 등록한다.
// 그다음 Attribute를 원하는 값으로 입력한 다음 저장을 요청한다. 삭제도 비슷하다.
// 이런 방식은 처리해야할 데이터의 갯수가 증가할수록 처리 시간과 메모리 사용량이 증가한다.
//
// Batch Update, Batch Delete : 대량의 데이터를 효율적으로 처리함
// 두 방식은 Context를 거치지 않고 영구 저장소에 바로 접근해서 작업을 실행한다.
// 그런다음 Context로 데이터를 가져온 다음 다시 영구 저장소에 저장하는 과정이 필요없다.
// 결과적으로 적은 메모리로 대량의 데이터를 빠르게 처리한다. 반면 Validation을 지원하지 않기 때문에 데이터의 일관성을 훼손하지 않도록 주의해야 한다.
// 작업 결과가 Context에 반영도지 않는다는 단점이 있다.
// iOS 메일 앱 > 메뷰 깃발, 읽지 않음표시 : Batch Update로 구현

import UIKit
import CoreData

class BatchProcessingTableViewController: UITableViewController {
   
   lazy var formatter: DateFormatter = {
      let f = DateFormatter()
      f.dateStyle = .medium
      f.timeStyle = .short
      f.locale = Locale(identifier: "en_US")
      return f
   }()
   
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Task")
      
      let sortByName = NSSortDescriptor(key: "date", ascending: true)
      request.sortDescriptors = [sortByName]
      
      request.fetchBatchSize = 30
      
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
      }()
   
   @IBAction func showMenu(_ sender: Any) {
      showMenu()
   }
   
    // batchUpdate batchDelete는 영구저장소에 바로 접근하기 때문에 결과를 Context에 반영하지 않는다.
    // Fetched Result Controller를 호출한 다음에 delete 메소드가 호출되지 않는다.
    // 따라서 개발자가 직접 화면을 업데이트해야 한다.
   func batchInsert() {
     DataManager.shared.batchInsert()
   }
   
   func batchUpdate() {
      DataManager.shared.batchUpdate()
      
    do {
        try self.resultController.performFetch()
        
        if let list = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: list, with: .automatic)
        }
    } catch {
        print(error.localizedDescription)
    }
   }
   
   func batchDelete() {
    DataManager.shared.batchDelete()
    do {
        try self.resultController.performFetch()
        
        tableView.reloadData()
    } catch {
        print(error.localizedDescription)
    }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         try resultController.performFetch()
      } catch {
         print(error.localizedDescription)
      }
   }
}

extension BatchProcessingTableViewController {
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
      cell.textLabel?.text = target.value(forKey: "task") as? String
      cell.detailTextLabel?.text = formatter.string(for: target.value(forKey: "date") as? Date)
      
      if let done = target.value(forKey: "done") as? Bool {
         cell.accessoryType = done ? .checkmark : .none
      }
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: false)
      
      let target = resultController.object(at: indexPath)
      if let done = target.value(forKey: "done") as? Bool {
         target.setValue(!done, forKey: "done")
      }
   }
}


extension BatchProcessingTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}


extension BatchProcessingTableViewController {
   func showMenu() {
      let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
      
      let insertAction = UIAlertAction(title: "Batch Insert", style: .default) { (action) in
         self.batchInsert()
      }
      menu.addAction(insertAction)
      
      let updateAction = UIAlertAction(title: "Batch Update", style: .default) { (action) in
         self.batchUpdate()
      }
      menu.addAction(updateAction)
      
      let deleteAction = UIAlertAction(title: "Batch Delete", style: .destructive) { (action) in
         self.batchDelete()
      }
      menu.addAction(deleteAction)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      menu.addAction(cancelAction)
      
      if let pc = menu.popoverPresentationController, let btn = navigationItem.rightBarButtonItem {
         pc.barButtonItem = btn
         pc.sourceView = view
      }
      
      present(menu, animated: true, completion: nil)
   }
}
