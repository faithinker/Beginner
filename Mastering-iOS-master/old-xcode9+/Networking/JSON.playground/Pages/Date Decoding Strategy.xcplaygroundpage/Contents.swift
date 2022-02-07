//: [Previous](@previous)

import Foundation

struct Product: Codable {
   var name: String
   var releaseDate: Date
}

let jsonStr = """
{
"name" : "iPad Pro",
"releaseDate" : "2018-10-30T23:00:00Z"
}
"""

guard let jsonData = jsonStr.data(using: .utf8) else {
   fatalError()
}

let decoder = JSONDecoder()

// Type mismatch Error. 기본 디코딩 전략에서는  Double 형식으로 디코딩 시도
// 이렇게 하면 성능저하고 다른 시스템과의 호환성이 떨어짐. 가능하면 표준날짜 포맷을 사용해라.

decoder.dateDecodingStrategy = .iso8601
//

do {
   let p = try decoder.decode(Product.self, from: jsonData)
   dump(p)
} catch {
   print(error)
}



//: [Next](@next)

