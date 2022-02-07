//
//  EmployeeEntity+CoreDataClass.swift
//  CoreData
//
//  Created by 김주협 on 2021/03/14.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//
//

// Extension으로 추가되어 있는 코드는 파일을 생성할 때마다 업데이트 된다.(Property 파일)
// 반면 Class 선언은 파일을 다시 생성 할 떄 그대로 유지된다.
// Validation Code는 Class 파일에서 구현한다. (유실 X 위해)
//

import Foundation
import CoreData

@objc(EmployeeEntity)
public class EmployeeEntity: PersonEntity {

//    작업 단위로 검증할 때는 ValidateFor~ 메소드를 오버라이딩(재정의) 한다.
//    Entity가 추가될 때 검증하고 싶다면... 아래 코드
//    public override func validateForInsert() throws {
//        // 하위구현에서 상위구현을 반드시 호출해야 한다.
//        try super.validateForInsert()
//    }
    
    
    //  오버라이딩이 금지됨. 대신 이 메소드가 검증과정에서 호출하는 메소드를 구현한다.
//    public override func validateValue(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>, forKey key: String) throws {
//        <#code#>
//    }
    
    
    
    
    // 개별 attribute를 검증하는 메소드는 특별한 형식을 가져야 한다.
    // 선언 앞부부분에 @objc 코드를 추가하고 throw in function으로 선언해야 한다.
    // 메소드 이름은 validate와 attribute의 조합으로 구성해야 한다.
    // 파라미터 형식은 반드시 <AnyObject?> 와 동일한 형식으로 지정해야 한다.
    // validateValueForkey 메소드가 검증과정에서 자동으로 호출한다.
    
    
    // 검증에 사용될 값은 포인터로 전달된다. 포인터를 확인하고 값에 접근한다.

    // Concurrency 동영상 학습 때 주석처리 시킴
//    @objc func validateAge(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>)
//    throws {
//        guard let ageValue = value.pointee as? Int else { return }
//
//        if ageValue < 20 || ageValue > 50 {
//            let msg = "Age Value must be between 20 and 50"
//            // 이미 선언되어 있는 오류를 사용하는것이 좋고 없으면 만들어라.
//            let code = ageValue < 20 ? NSValidationNumberTooSmallError : NSValidationNumberTooLargeError
//            let error = NSError(domain: NSCocoaErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: msg])
//            // 오류는 대부분 NSError 클래스로 저장한다.
//
//
//            throw error
//        }
//        // 검증 메소드 내부에서 오류를 전달하면 검증이 실패한다. 오류를 전달하지 않고 그냥 전달되면 검증이 성공한다.
//        // 검증 메소드 사용시 주의사항
//// value 파라미터로 전달되는 pointer를 통해 값을 수정하면 경우에 따라 메모리 오류가 발생한다.
//// 이 메소드에서 다른 attribute 값을 바꾸거나 validateValueForkey 메소드를 직접 호출하면 무한루프가 발생한다.
//        // * pointer에 저장된 값을 읽고 검증하는 코드만 구현해야 한다. *
//
//    }
//
////    @objc func validateName(_ value: AutoreleasingUnsafeMutablePointer<AnyObject?>)
////    throws {
////
////    }
//
    
// 개발부서에는 20대 직원이 소속될 수 없는 경우...
// Age attribute와 Department Relationship을 함께 검증해야 하는 복잡함.
// Entity가 추가되거나 업데이트 되는 시점마다 반복적으로 검증해야 한다.
    @objc func validateAgeWithDepartment()
    throws {
        guard let deptName = department?.name, deptName == "Development" else { return }
        
        guard age < 30 else { return }
        
        // 위의 것 return 되지 않았다면 제시한 조건을 만족시키지 않는 것이다.
        // 오류 생성 후 전달한다.
        
        let msg = "The Development department cannot have employees under 30 years of age"
        let code = NSValidationNumberTooLargeError
        let error = NSError(domain: NSCocoaErrorDomain, code: code, userInfo: [NSLocalizedDescriptionKey: msg])
        throw error
    }
    
    // 직접 구현한 메소드는 반드시 상위 구현을 호출한 다음 호출해야한다.
    // 그렇지 않으면 validation이 정상적으로 동작하지 않거나 Crash가 발생한다.
    
    public override func validateForInsert() throws {
        try super.validateForInsert()
        try validateAgeWithDepartment()
    }
    
    public override func validateForUpdate() throws {
        try super.validateForUpdate()
        try validateAgeWithDepartment()
    }
    
}

// global scope에 상수를 선언한 다음 다른 오류코드와 겹치지 않는 값을 저장한다.
public let NSValidationInvalidAgeAndDepartment = Int.max - 100
