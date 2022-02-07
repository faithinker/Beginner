//: [Previous](@previous)

import Foundation

//40대이상 직원이 3명이상 포함되어 있는가의 표현식

// (employees.age >= 40) collection이 아니라서 오류남
//var p = NSPredicate(format: "(employees.age >= 40).@count >= 3")
//departments.filtered(using: p)


//var p2 = NSPredicate(format: "ANY employees.age >= 40 AND employees.@count >= 3")
//departments.filtered(using: p2)


/*:
 # Subquery
 
 SUBQUERY(collection, varName, predicate)
 */
// sql의 where절, Having절 하고 비슷하다.
//
// subquery 세개의 파라미터를 받는다.
// varName  변수이름 컬렉션에 저장된 데이터와 바인딩 된다.
// 종속적인 쿼리 보낼때
// A에 포함된 B 쿼리를 찾아라
//
// 관계형 DB에서 사용하는 subquery와 유사. 여러 조건절
// collection은 보통 tomanyRealtionship을 전달
//
// 40대이상 직원이 3명이상 포함되어 있는가의 표현식
let predicate = NSPredicate(format: "SUBQUERY(employees, $emp, $emp.age >= 40).@count >= 3")
departments.filtered(using: predicate)




//: [Next](@next)
