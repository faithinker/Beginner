// CoreData는 스택을 초기화 할 때마다 데이터 모델을 검증한다.
// 실제 파일에 저장되어 있는 데이터 '구조'와 데이터 '모델'이 동일하다면 스택이 정상적으로 초기화된다.
//
// Lightweight(Automatic) Migration : 기본적으로 활성화 되어 있다.
// 일치하지 않는다면 차이점을 분석하고 MappingModel을 생성한다.
// 자동으로 생성된 MappingModel을 통해 오류없이 데이터구조를 변경할 수 있다면 새로운 데이터 모델을 적용한다.
// 기존 데이터는 새로운 모델로 자동이전되고 스택이 정상적으로 초기화된다.
// 기본적인 패턴 자동으로 처리함. nonOptional -> Optional 문제 X.  Optional -> nonOptional 기본값 설정
// 어트리뷰트 삭제는 데이터 일관성이 유지되는 경우에만 자동으로 처리된다.
// 엔티티와 어트리뷰트가 Rename 할 때는 기존 데이터가 정상적으로 이전되는 것이 중요하다.
// RenamingIdetifier를 통해서 이전이름과 새로운 이름을 연결 해야 한다.
// RenamingIdetifier를 지정하지 않으면 기존 어트리뷰트에 저장된 값은 복사되지 않고 그냥 삭제됨
//
//
// Standard(Manual) Migration
// AutomaticMigration을 통해 데이터를 변경 할 수 없다면 오류(크래쉬)가 발생함.
// 이럴 때는 직접 MappingModel을 만들고 Migration 규칙을 지정해야한다.
//
//
// Migration의 원리 개념 흐름 순서
// 기존 데이터모델   <- 매핑모델 -> 새로운 데이터 모델
// 기존 저장소  -> 복사  -> 새로운 저장소
// Migration에서는 두개의 모델이 필요하다. MappingModel은 두모델 사이의 차이점을 기반으로 자동으로 생성되거나 직접 생성함.
// Migration이 시작되면 새로운 데이터 모델을 기반으로 저장소가 생성된다.
// 원본저장소에 있는 데이터가 새로운저장소로 복사된다. MappingModel에 포함된 모든 Relationship 정보를 기반으로 모든 데이터가 연결된다.
// 마지막으로 모든 데이터에서 Validation이 실행된다. 모든 과정이 오류없이 끝나야 Migration이 정상적으로 종료된다.
// 그리고 원본 저장소가 삭제되고 새로운저장소가  기본(원본)저장소로 설정된다.
//
//
//
// datamodel > Task Entity > attribute 추가 : optional 해제, Default 해제
// 새로운 attribute에 저장할 값이 없어 Validation 오류가 발생하고 결과적으로 Migration 할 수 없다.
//
// Migration은 앱을 삭제하고 재설치하면 필요가 없지만 (앱 출시 이전 상태)
// 이미 앱이 출시된 상태에서 DataModel을 변경할 때는 반드시 Migration을 구현해야 한다. (앱 업데이트시 크래시)
//
//
// Datamodel 활성화 > Editor > Add Model Version
// 앱 스토어에 출시된 앱의 데이터모델을 변경해야 한다면 항상 새로운 모델 버전을 추가하고 활성화된 버전을 지정해야 한다.
// File Inspector > Model Version > Current : 변경
//
// Datamodel : 큰 데이터 저장시 Allows External Storage 활성화 시켜라
//
// Employee.photo -> Photo.photo
// photo attribute에 있던 '데이터'가 photo 엔티티쪽으로 자동으로 복사되지 않는다.
// 자동 migration만 되고 그것이 끝나면 원본 저장소가 삭제되므로 데이터가 날라간다.주의해야한다.
//
//
//
// Mapping Model : Source -> Target 파일명은 원본버전과 타깃버전을 포함시킨다.
// 추론되 값이 쓰여있다. photo의 경우 Mapping 정책을 직접 구현해야 한다.
// ModelV1toV2의 Photo 엔티티 삭제

import UIKit
import CoreData

class MigrationTableViewController: UITableViewController {
   lazy var resultController: NSFetchedResultsController<NSManagedObject> = { [weak self] in
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
      
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]
      
      let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: DataManager.shared.mainContext, sectionNameKeyPath: nil, cacheName: nil)
      controller.delegate = self
      return controller
      }()
   
   @IBAction func addPhotoData(_ sender: Any) {
      if let list = resultController.fetchedObjects {
         for (_, data) in list.enumerated() {
            autoreleasepool {
               let name = "avatar\(Int.random(in: 1...50))"
               guard let img = UIImage(named: name) else {
                  fatalError()
               }
               
               data.setValue(UIImagePNGRepresentation(img), forKey: "photo")
            }
         }
      }
      
      DataManager.shared.saveMainContext()
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let cell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: cell) {
         if let vc = segue.destination as? ProfileViewController {
            vc.target = resultController.object(at: indexPath)
            vc.title = vc.target?.value(forKey: "name") as? String
         }
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


extension MigrationTableViewController {
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
      cell.detailTextLabel?.text = target.value(forKeyPath: "department.name") as? String
      
      return cell
   }
}


extension MigrationTableViewController: NSFetchedResultsControllerDelegate {
   func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
      tableView.reloadData()
   }
}
