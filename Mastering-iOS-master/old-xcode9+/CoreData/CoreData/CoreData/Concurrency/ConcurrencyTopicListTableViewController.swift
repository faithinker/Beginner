// 대부분의 앱은 하나의 context만 사용한다. 메인쓰레드에서 동작하기 때문에 속도가 빠르지만 대량의 데이터를 처리할 때는
// '블로킹'을 방지하기 위해서 백그라운드 쓰레드에서 동작하는 BackgroundContext가 필요하다.
//
// 여러 컨텍스트를 동시에 사용할 떄는 두가지 중요한 규칙을 지켜야 한다.
// 1. 컨텍스트는 쓰레드에 안전하지 않기 때문에 모든 작업을 컨텍스트를 생성한 쓰레드에서 실행해야 한다.
// 2. 다른 컨텍스트로 Managed Object를 전달할 수 없다. 대신 ManagedObjectID를 전달하고 이 아이디를 통해서 Context에서 사용할 객체를 다시 읽어야 한다.
//
// Context를 생성 할 때는 보통 컨테이너가 제공하는 속성과 메소드를 사용한다.
// 생성된 Context는 개별적으로 사용하거나 Parent-Child로 연결해서 사용한다.



import UIKit
import CoreData

class ConcurrencyTopicListTableViewController: UITableViewController {
   
    // Entity 삭제하는 메소드
   @IBAction func reset(_ sender: Any) {
      let context = DataManager.shared.mainContext
      let entityNames = ["Task", "Employee", "Department"]
      for name in entityNames {
         let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
         
         let delete = NSBatchDeleteRequest(fetchRequest: request)
         delete.resultType = .resultTypeCount
         
         do {
            if let result = try context.execute(delete) as? NSBatchDeleteResult, let cnt = result.result as? Int {
               print("Deleted: \(name), \(cnt)")
            }
         } catch {
            print(error)
         }
      }
   }
   
}
