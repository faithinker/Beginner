
import Foundation

struct DepartmentJSON: Codable {
   let id: Int
   let name: String
   
   static func parsed() -> [DepartmentJSON] {
      do {
         guard let fileUrl = Bundle.main.url(forResource: "department", withExtension: "json") else {
            fatalError()
         }
         
         guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError()
         }
         
         let decoder = JSONDecoder()
         return try decoder.decode([DepartmentJSON].self, from: data)
      } catch {
         fatalError(error.localizedDescription)
      }
   }
}

struct EmployeeJSON: Codable {
   let name: String
   let age: Int
   let address: String
   let salary: Int
   let department: Int
   
   static func parsed() -> [EmployeeJSON] {
      do {
         guard let fileUrl = Bundle.main.url(forResource: "employee", withExtension: "json") else {
            fatalError()
         }
         
         guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError()
         }
         
         let decoder = JSONDecoder()
         return try decoder.decode([EmployeeJSON].self, from: data)
      } catch {
         fatalError(error.localizedDescription)
      }
   }
}
