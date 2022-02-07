import UIKit

struct Person: Codable {
   var firstName: String
   var lastName: String
   var birthDate: Date
   var address: String?
}

let p = Person(firstName: "John", lastName: "Doe", birthDate: Date(timeIntervalSince1970: 1234567), address: "Seoul")

// json으로 인코딩 되는 형식은 반드시 encodable 프로토콜을 채용해야 한다. 디코딩 되는 형식은 Decodable을 채택해야한다.
// 인코딩과 디코딩이 모두 가능하다면 Codable Protocol로 대체한다.

//
let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted //줄바꿈이 추가됨
// sortedKeys 키를 사전순으로 정렬함

do {
    let jsonData = try encoder.encode(p)
    if let jsonStr = String(data: jsonData, encoding: .utf8) {
        print(jsonStr)
    }
}catch {
    print(error)
}
//

//: [Next](@next)
