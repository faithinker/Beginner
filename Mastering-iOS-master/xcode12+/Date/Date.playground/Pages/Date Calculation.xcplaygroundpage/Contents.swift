
import Foundation

/*:
 # Date Calculation
 */

extension Date {
    init?(year: Int, month: Int, day: Int, hour: Int = 0, minute: Int = 0, second: Int = 0, calendar: Calendar = .current) {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.day = day
        
        guard let date = calendar.date(from: components) else {
            return nil
        }
        
        self = date
    }
}

let calendar = Calendar.current
let worldCup2002 = Date(year: 2002, month: 5, day: 31)!


let now  = Date()
let today = calendar.startOfDay(for: now) // 오늘 0시 0분 0초

var comps = DateComponents()
comps.day = 1 // -1 1일전
comps.hour = 24 // 25 이상이면 다음 날짜로 넘어감

calendar.date(byAdding: comps, to: now)  // day+-  ,  기준 날짜 => D-Day 날짜를 구해줌
calendar.date(byAdding: comps, to: today)


comps = calendar.dateComponents([.day], from: now, to: today)
comps.day  // 며칠이 지났는지 확인 할 수 있다. 
//: [Next](@next)
