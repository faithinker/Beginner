//: [Previous](@previous)

import Foundation

/*:
 # Compound Predicates
 */

//simple Predicates : 연산자 한개만 씀 >, <
/*:
 ## AND, &&
 */
// Group  revenue 200000 초과 두개 만족
// 숫자에 CONTAINS가 쓰이면 "이상"이다.
var predicate = NSPredicate(format: "%K CONTAINS %@ AND %K > %d", #keyPath(Company.name), "Group", #keyPath(Company.revenue), 200000)
companies.filtered(using: predicate)

/*:
 ## OR, ||
 */

predicate = NSPredicate(format: "%K CONTAINS %@ OR %K > %d", #keyPath(Company.name), "Group", #keyPath(Company.revenue), 200000)
companies.filtered(using: predicate)

/*:
 ## NOT, !
 */

predicate = NSPredicate(format: "NOT (%K CONTAINS %@ OR %K > %d)", #keyPath(Company.name), "Group", #keyPath(Company.revenue), 200000)
companies.filtered(using: predicate)



//: [Next](@next)
