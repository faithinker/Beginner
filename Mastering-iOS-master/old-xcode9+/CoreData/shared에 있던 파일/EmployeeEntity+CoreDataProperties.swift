//
//  EmployeeEntity+CoreDataProperties.swift
//  CoreData
//
//  Created by 김주협 on 2021/03/14.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//
//



import Foundation
import CoreData


extension EmployeeEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EmployeeEntity> {
        return NSFetchRequest<EmployeeEntity>(entityName: "Employee")
    }

    @NSManaged public var contact: Contact?
    @NSManaged public var salary: NSDecimalNumber?
    @NSManaged public var photo: Data?
    @NSManaged public var department: DepartmentEntity?

}
