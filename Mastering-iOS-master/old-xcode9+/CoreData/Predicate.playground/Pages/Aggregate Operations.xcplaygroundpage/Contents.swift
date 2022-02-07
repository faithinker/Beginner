//: [Previous](@previous)

import Foundation

//employees는 data.json 파일
/*:
 # Aggregate Qualifiers
 */

// CoreData에서 Too-Many Realtionship과 함께 사용한다.
// All, Any, In 은  predicate내에서 하나만 사용


/*:
 ## ANY, SOME
 */
// collection과 연관
// 조건에 적합한 데이터가 Collection에 포함될 때 True로 평가된다.
var predicate = NSPredicate(format: "ANY employees.age >= 50")
departments.filtered(using: predicate)

predicate = NSPredicate(format: "SOME employees.age >= 50")
departments.filtered(using: predicate)


/*:
 ## ALL
 */

// Collection에 포함된 모든 연산자가 조건을 만족시키는 경우에만 true로 평가된다.

predicate = NSPredicate(format: "ALL employees.age BETWEEN {31, 42}")
departments.filtered(using: predicate)


/*:
 ## NONE
 */
// 조건을 만족시키는 데이터가 하나도 없을 때 투르
// 20대 직원이 없는 부서만 리턴
predicate = NSPredicate(format: "NONE employees.age < 30")
departments.filtered(using: predicate)


/*:
 ## IN
 */
// {} 안에서 또는의 개념. 일치하는 것만 리턴
// 배열에는 반드시 두개이상 포함
predicate = NSPredicate(format: "revenue IN {229234.0, 89950.0, 160546.0}")
companies.filtered(using: predicate)






/*:
 # Aggregation Operators
 */
// Collection에서 간단한 산술연산을 실행 @ 앳 기호를 쓴다.
/*:
 ## @count
 */
// 갯수 리턴
predicate = NSPredicate(format: "employees.@count < 4")
departments.filtered(using: predicate)

/*:
 ## @avg
 */
// 나이 평균
predicate = NSPredicate(format: "employees.@avg.age < 30")
departments.filtered(using: predicate)

/*:
 ## @min
 */
// 부서내 막내가 20대인가
predicate = NSPredicate(format: "employees.@min.age > 30")
departments.filtered(using: predicate)

/*:
 ## @max
 */
// 부서내 고참이 50대 이상인가
predicate = NSPredicate(format: "employees.@max.age >= 50")
departments.filtered(using: predicate)

/*:
 ## @sum
 */
// 부서내 연봉 합이 300000 이상인가
predicate = NSPredicate(format: "employees.@sum.salary >= 300000")
departments.filtered(using: predicate)


/*:
 # Array Operations
 */
//Format 문자열이 포함된 배열에서 특정 요소에 접근 할 때는 subscript 문법을 사용

// json 파싱에 있는 첫번째 사람의 나이가 35 이상인가
predicate = NSPredicate(format: "employees[0].age >= 35")
departments.filtered(using: predicate)
// 위에랑 같음
predicate = NSPredicate(format: "employees[FIRST].age >= 35")
departments.filtered(using: predicate)

// json 파싱 마지막에 잇는 사람이 나이가 35이상인가
predicate = NSPredicate(format: "employees[LAST].age >= 35")
departments.filtered(using: predicate)

// 부서내 사람이 딱 6명인가. @count와 비슷
predicate = NSPredicate(format: "employees[SIZE] == 6")
departments.filtered(using: predicate)


//: [Next](@next)
