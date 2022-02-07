// Date Formatter를 활용해서 날짜를 문자열로, 문자열을 날짜로 바꾸는 방법
// 문자열/날짜 상호 변환, Date Style, Time Style,
// Unicode Date Format Pattern, Localized Date Format
//
// https://developer.apple.com/documentation/foundation/data_formatting
// https://developer.apple.com/documentation/foundation/dateformatter


/*:
 # DateFormatter
 */

import UIKit

let now = Date()
print("now : (now)")

// 날짜를 출력할 때는 원하는 포맷으로 바꿔서 표시한다.
// 새로운 DateFormatter 인스턴스를 만들고 속성을 정의해주고 호출한다.
let formatter = DateFormatter()
// none : 해당파트를 표시하지 않는다. 두스타일 중 하나는 none 이 아닌 값으로 설정해 줘야 한다.
formatter.dateStyle = .full
formatter.timeStyle = .medium
formatter.locale = Locale(identifier: "ko_kr")


// 날짜가 논옵셔널 형태로 저장되어 있을 경우
var result = formatter.string(from: now)
print("result :\(result)")

// 언래핑하지 않고 사용 날짜가 옵셔널 형식으로 되어 있다면 사용
//formatter.string(for: <#T##Any?#>)


// 방법 2 타입 메소드 활용


//  Formatter를 반복적으로 사용하지 않는다면 타입 메소드를 활용하여 조금 더 짧은 코드로 구현 할 수 있다.
//  the current locale을 사용하기 때문에 Locale 따로 지정해주는 1번째 방식으로 해야 한다.
var reult2 = DateFormatter.localizedString(from: now, dateStyle: .long, timeStyle: .short)
print("reult2 : \(reult2)")


//: [Next](@next)
