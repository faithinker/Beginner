
import Foundation
import CoreData

//Department를 읽어온 다음 배열로 리턴하는 메소드가 구현되어 있다.
extension DataManager {
   func fetchDepartment() -> [DepartmentEntity] {
      var list = [DepartmentEntity]()
      
      mainContext.performAndWait {
         let request: NSFetchRequest<DepartmentEntity> = DepartmentEntity.fetchRequest()
         
         let sortByName = NSSortDescriptor(key: #keyPath(DepartmentEntity.name), ascending: true)
         request.sortDescriptors = [sortByName]
         
         do {
            list = try mainContext.fetch(request)
         } catch {
            fatalError(error.localizedDescription)
         }
      }
      
      return list
   }
}
