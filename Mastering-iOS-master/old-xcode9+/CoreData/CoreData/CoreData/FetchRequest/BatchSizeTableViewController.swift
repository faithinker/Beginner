// XCode Menu Product >> Profile >> Template >> CoreData : Instruments
// fetchBatchSize를 지정하면 부하가 분산되어 더 적은 메모리로 더 빠르게 실행된다.
import UIKit
import CoreData

class BatchSizeTableViewController: UITableViewController {
   
   let context = DataManager.shared.mainContext
   
   var list = [NSManagedObject]()
   
   @IBAction func showType(_ sender: Any) {
      showTypeMenu()
   }
   
   func fetchWithBatchSize() {
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      request.fetchBatchSize = 30
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      do {
         list = try context.fetch(request)
         tableView.reloadData()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   func fetchWithoutBatchSize() {
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      do {
         list = try context.fetch(request)
         tableView.reloadData()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
}


extension BatchSizeTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      cell.textLabel?.text = list[indexPath.row].value(forKey: "name") as? String
      
      return cell
   }
}

extension BatchSizeTableViewController {
   func showTypeMenu() {
      let alert = UIAlertController(title: "Batch Size", message: "Select request type", preferredStyle: .alert)
      
      let menu1 = UIAlertAction(title: "Without Batch Size", style: .default) { (action) in
         self.fetchWithoutBatchSize()
      }
      alert.addAction(menu1)
      
      let menu2 = UIAlertAction(title: "With Batch Size", style: .default) { (action) in
         self.fetchWithBatchSize()
      }
      alert.addAction(menu2)
      
      let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      alert.addAction(cancel)
      
      present(alert, animated: true, completion: nil)
   }
}
