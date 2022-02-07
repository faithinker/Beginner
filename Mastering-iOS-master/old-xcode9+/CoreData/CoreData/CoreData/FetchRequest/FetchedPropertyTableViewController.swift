
import UIKit
import CoreData

class FetchedPropertyTableViewController: UITableViewController {
   var list = [NSManagedObject]()
   
   func fetch() {
      let request = NSFetchRequest<NSManagedObject>(entityName: "Department")
      request.fetchLimit = 1

      let sortByName = NSSortDescriptor(key: "name", ascending: true)

      request.sortDescriptors = [sortByName]
      
    if let model = DataManager.shared.container?.managedObjectModel, let entity = model.entitiesByName["Department"], let property = entity.propertiesByName["lowSalary"] as? NSFetchedPropertyDescription, let fetchRequest = property.fetchRequest {
        let sortBySalary = NSSortDescriptor(key: #keyPath(EmployeeEntity.salary), ascending: true)
        fetchRequest.sortDescriptors = [sortBySalary]
    }
    
      do {
         if let first = try DataManager.shared.mainContext.fetch(request).first as? DepartmentEntity {
            navigationItem.title = first.name
            
            // 저장하고 형변환
            list = first.value(forKey: "lowSalary") as! [NSManagedObject]
         }
         tableView.reloadData()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      fetch()
   }
}


extension FetchedPropertyTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = list[indexPath.row]
      if let name = target.value(forKey: "name") as? String, let deptName = target.value(forKeyPath: "department.name") as? String {
         cell.textLabel?.text = "\(name)\n\(deptName)"
      }
      
      cell.detailTextLabel?.text = "$ \((target.value(forKey: "salary") as? Int) ?? 0)"
      
      return cell
   }
}
