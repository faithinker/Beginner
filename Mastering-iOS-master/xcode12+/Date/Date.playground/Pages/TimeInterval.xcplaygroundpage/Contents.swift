import Foundation

/*:
 # TimeInterval
*/
// 기본 단위가 초이다.
// public typealias TimeInterval = Double

let oneSec = TimeInterval(1)

// 1초보다 작은 숫자 전달
let oneMillisecond = TimeInterval(0.001)

let oneMin = TimeInterval(60)
let tenMin = TimeInterval(60 * 10)
let oneHour = TimeInterval(oneMin * 60)
let oneDay = TimeInterval(oneHour * 24)

// 현재시간 기준으로 날짜를 만들 때 사용
Date(timeIntervalSinceNow: oneDay)


//1970년 1월 1일 0시 0분  UnixTimeStamp로 날짜를 만들때 사용
// => API 서버에서 전달된 날짜를 파싱 할 때 사용한다.

Date(timeIntervalSince1970: .zero)
    
    
// 기준이 되는 날짜를 직접 지정할 때 사용
//Date(timeInterval: <#T##TimeInterval#>, since: <#T##Date#>)


// 3분전 접속 1625192265
// 2021년 7월 2일 금요일 오전 11:17:45
let data = TimeInterval(1625192265)
Date(timeIntervalSinceNow: .zero)
Date(timeIntervalSince1970: data)

let now = Date(timeIntervalSinceNow: .zero)
//: [Next](@next)






