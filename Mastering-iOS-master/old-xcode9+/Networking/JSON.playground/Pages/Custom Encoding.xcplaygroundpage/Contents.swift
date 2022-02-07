//: [Previous](@previous)

import Foundation

enum EncodingError: Error {
   case unknown
   case invalidRange
}

struct Employee: Codable {
   var name: String
   var age: Int
   var address: String?
   
   //  CustomEncoding 하는 이유
   // 1. 인코딩 시점에 값을 검증하거나 제약을 추가하는 경우
   // 2. 인코딩 전략이나 커스텀 키 매핑으로 원하는 결과를 얻을 수 없어 직접 구현해야 하는 경우
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        
        guard (30...60).contains(age) else { throw EncodingError.invalidRange }
        
        try container.encode(age, forKey: .age)
        // 옵셔널 때문에 IfPresent를 씀
        try container.encodeIfPresent(address, forKey: .address)
    }
   // 인코딩 된 데이터는 인코더 내부에 컨테이너 형태로 저장된다.
}

let p = Employee(name: "James", age: 30, address: "Seoul")


let encoder = JSONEncoder()
encoder.outputFormatting = .prettyPrinted

do {
   let jsonData = try encoder.encode(p)
   if let jsonStr = String(data: jsonData, encoding: .utf8) {
      print(jsonStr)
   }
} catch {
   print(error)
}






//: [Next](@next)

