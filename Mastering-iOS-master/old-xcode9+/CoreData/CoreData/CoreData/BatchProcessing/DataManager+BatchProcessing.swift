
import Foundation
import CoreData

extension DataManager {
    // batchUpdate()와 batchDelete() 함수 구현
   func batchUpdate() {
      let update = NSBatchUpdateRequest(entityName: "Task")
      // true로 값 저장
      update.propertiesToUpdate = [#keyPath(TaskEntity.done): true]
      //작업대상 지정, done attribute값이 false인것만 true 작업 진행함
      update.predicate = NSPredicate(format: "%K == No", #keyPath(TaskEntity.done))
      update.resultType = .updatedObjectsCountResultType
    
      // 배치 업데이트는 3가지 방식으로 결과를 리턴한다. 리턴방식은 resultType으로 설정함
      // statusOnlyResultType : 성공과 실패를 Bool 값으로 리턴
      // updatedObjectIDsResultType : 업데이트된 엔티티의 오브젝트 ID 값을 리턴
      // updatedObjectsCountResultType : 업데이트된 오브젝트의 갯수를 리턴
    
    do {  // Context 메소드를 쓰지만 실제작업은 영구저장소에서 실행된다. execute가  persistentStoreResult형이다.
        if let result = try mainContext.execute(update) as? NSBatchUpdateResult, let cnt = result.result as? Int {
            print("Updated : \(cnt)")
        }
    } catch {
        print(error.localizedDescription)
    }
    
   }
   // 값이 Yes 인것만 삭제
   func batchDelete() {
      let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Task")
      request.predicate = NSPredicate(format: "%K == YES ", #keyPath(TaskEntity.done))
    
      let delete = NSBatchDeleteRequest(fetchRequest: request)
    delete.resultType = .resultTypeCount
    
    do {
        if let result = try mainContext.execute(delete) as? NSBatchDeleteResult, let cnt = result.result as? Int {
            print("Updated : \(cnt)")
        }
    } catch {
        print(error.localizedDescription)
    }
    
    
   }
   // 1만개의 대용량 데이터 추가
   func batchInsert() {
      mainContext.perform {
         for index in 0 ..< 10_000 {
            let newTask = TaskEntity(context: self.mainContext)
            newTask.task = "Task \(index + 1)"
            newTask.date = Date().addingTimeInterval(TimeInterval(3600 * 24 * Int.random(in: -365 ... 365)))
            
            if index % 1_000 == 0 {
               do {
                  try self.mainContext.save()
               } catch {
                  print(error.localizedDescription)
               }
            }
         }
         
         do {
            try self.mainContext.save()
            print("Inserted")
         } catch {
            print(error.localizedDescription)
         }
      }
   }
}
