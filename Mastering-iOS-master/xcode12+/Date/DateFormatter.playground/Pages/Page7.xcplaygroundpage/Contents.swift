
/*:
 # DateIntervalFormatter
 */
import Foundation

let startDate = Date()
let endDate = startDate.addingTimeInterval(3600 * 24 * 3) //30

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "ko_KR")
formatter.dateStyle = .long
formatter.timeStyle = .short

print("\(formatter.string(from: startDate)) - \(formatter.string(from: endDate))")


let intervalFormatter = DateIntervalFormatter()
intervalFormatter.locale = Locale(identifier: "ko_KR")
//intervalFormatter.dateStyle = .long
//intervalFormatter.timeStyle = .short

intervalFormatter.dateTemplate = "yyyyMMdE"

// 시작날짜 종료날짜 리턴하면 문자열을 리턴한다.
let result = intervalFormatter.string(from: startDate, to: endDate)
print("result :\(result)")


//: [Next](@next)
