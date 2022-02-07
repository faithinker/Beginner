// CoreDataClass와 CoreDataProperties가 생성된 이유는 데이터 모델 업데이트에 대응하기 위해서이다.
// KeyValue Coding을 사용하지 않고 ManagedObject를 사용할 수 있다.
//
// XCode가 자동으로 추가하는 파일은 AppDelegate에 추가된다. 따라서 스택에 접근할 때마다 AppDelegate에 접근하는 코드가 필요하다.
//
// CoreData를 초기화하고 Singleton객체를 구현하여 접근하는 것이 좋은 코딩이다.

import UIKit
import CoreData

class DataManager {
   static let shared = DataManager()
   
   private init() { }
   
  var container: NSPersistentContainer?
  

  
   var mainContext: NSManagedObjectContext {
      fatalError("Not Implemented")
   }
   
   func saveMainContext() {
      fatalError("Not Implemented")
   }
}
