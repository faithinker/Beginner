
import Foundation

/*:
 # DateComponents
 */


let now = Date()

let calendar = Calendar.current

let components = calendar.dateComponents([.year, .month, .day, .minute], from: now)

components.year
components.month
components.day
components.minute
print(type(of: components.minute))

let year = calendar.component(.year, from: now)

// TimeInterval 매번 시간차를 계산해야 한다.

var memorialDayComponents = DateComponents()
memorialDayComponents.year = 2021
memorialDayComponents.month = 4
memorialDayComponents.day = 16

// 새로운 데이트를 만들면 끝
// components에 저장된 값이 캘린더로 만들 수 없는 경우도 있기 때문에 옵셔널이다.
let memorialDay = calendar.date(from: memorialDayComponents)









// Date에 저장된 값이 레퍼런스로부터 몇초가 지났는지를 나타내는 단순한 값이기 때문에 항상 캘린더가 필요하고
// 캘린더의 도움을 받아서 특정 컴포넌트에 접근해야한다.

// Set<Calendar.Component>
// Component 열거형 선언 다양한 컴포넌트를 지원함




// 1분  | 60초
// 10분 | 60초 X 10
// 1시간 | 1분이 60번 | 60초 X 60분
// 1일  | 1시간이 24번 | 60초 X 60분 X 24시간
// 1년  | 1일이 365일  | 60초 X 60분 X 24시간 X 365
// * 단 1년은 윤년을 계산해야 한다.

// 차라리 TimeInterval로 2021년까지만 숫자 직접 명시해주고...
// 그 뒤의 월, 일, 시간은 Calendar로 표현

//: [Next](@next)
