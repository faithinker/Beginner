//: [Previous](@previous)

import Foundation

/*:
 # String Comparisons
 
 - case sensitive
 - diacritic sensitive
 */
// predicate format 문자열은 대소문자를 비교하지 않지만
// 문자열을 비교할때는 구분하고 악센트기호까지 구분한다.
/*:
 ## BEGINSWITH
 */
// 속성이름을 문자열로 지정하지 않고 #keyPath 표현식을 사용하여 오타를 줄인다.
// BEGINSWITH 접두어 비교
var predicate = NSPredicate(format: "%K BEGINSWITH %@", #keyPath(Company.name), "America")
companies.filtered(using: predicate)

predicate = NSPredicate(format: "%K BEGINSWITH %@", #keyPath(Company.name), "america")
companies.filtered(using: predicate)


/*:
 ## ENDSWITH
 */
// ENDSWITH 접미어 비교
predicate = NSPredicate(format: "%K ENDSWITH %@", #keyPath(Company.name), "Group")
companies.filtered(using: predicate)


/*:
 ## CONTAINS
 */
// CONTAINS 문자열의 포함관계 비교
predicate = NSPredicate(format: "%K CONTAINS %@", #keyPath(Company.name), "America")
companies.filtered(using: predicate)


/*:
 ## LIKE
 
 - ? matches 1 character
 - \* matches 0 or more characters 
 */
 
/**
 * asterisk
` Grave Accent backquote 역따옴표 capsLock 틸다키보드
~ tilde  물결
 | pipe
 @ At sign
 ^    carat
 \   back slash
 !  exclamation point
 [] square Bracket  대괄호
  {} curly Bracket   중괄호
   
   */
  



// 간단한 패턴비교
// asterisk(*) 하나이상의 문자가 있거나 없다.

predicate = NSPredicate(format: "%K LIKE %@", #keyPath(Company.name), "*Air*")
companies.filtered(using: predicate)

predicate = NSPredicate(format: "%K LIKE %@", #keyPath(Company.name), "De*Air*")
companies.filtered(using: predicate)


/*:
 ## MATCHES
 */

// 좀 더 복잡한 비교 IN Memory 저장소만 지원, CoreData 사용불가
// 정규식과 일치하는 데이터만 리턴
// 인용부호를 쓰고 하나의 백슬래쉬를 4개의 백슬래쉬로 대체애햐 한다.
let list = NSArray(array: ["010-1234-5678", "010-123-4567", "01012345678", "02-123-4567"])
predicate = NSPredicate(format: "SELF MATCHES '\\\\d{3}-\\\\d{3,4}-\\\\d{4}'")
list.filtered(using: predicate)

// %@일 때는 하나의 백슬래시를 두개의 백슬래시로 대체
let regex = "\\d{3}-\\d{3,4}-\\d{4}"
predicate = NSPredicate(format: "SELF MATCHES %@", regex)
list.filtered(using: predicate)

/*:
 ## Case Insensitive Search
 */
// 대소문자를 무시하교 비교
predicate = NSPredicate(format: "%K BEGINSWITH [c] %@", #keyPath(Company.name), "America")
companies.filtered(using: predicate)


predicate = NSPredicate(format: "%K BEGINSWITH[c] %@", #keyPath(Company.name), "america")
companies.filtered(using: predicate)


/*:
 ## Diacritic Insensitive Search
 */
// 악센트 문자 비교.
// [d]를 쓰면 악센트 무시하고 같은 문자인지만 비교
predicate = NSPredicate(format: "'cafe' == 'cafè'")
predicate.evaluate(with: nil)  // false


predicate = NSPredicate(format: "'cafe' == [d] 'cafè'")
predicate.evaluate(with: nil) // true


// 함께사용 가능 [cd]
predicate = NSPredicate(format: "%K BEGINSWITH [cd] %@", #keyPath(Company.name), "America")
companies.filtered(using: predicate)


//: [Next](@next)
