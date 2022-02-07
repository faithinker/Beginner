// iOS에서 날짜를 처리하는 방법 : DateComponent, Calendar, TimeZone 설정
// 우리나라에서 사용하는 달력 : 양력 음력
// 중국 : 중국력,  중동 : 히브리어, 이슬리역
// Date에 저장되는 값은 특정 달력과 연관되지 않은 독립적인 값이다.
// 날짜와 시간을 화면에 표시하거나 어떤 계산을 하고 싶다면 특정 달력을 사용해야 한다.
// 달력은 Calendar 구조체로 선언되어 있다.



import Foundation

/*:
 # Calendar
 */
// 그레고리언
Calendar.Identifier.gregorian


//gregorian  buddhist  chinese ethiopicAmeteMihret
//hebrew iso8601 indian islamic islamicCivil  japanese persian republicOfChina

// 아이폰 설정에서 설정되어있는 달력을 선택
// 사용자가 설정해준 달력을 리턴하는 것은 동일하지만,
// 사용자가 설정에서 달력을 바꿨을 때 차이가 있다.
// current 최초에 가지고온 달력을 유지함. autoupdatingCurrent 사용자가 바꾼 달력으로 자동으로 업데이트 한다.
// 앱에서 여러가지 달력을 사용하거나 해외 자주 나가는 사람 아니면 비슷하다.
Calendar.current
Calendar.autoupdatingCurrent






//: [Next](@next)
