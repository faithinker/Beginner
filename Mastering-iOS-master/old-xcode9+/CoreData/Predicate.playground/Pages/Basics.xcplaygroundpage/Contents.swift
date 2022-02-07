import UIKit

// Editor -> Show Rendered Markup


///*:
// # Predicate 서술어
 //- Format String
// - Whitespace Insensitive 무감각한
//- Case Insensitive
 //*/

// 데이터 예제 : Companies,  Departments, data.json


/*:
 # Predicate //서술어
 - Format String
 - Whitespace Insensitive 무감각한
 - Case Insensitive
 */

// NSPredicate(block: nil)
// In-memory 또는 Atomic 저장소에서 제한적으로 사용. CoreData에서 사용불가

NSPredicate(format: "target LIKE %@", "value")

// format 문자열을 통해 검색조건을 지정한다.
// 타겟속성에 저장된 문자열을 검색 LIKE 문자열 비교
// Predicate에 사용되는 키워드를 대문자로 사용. 두개이상의 공백은 한개의 공백으로 처리
// %@은 전달된 값으로 대체되는 포맷 지정자이다.
// args :포맷지정자를 대체할 값




/*:
 ## Literals
 */

//Boolean Literals 1과 0 써도 되지만 YES, NO 쓰자
NSPredicate(format: "YES == TRUE")

NSPredicate(format: "NO == FALSE")
// 실제로는 NIL로 처리됨
NSPredicate(format: "NULL == NIL")

NSPredicate(format: "age > 30")
// 문자열을 인용부호로 감싸줘야한다.
NSPredicate(format: "name == 'Walmart'")
// " 은 escape Sequence 준수
NSPredicate(format: "name == \"Walmart\"")

// 배열 literal brace로 표기  주로 Collection 연산자 (filter, map 등)와 함께 사용
// Comma separated literal array
NSPredicate(format: "value IN {1, 2, 3, 4}")


/*:
 ## Format Specifiers
 */
// %K 속성이름을 동적으로 전달, 인용부호 추가되지 않음
// %@ 검색에 사용할 값을 전달.
NSPredicate(format: "%K CONTAINS %@", "name", "name")
print("\(NSPredicate(format: "%K CONTAINS %@", "name", "name"))")
// name CONTAINS "name"

// %@ 문자열과 참조형식을 대체. 직접 값형식 대체 못해서 형변환(박싱) 해줘야함
NSPredicate(format: "age >= %@", NSNumber(value: 30))

// %d, %i : 숫자 그대로 전달하고 싶을 때
NSPredicate(format: "age >= %d", 30)


/*:
 ## Evaluating Predicates
 */

let list = ["Apple", "Google", "MS"]
var predicate = NSPredicate(format: "SELF IN %@", list)
var ok = predicate.evaluate(with: "Apple")

predicate = NSPredicate(format: "SELF.revenue > 500000")
ok = predicate.evaluate(with: companies.firstObject)



/* test
 
*/
/**
    The perimeter of the `Shape` instance.

    Computation depends on the shape of the instance, and is
    equivalent to:

    ~~~
    // Circles:
    let perimeter = circle.radius * 2 * Float.pi

    // Other shapes:
    let perimeter = shape.sides.map { $0.length }
                               .reduce(0, +)
    ~~~
*/


/*:
    The perimeter of the `Shape` instance.

    Computation depends on the shape of the instance, and is
    equivalent to:

      ~~~
    // Circles:
    let perimeter = circle.radius * 2 * Float.pi

    // Other shapes:
    let perimeter = shape.sides.map { $0.length }
                               .reduce(0, +)
      ~~~
*/



//: [다음](@next)

//: [Next](@next)




/*  https://developer.apple.com/library/archive/documentation/Xcode/Reference/xcode_markup_formatting_ref/Attention.html#//apple_ref/doc/uid/TP40016497-CH29-SW1
*/
/**
 This line is Summary text
 
 
~~~
 // Personal Function
 let name: String = "이름"
 let age: Int = 0
 myFunction(name: name, age: age)
~~~
 

 - Parameters:
    - name: 이름
    - age: 나이
 - Throws: 에러를 던짐
 - Returns: 결과 값
 - Important: 중요한 경우
 - note: 노트, 필기
 - version: 1.0.0
 - waring: text
 - authors: faithinker
 - Version: 0.1
 - Postcondition: 후행조건
 - Precondition: 선행조건
 
 */
func myFunction(name: String, age: Int) {}




  
  
 
