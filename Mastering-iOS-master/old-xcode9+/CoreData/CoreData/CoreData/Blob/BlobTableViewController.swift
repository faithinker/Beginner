//    - Binary Data Attribute
//    - External Storage 옵션
//    - 성능 이슈
//
//  CoreData에서 사진 오디오과 같은 큰 데이터를 저장하는 방법
//  영구 저장소에 바이너리 데이터를 직접 저장하는 방법을 공부합니다.
//  BLOB : Binary Large Object  사진 오디오
//  Atomic Store : 전체 데이터를 메모리에 로딩한다. BLOB 효율적 처리 못함
//  Non-Atomic Store : BLOB 저장할 때 쓰임
//  SQLite : Non-Atomic Store 저장소이다. 최대 100GB 데이터 처리, 개별 데이터 최대 크기는 1GB 이하
// 구현 방식에 따라 성능에 영향을 준다. 모든 BLOB을 Entity에 저장하지 않는다. BLOB을 직접 저장하면 데이터를 읽는 과정이
// 단순해진다. MB 데이터부터는 최적화와 디버깅에 필요한 시간이 증가된다.
// 어떤 방식이 개발하고 있는 앱에 적합한 방식인지 잘 파악해야 한다.
//
// 가장 좋은 방법은 BLOB을 파일로 저장하고 파일경로를 Entity에 저장한다.
// 비록 경로를 읽어와서 파일을 직접 로딩하는 과정이 번거롭지만 성능 하락 문제를 피할 수 있다.
//
// BLOB을 엔티티에 저장한다면, 별도의 entity에 저장하고 to-one Relationship 으로 저장하는 방식이 효율적이다.
// 이전시간에 공부한 Faulting을 이용하여 데이터가 실제로 로드되는 시점을 제어할 수 있다.
//
//  Sample Datamodel>  Employee>photo 클릭 > Inspector : Options 체크하면 Allows External Storage 성능에 영향을 줄 수 있는 큰데이터를 별도로 파일로 저장한다. 파일을 저장하고 읽어오는 부분은 자동으로 처리한다. 항상 이 옵션 사용을 권장한다.


// 이 화면은 직접 저정한다.
import UIKit
import CoreData

class BlobTableViewController: UITableViewController {
   
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      request.predicate = NSPredicate(format: "%K == %@", "department.name", "Development")      
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      request.fetchLimit = 50
      
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
      }()
    
   // Asset에 있는 아바타 이미지 저장
   @IBAction func insertPhotoData(_ sender: Any) {
      if let list = resultController.fetchedObjects {
         for (index, data) in list.enumerated() {
            let name = "avatar\(index + 1)"
            guard let img = UIImage(named: name) else {
               fatalError()
            }
            
            data.setValue(UIImagePNGRepresentation(img), forKey: "photo")
         }
      }
      
      DataManager.shared.saveMainContext()
   }
   
   
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

extension BlobTableViewController {
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


extension BlobTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}


