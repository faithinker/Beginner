
/*:
 # Custom Format
 
 [NSDateFormatter.com]:
 https://nsdateformatter.com/ ""
 [NSDateFormatter.com]
 */
// https://nsdateformatter.com/

import UIKit

let now = Date()
let formatter = DateFormatter()

formatter.locale = Locale(identifier: "en_US")
formatter.setLocalizedDateFormatFromTemplate("yyyyMMMMdE")
var result1 = formatter.string(from: now)
print(result1,"\t" , formatter.dateFormat)

formatter.locale = Locale(identifier: "ko_KR")
formatter.setLocalizedDateFormatFromTemplate("yyyyMMMMdEHH:EE")
var result2 = formatter.string(from: now)
print(result2, "\t" , formatter.dateFormat)
// formatter.dateFormat : 실제로 사용하는 데이터 포맷 문자열이 나온다.


// setLocalizedDateFormatFromTemplate 메소드가 Locale에 맞게 자동으로 업데이트 되지 않는다.
// 파라미터로 전달한 문자열을 현재 로케일에 적합한 포맷 문자열로 바꿔서 인스턴스 내부에 저장한다.
// Locale을 바꾼다고 해서 포맷 문자열이 자동으로 업데이트 되는 것은 아니다.
// Locale을 바구고 나서 이 메소드를 다시호출해야 한다.

formatter.setLocalizedDateFormatFromTemplate("yyyyMMMMd(E)HH:EE:m")
var result3 = formatter.string(from: now)
print(result3, "\t" , formatter.dateFormat)



//startDate.addingTimeInterval(3600 * 24 * 30)



// 직접 원하는 포맷을 설정하는 것도 가능하다.
// Locale에 관계없이 고정된 포맷이 필요할 때 주로 사용한다.
//formatter.dateFormat = "yyyyMMMMdE"
//var result3 = formatter.string(from: now)
//print(result3)


//formatter.locale = Locale(identifier: "ko_KR")


//: [Next](@next)
