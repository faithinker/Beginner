//   전체데이터가 5천개 저장되어 있고 엔티티가 1kb이고 데이터 수를 화면에 출력한다고 가정
//    resultType이 managedObjectResultType로 설정되어 있으면 5천kb 메모리가 필요하다.
//    저장소에서 읽어온 다음 context에 등록해야하기 때문에 약간의 시간도 필요하다.
//    반면 resultType이 count로 설정되어 있으면 하나의 숫자만 리턴된다. context 등록과정도 필요 없어서 매우 빠르다.

import UIKit
import CoreData

class ResultTypesViewController: UIViewController {
   
   let context = DataManager.shared.mainContext
   // fetch Request가 결과를 리턴하는 방식 4가지
    // 1. 리턴 형식을 result typed으로 지정. 직접 지정 안하면 ManagedObjected 형태로 리턴된다.
    //
   @IBAction func fetchManagedObject(_ sender: Any) {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
      
      request.resultType = .managedObjectResultType
    
      do {
         let list = try context.fetch(request)
         if let first = list.first {
            print(type(of: first))
            print(first)                        
         }
      } catch {
         fatalError(error.localizedDescription)
      }
   }

   @IBAction func fetchCount(_ sender: Any) {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
      
    request.resultType = .countResultType
    // fetchrequest로 가져온 수를 리턴한다.
    
      do {
         let list = try context.fetch(request)
         if let first = list.first {
            print(type(of: first))
            print(first)
         }
        // resultType 사용보다 count 메소드 사용하는 것이 더 좋다.
        let cnt = try context.count(for: request)
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   @IBAction func fetchDictionary(_ sender: Any) {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
    
//    resultType -> Dictionary resultType으로 설정.
//    특정 attribute를 가져올 때 사용 ManagedObjected 기능 사용 X. 메모리 절약함
      request.resultType = .dictionaryResultType
      request.propertiesToFetch = ["name", "address"]
    
      do {
         let list = try context.fetch(request)
         if let first = list.first {
            print(type(of: first))
            print(first)
         }
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   @IBAction func fetchManagedObjectID(_ sender: Any) {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Employee")
//      모든 ManagedObjected는 고유한 ID를 가지고 있다. 여러 Context 사이에서 데이터를 주고받을 때 사용한다.
      request.resultType = .managedObjectIDResultType
    
      do {
         let list = try context.fetch(request)
         if let first = list.first {
            print(type(of: first))
            print(first)
         }
      } catch {
         fatalError(error.localizedDescription)
      }
   }
}
