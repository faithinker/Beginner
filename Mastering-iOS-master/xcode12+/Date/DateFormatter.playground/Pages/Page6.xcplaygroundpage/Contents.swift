// 특별한 세 가지 Date Formatter
// ISO8601 날짜 파싱, 날짜 범위 포멧팅, 날짜와 시간 간격 포멧팅
// iOS에서 날짜를 파싱할 때 주로 사용한다.


/*:
 # ISO8601DateFormatter
 */

import Foundation


let str = "2017-09-02"
let str2 = "2017-09-02T09:30:00Z"

let formatter = ISO8601DateFormatter()


// 포맷 옵션 지정 : with접두어로 시작하는 옵셔들이 있다.
formatter.formatOptions = [.withFullDate]
// 00020107 : 연월일 사이에 있는 하이픈 - 문자열을 명확히 파악 할 수 없기 때문이다.
// 앞에 있는 네개만 파싱되고 나머지는 무시된다.
//
// withDashSeparatorInDate : 하이픈 문자를 구분문자로 인식한다.
//
// .withYear, .withMonth, .withDay, .withDashSeparatorInDate == withFullDate
//
// 웹서버와 날짜 문자열을 주고받을 떄는 .withInternetDateTime 사용한다.
// ISO8601을 사용하거나 RFC 3339를 사용하는 웹서버와 오류없이 날자문자열을 주고 받을 수 있다.



if let date = formatter.date(from: str) {
    // 날짜가 문자열로 바뀔 때 시간 부분이 추가된 표준 문자열로 바뀐다.
    formatter.formatOptions = .withInternetDateTime
    print(formatter.string(from: date))
} else {
    print("invalid format")
}
// 날짜를 문자열로 바꿀 때 : String

// 문자를 날짜로 바꿀 때 : Date



//: [Next](@next)
