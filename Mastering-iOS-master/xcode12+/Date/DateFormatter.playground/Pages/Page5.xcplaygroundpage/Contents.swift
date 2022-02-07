
/*:
 # Date String Parsing
 */
// 문자열을 날짜로 파싱한다.


import Foundation

// 여기에 저장되어 있는 문자열은 ISO8601 표준 문자열이다.
// 표준에는 T 또는 Z 문자가 포함되어 있다.
// 포맷 문자열을 보면 T와 Z가 있다. 구분문자로  패턴문자와 연달아서 작성되어 있어
// XCode가 구분을 못한다. 백틱? 작은 따옴표로 다르다는 것을 보여준다.

let str = "2017-09-02T09:30:00Z"
let formatter = DateFormatter()

// 문자열과 동일한 포맷을 저장한다.

formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"

// 날짜를 파싱 할 때 사용하는 메소드 파싱이 성공하면 날짜를 리턴하고 실패하면 nil을 리턴한다.
if let date = formatter.date(from: str) {
    formatter.dateStyle = .full
    formatter.timeStyle = .full
    
    print(formatter.string(from: date))
}else {
    print("invalid format")
}

//: [Next](@next)
