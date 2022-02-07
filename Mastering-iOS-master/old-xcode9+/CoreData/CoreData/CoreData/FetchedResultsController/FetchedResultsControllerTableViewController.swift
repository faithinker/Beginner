// 영구 저장소에서 가져온 데이터를 관리하고 화면에 표시한다.
// 두가지 장점.
// 1. 델리게이트를 이용해서 Data Monitoring을 구현하고 업데이트함
// 2. Caching을 사용해서 읽기(read) 능력을 향상시킴
//
//  구현 여부에 따라 3단계로 구분  델리게이트, 캐싱
//  1. 둘다 구현 X fetch 리퀘스트를 통해 가져온 데이터를 관리하는 최소한의 역할만 수행
//  2. 델리만 구현. 모니터링 기능 활성화 fetch request를 통해 가져온데이터가 업데이트 되면 delegate를 통해 알려준다.
//  3. 델리게이트를 구현하고 캐시를 사용하면 데이터를 모니터링하고 영구저장소로부터 가져온 데이터를 캐시에 저장한다.

// load하자마자  section 관련 에러 뜸
// A section returned nil value for section name key path 'department.name'.

import UIKit
import CoreData

class FetchedResultsControllerTableViewController: UITableViewController {
   // fetchRequest가 지연저장속성으로 되어있다. employee를 이름순으로 정렬해서 가져온다.
    // FetchRequest에는 반드시 sortDescriptors가 한개 이상 추가되있어야 한다.
  // 데이터를 정렬하지 않으면 크래시가 발생한다.
  //
  //<NSManagedObject> 형식 파라미터
   lazy var fetchRequest: NSFetchRequest<EmployeeEntity> = {
      let request = NSFetchRequest<EmployeeEntity>(entityName: "Employee")

      //request.predicate = NSPredicate(format: "department != NIL")

    // sectionNameKeyPath를 전달하면 #keyPath의 속성을 기준으로 정렬해야 한다.
      let sortByDeptName = NSSortDescriptor(key: "department.name", ascending: false)
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
    // 부서 정렬 후 이름순으로 정렬
      request.sortDescriptors = [sortByDeptName, sortByName]
      // fetchBatchSize 지정시 메모리 절약 더 빠르게 가져옴
      request.fetchBatchSize = 30

      return request
   }()
   // fetchRequest로 가져온 데이터는 managedObjectContext인 mainContext에 저장된다.
   // sectionNameKeyPath KeyPath를 전달하면 attribute에 동일한 값이 저장된 데이터를 섹션으로 나누어서 저장한다.
  // 그룹핑 된 데이터를 캐시에 저장함. 캐시에 저장된 데이터를 반복적으로 읽으면 읽기 능력이 향상됨
  // 캐시를 읽어야 하는지 패치를 해야하는지는 FetchedResultsController가 알아서 판단함.
  // 캐시는 별도의 파일로 저장되기 때문에 캐시는 앱을 종료해도 유지됨
    lazy var resultController: NSFetchedResultsController<EmployeeEntity> = { [weak self] in
      let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: #keyPath(EmployeeEntity.department.name), cacheName: "CacheByDeptName")
      controller.delegate = self
      return controller
    }()
   @IBAction func showMenu(_ sender: Any) {
      showMenu()
   }
   

    // 순서 : 캐시삭제 -> fetchrequest 수정 -> performfetch 메소드 호출하고 tableview 수동으로 reload
   // NSSortDescriptor를 통해 바꾼다음 performFetch 메소드를 다시 실행해야 한다.
  // 정렬을 연봉에 맞춰서 다시하고 캐시에 저장함. 오류 방지 위해 이전 캐시삭제
   func changeSortOrder() {
    
    NSFetchedResultsController<EmployeeEntity>.deleteCache(withName: resultController.cacheName)
      let sortByDeptName = NSSortDescriptor(key: "department.name", ascending: false)
      let sortBySalary = NSSortDescriptor(key: "salary", ascending: true)
      resultController.fetchRequest.sortDescriptors = [sortByDeptName, sortBySalary]
    
    do {
      try resultController.performFetch()
      tableView.reloadData()
    } catch {
      print(error.localizedDescription)
    }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()

    do { // 생성자로 전달한 fetchrqeust를 통해 데이터를 가져온 다음 instance 내부에 저장
      try resultController.performFetch()
    } catch {
      print(error.localizedDescription)
    }
    // 생성된 캐시는 deleteCache 통해 삭제함. 타입메소드로 구현됨
    // 캐시이름 전달하면 해당 캐시만 삭제됨. nil을 전달하면 모든 캐시가 삭제됨
    // NSFetchedResultsController<EmployeeEntity>.deleteCache(withName: nil)
   }
   
   deinit { // 참조 사이클 문제 방지
    resultController.delegate = nil
   }
  
  
}


extension FetchedResultsControllerTableViewController: NSFetchedResultsControllerDelegate {
  // batch Update Pattern
  // 데이터를 업데이트 하기전에 호출
  func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.beginUpdates()
  }
  
  // 개별 데이터가 업데이트 될때마다 호출
  //Controller DidChange anObject
  // anObject로 업데이트 된 데이터가 전달, type 업데이트 타입 전달 type를 통해 추가삭제수정을 앎
  //
  // tableView 전체를 업데이트 하지 않고 개별 Cell만 업데이트를 진행함
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    switch type {
    case .insert:
      if let insertIndexPath = newIndexPath {
        tableView.insertRows(at: [insertIndexPath], with: .automatic)
      }
    case .move :
      if let originalIndexPath = indexPath, let targetIndexPath = newIndexPath {
        tableView.moveRow(at: originalIndexPath, to: targetIndexPath)
      }
    case .delete:
      if let deleteIndexPath = indexPath {
        tableView.deleteRows(at: [deleteIndexPath], with: .fade)
      }
    case .update:
      if let updateIndexPath = indexPath {
        tableView.reloadRows(at: [updateIndexPath], with: .fade)
      }
    }
  }
  
  // section이 업데이트 될 때마다 호출. type를 통해 어떤작업인지를 구분. insert와 delete만 전달
  func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
    switch type {
    case .insert:
      tableView.insertSections(IndexSet(integer: sectionIndex), with: .automatic)
      //IndexSet(integer: sectionIndex)
    case .delete:
      tableView.deleteSections(IndexSet(integer: sectionIndex), with: .automatic)
    default:
      break
    }
  }
  
  // fetchRequest를 통해 data가 바뀌면 호출된다.
  func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
    tableView.endUpdates()
  }
}


extension FetchedResultsControllerTableViewController {
   override func numberOfSections(in tableView: UITableView) -> Int {
    return resultController.sections?.count ?? 0
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    guard let sections = resultController.sections else { return 0 }
    let sectionInfo = sections[section]
    return sectionInfo.numberOfObjects //section에 저장되어있는 데이터의 수 return
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      // .object(at: 특정 위치에 있는 데이터를 얻을 때 사용
      let target = resultController.object(at: indexPath)
      cell.textLabel?.text = target.name
      cell.detailTextLabel?.text = target.department?.name
      
      return cell
   }
  
  // section에 부서 이름 추가
  override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return resultController.sections?[section].name
  }
  // section 오른쪽에 sectionIndexTitles이 추가됨
  override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
    return resultController.sectionIndexTitles
  }
}


extension FetchedResultsControllerTableViewController {
   func showMenu() {
      let alert = UIAlertController(title: "Fetched Results Controller", message: nil, preferredStyle: .alert)
      
      let addAction = UIAlertAction(title: "Add Employee", style: .default) { (action) in
         let context = DataManager.shared.mainContext
         
         let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employee", into: context)
         newEmployee.setValue("Aaden Smith", forKey: "name")
         newEmployee.setValue(50, forKey: "age")
         
         DataManager.shared.saveMainContext()
      }
      alert.addAction(addAction)
      
      let deleteAction = UIAlertAction(title: "Delete Employee", style: .destructive) { (action) in
         let context = DataManager.shared.mainContext
         
         let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
         request.fetchLimit = 1
         
         let filterByName = NSPredicate(format: "name == %@", "Aaden Smith")
         request.predicate = filterByName
         
         let sortByName = NSSortDescriptor(key: "name", ascending: true)
         request.sortDescriptors = [sortByName]
         
         do {
            if let first = try context.fetch(request).first {
               context.delete(first)
               DataManager.shared.saveMainContext()
            }
         } catch {
            print(error.localizedDescription)
         }
      }
      alert.addAction(deleteAction)
      
      let changeSortOrderAction = UIAlertAction(title: "Change Sort Order", style: .default) { (action) in
         self.changeSortOrder()
      }
      alert.addAction(changeSortOrderAction)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
   }
}
