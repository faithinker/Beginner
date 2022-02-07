import UIKit

// iOS에서 날짜를 처리하는 방법
// Date & Time Interval, 날짜 생성, 날짜에서 특정 정보 추출
/*:
 # Date Type and Reference Date
 
 ### Reference date: 2001-01-01 00:00:00 / UTC
 */

// OBJ-C Class 형태로 제공   NSDate, NSCalendar, NSDateComponents NSTimezone NSLocale
// Swift Structure 형태로 제공 Date, Calendar, DateComponents, Timezone, Locale

// 대부분의 연산자는 브릿징을 제공하기 떄문에 타입 캐스팅이 필요하다면 as 연산자로 처리 할 수 있다.

// 현재 날짜와 시간이 만들어짐
let now = Date()
print(now)

// 디버그 : 지역설정을 무시하고 UTC 시간으로 표현    +0000 마지막은 시차
// 특정 타임존이나 달력에 독립적인 값이다.
// 기준이 되는 날짜를 Refernce Date  숫자를 더하면 이후 날짜. 빼면 이전 날짜

var dt = Date(timeIntervalSinceReferenceDate: 60 * 60) // 60초 * 60분 => 1시간 초과한 시간
print(dt)

dt = Date(timeIntervalSinceReferenceDate: -60 * 60) // 1시간 초과한 시간
print(dt)
//: [Next](@next)
