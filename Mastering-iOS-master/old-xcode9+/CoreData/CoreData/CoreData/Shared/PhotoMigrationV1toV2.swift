//
//  PhotoMigrationV1toV2.swift
//  CoreData
//
//  Created by 김주협 on 2021/03/27.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//

// DataModel > Inspector > CustomPolicy 복붙


import Foundation
import CoreData

@objc(PhotoMigrationV1toV2)
class PhotoMigrationV1toV2 : NSEntityMigrationPolicy {
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        
        // sInstance : 원본 모델에 저장되어 있는 데이터 모델이 전달됨
        // mapping : mapping과 연관된 정보 주로 엔티티 이름을 확인할 때 쓰임
        // manager :mapping을 실행하는 매니저 객체
        
        
        try super.createDestinationInstances(forSource: sInstance, in: mapping, manager: manager)
        
        
        // photo Entity가 클래스가 제공하는 생성하는자를 사용하지만 여기서 사용불가능함.
        // NSManagedObjectClass NSEntityDescription Class가 제공하는 API를 쓴다.
        // 이렇게 하지 않으면 Migration 과정에서 오류가 발생한다.
        if let photo = sInstance.value(forKey: "photo") as? Data {
            let context = manager.destinationContext
            
            let newPhoto = NSEntityDescription.insertNewObject(forEntityName: "Photo", into: context)
            newPhoto.setValue(photo, forKey: "photo")
            
            print("New Photo")
            
            // 생성된 포토객체와 employee 객체를 연결
            let destResult = manager.destinationInstances(forEntityMappingName: mapping.name, sourceInstances: [sInstance])
            
            if let employee = destResult.last {
                employee.setValue(newPhoto, forKey: "profile")
                print("employee -> photo")
            }
        }
    }
}

