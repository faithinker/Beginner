
import Foundation

/*:
 # TimeZone
 */

let calendar = Calendar.current
var components = DateComponents()
components.year = 2014
components.month = 4
components.day = 16
components.timeZone = TimeZone(identifier: "Asia/Seoul")
calendar.date(from: components)

components.timeZone = TimeZone(identifier: "America/New_York")
calendar.date(from: components)



// DateTime은 UTC가 기준이다.
// KST : Korea Standard Time
// UTC와 9시간 차이난다.

// iOS에서 제공하는 TimeZone
for name in TimeZone.knownTimeZoneIdentifiers {
    print(name)
}
// Asia/Seoul
print(TimeZone.knownTimeZoneIdentifiers.count)



//: [Next](@next)
