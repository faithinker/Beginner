//: [Previous](@previous)

import Foundation

struct Person: Codable {
   var firstName: String
   var lastName: String
   var age: Int
   var address: String?
}
// json Key가 스네이크 형식으로 작성되어 있다. 에러남
let jsonStr = """
{
"first_name" : "John",
"age" : 30,
"last_name" : "Doe",
"address" : "Seoul"
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

// Swift는 LowerCamelCase를 사용한다.
decoder.keyDecodingStrategy = .convertFromSnakeCase
//

do {
   let p = try decoder.decode(Person.self, from: jsonData)
   dump(p)
} catch {
   print(error)
}



//: [Next](@next)
