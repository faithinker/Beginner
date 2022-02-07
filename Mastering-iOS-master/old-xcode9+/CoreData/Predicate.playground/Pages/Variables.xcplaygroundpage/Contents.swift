//: [Previous](@previous)

import Foundation

/*:
 # Variables
 */
// Format 문자열을 다른곳에서 동적으로 구성한다음 전달하거나 여러개의 format 지정자가 포함되어 있으면
// format 지정자만으로 어떤값인지 파악하기 힘들다.
var predicate = NSPredicate(format: "%K BEGINSWITH %@", #keyPath(Company.name), "America")

// 변수이름과 대체할 값을 딕셔너리로 전달한다.
predicate = NSPredicate(format: "%K BEGINSWITH $COMPANY_NAME", #keyPath(Company.name)).withSubstitutionVariables(["COMPANY_NAME": "America"])

companies.filtered(using: predicate)

//: [Next](@next)
