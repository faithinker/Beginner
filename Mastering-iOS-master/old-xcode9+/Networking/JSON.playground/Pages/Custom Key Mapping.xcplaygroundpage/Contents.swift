//: [Previous](@previous)

import Foundation

struct Person: Codable {
   var firstName: String
   var lastName: String
   var age: Int
   var address: String?
   
   // case 이름은 항상 속성과 동일해야 한다. 직접 선언하지 않으면 case 이름과 동일하게 매핑된다.
    enum CodingKeys: String, CodingKey {
        case firstName
        case lastName
        case age
        case address = "homeAddress"
    }
   
   //
}

let jsonStr = """
{
"firstName" : "John",
"age" : 30,
"lastName" : "Doe",
"homeAddress" : "Seoul",
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

do {
   let p = try decoder.decode(Person.self, from: jsonData)
   dump(p)
} catch {
   print(error)
}



//: [Next](@next)
