// 모든 데이터는 binary로 변경할 수 있다. 데이터 형식에 제한없이 읽어올 수 있다.
// 하지만 변환코드를 직접 작성해야 하기 때문에 불편하다.
//
// CoreData > Entity > Attribute > type : Transformable CoreData가 데이터 변환을 처리한다. 전부 해주지는 않는다.
// value Transformal을 subclassing해서 직접 구현해야 한다.
//
// Inspector > Value Transform : 생성한 클래스
// Custom Class : Contact
// Module : Current Product Module   Global로 하면 access Control 문제가 발생할 수 있다.

import UIKit
import CoreData

class TransformableTableViewController: UITableViewController {
   
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      request.fetchBatchSize = 30
      
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
   
   deinit {
      resultController.delegate = nil
   }
}

extension TransformableTableViewController {
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
      
      if let contactData = target.value(forKey: "contact") as? Data {
         let contact = NSKeyedUnarchiver.unarchiveObject(with: contactData) as! Contact
         cell.detailTextLabel?.text = contact.tel
      } else if let _ = target.value(forKey: "contact") as? Contact {
         cell.detailTextLabel?.text = target.value(forKeyPath: "contact.tel") as? String
      } else {
         cell.detailTextLabel?.text = nil
      }
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      // as! EmployeeEntity 원래 타입캐스팅 안해도 되지만 위에 NSManagedObject로 만들어져 있어서?
      
      // detailText에 값이 있으면 print문 실행. 없으면 새로운 contact 만듦.
      let target = resultController.object(at: indexPath) as! EmployeeEntity
      if let contact = target.contact {
//        let contact = NSKeyedUnarchiver.unarchiveObject(with: contactData) as! Contact
        print(contact.tel, contact.fax, contact.email)
      }else {
//        let newContact = Contact.sample()
//        let data = NSKeyedArchiver.archivedData(withRootObject: newContact)
        target.contact = Contact.sample() //data
        
        DataManager.shared.saveMainContext()
      }
      // 저장된 데이터는 contact instance. data instance를 contact instance로 바꾸는 작업이 필요
   }
}

extension TransformableTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
