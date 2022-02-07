
/*:
 # Symbols
 */
import Foundation

let now = Date()
let weekdaySymbols = ["☀️", "🌕", "🔥", "💧", "🌲", "🥇", "🌏"]
let am = "🌅"
let pm = "🌇"

let formatter = DateFormatter()
formatter.dateStyle = .full
formatter.timeStyle = .full

formatter.amSymbol = am
formatter.pmSymbol = pm

print(formatter.string(from: now))

formatter.amSymbol = am
formatter.pmSymbol = pm   // Symbol 입력하면 여러 심볼이 나옴
formatter.weekdaySymbols = weekdaySymbols

print(formatter.string(from: now))

// formatter를 사용하면 특정 컴포넌트는 원하는 심볼로 바꿀 수 있다.
//: [Next](@next)
