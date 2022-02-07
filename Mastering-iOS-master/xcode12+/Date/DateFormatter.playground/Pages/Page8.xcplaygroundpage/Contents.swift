
/*:
 # DateComponentsFormatter
 */
// https://developer.apple.com/documentation/foundation/datecomponentsformatter

import Foundation





let startDate = Date()
let endDate = startDate.addingTimeInterval(3600 * 24 * 30)

print(endDate)


// 날짜와 시간사이의 간격을 문자열로 바꿀 때 사용한다.

let formatter = DateComponentsFormatter()


formatter.unitsStyle = .full

//if let  result = formatter.string(from: startDate, to:  endDate) {
//    print(result)
//}


var comps = DateComponents()
comps.day = 0
comps.hour = 1
comps.minute = 0
comps.second = 7


formatter.unitsStyle = .positional // 0을 처리하는 방식
// 기본값 문자열 앞부분 0은 제거 중간부분은 padding(0표시) 처리 된다.

formatter.zeroFormattingBehavior = .dropAll //.pad



//formatter.allowedUnits = [.minute] // 분단위로만 표현

//formatter.maximumUnitCount = 1 //문자열에 포함되는 유닛숫자를 제한.
// 가장 작은 단위의 유닛부터 생략되고 생략된 것은 반올림 된다


// 네비게이션 사용시 목적지 도착 에상시간 보여줄 때 유리. 하지만 번역되지 않고 항상 영어로 표기된다.
formatter.includesTimeRemainingPhrase = true // 문자열 뒤에remaining이 추가됨
formatter.includesApproximationPhrase = true // 문자열 앞에 About이 추가됨

if let result = formatter.string(from: comps) {
    print(result)
}
// 1hours, 30 minutes





//: [Next](@next)
