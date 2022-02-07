// 성능 하락의 이유
// Predicate가 복잡하거나 최적화 X, 필요이상의 데이터를 읽어옴
// Fault가 필요 이상으로 Fire되면 Overhead 문제 발생
//
// CoreData Debuging 환경세팅
// 1. XCode Scheme : Debugging Log 활성화
// 2. Apple이 제공하는 Instrument 실행
//
// 1번 Scheme(타겟 왼쪽) > Edit Scheme > 왼쪽 Run > Argument  > Add Item  입력 반드시 접두어 "-" 붙인다.
//  SQLDebug UserDefault는 sql저장소와 관련된 다양한 로그를 출력한다.
//  뒤 숫자가 클수록 상세한 로그 출력  1 실행된 명령과 실행시간 출력
// Arguments Passed On Launch
// -com.apple.CoreData.SQLDebug 1
// -com.apple.CoreData.Concurrency 1
//
// Environment Values
// SQL_ENABLE_THREAD_ASSERTIONS  value = 1
// SQLITE_ENABLE_FILE_ASSERITONS value = 1
//
//
// 이 페이지는 적절한 쿼리문(Predicate)을 던져서 성능 최적화를 시킨다.

import UIKit
import CoreData

class PredicateOptimizationTableViewController: UITableViewController {
   
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      // 결과에서 제외되는 숫자가 많은 조건이 앞으로 와야 한다. 문자열 검색은 제일 뒤에 쓰는게 좋다
//      request.predicate = NSPredicate(format: "address LIKE '*NY*' AND name LIKE 'A*' AND salary >= 50000")
    request.predicate = NSPredicate(format: "salary >= 50000 AND name BEGINSWITH 'A' AND address CONTAINS 'NY'")
      
      
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
   }()
   
   
   @IBAction func fetch(_ sender: Any) {
      DataManager.shared.mainContext.reset()
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      do {
         try resultController.performFetch()
         tableView.reloadData()
      } catch {
         print(error.localizedDescription)
      }
   }
}

extension PredicateOptimizationTableViewController {
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
      
      return cell
   }
}


extension PredicateOptimizationTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
