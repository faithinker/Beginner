
/*:
 # Relative Date Formatting
 */

import Foundation

let now = Date()
let twoDaysBefore = now.addingTimeInterval(3600 * -48)
let yesterday = now.addingTimeInterval(3600 * -24)
let tomorrow = now.addingTimeInterval(3600 * 24)
let twoDaysLater = now.addingTimeInterval(3600 * 48)

let formatter = DateFormatter()
formatter.locale = Locale(identifier: "ko_KR")
formatter.dateStyle = .full
formatter.timeStyle = .none

// 48시간 이내 상대적으로 바꿔줌 오늘 어제 내일
formatter.doesRelativeDateFormatting = true

print(formatter.string(from: now))
print(formatter.string(from: yesterday))
print(formatter.string(from: tomorrow))
print(formatter.string(from: twoDaysBefore))
print(formatter.string(from: twoDaysLater))



//: [Next](@next)
