//  DataManager+Person.swift
//  CoreData
//
//  Created by 김주협 on 2021/01/06.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//
//  파일이름 짓는법 : Extension이나 Category를 짓는 파일이름은  00형식+객체명 으로 짓는다.
//
// Entity Class의 장점
// context: self.mainContext 만으로 쉽게 인스턴스를 생성 할 수 있다.
// KeyValue를 쓰지 않아도 되므로 코드가 직관적이고 단순해졌다.
// fetchRequest도 비교적 쉽게 생성 할 수 있다.


import Foundation
import CoreData
// Context가 저장된 다음 Noti가 전달되도록 수정 15분
extension DataManager {
  
  //named은 필수셀이고 Age는 옵셔널이어서 파라미터 형식 이렇게 한다.
  func createPerson(name: String, age: Int? = nil, completion: (() -> ())? = nil ) {
        mainContext.perform {//mainContext와 동일한 쓰레드에서 실행
          
// NSManagedObject(entity: NSEnitityDescription, insertInto: NSManagedObjectContext?)
// EnitityDescription Instance를 생성하기가 번거롭다.
// 그래서 대부분 NSEntity가 제공하는 타입 메소드를 사용한다.
          
            //NSManagedObject Instance를 생성할 때는 쓸 수 없다.
            //NSManagedObject(context: <#T##NSManagedObjectContext#>)
          
          
            let newPerson = PersonEntity(context: self.mainContext)

          
            newPerson.name = name
            
            if let age = age { //내부파라미터는 Int?형인데 newPerson.age는 Int16이다
                newPerson.age = Int16(age)
            }
            
            self.saveMainContext()
            completion?()
        }
    }
    
    //읽기
    func fetchPerson() -> [PersonEntity] {
        var list = [PersonEntity]()
        
      mainContext.performAndWait {
        // performAndWait : 블록을 모두 실행할 때까지 Return 하지 않는다.
        // Block 내부에서 배열 바로 리턴이 불가능해서 이 메소드를 씀
        
        // 블록 내부에서 배열을 채우고 블록 실행이 완료된 다음 리턴 할 수 있다.
        // Data를 가져올 때는 NSFetchRequest를 사용한다.
            let request: NSFetchRequest<PersonEntity> = PersonEntity.fetchRequest()
            
            let sortByName = NSSortDescriptor(key: #keyPath(PersonEntity.name), ascending: true)
            request.sortDescriptors = [sortByName]
            
        //Context에서 Fetch메소드를 호출하고 리턴되는 배열을 List 변수에 저장
            do {
                list = try mainContext.fetch(request)
            } catch {
                print(error)
            }
        }
        return list
    }
    //Create와 마찬가지로 바로바로 업데이트 되도록 Completion 파라미터 추가함
  func updatePerson(entity:PersonEntity, name:String?, age:Int? = nil, completion : (() -> ())? = nil ) {
        mainContext.perform {
            entity.name = name
            if let age = age {
                entity.age = Int16(age)
            }
            self.saveMainContext()
            completion?()
        }
  }
    
    func delete(entity: PersonEntity) {
        mainContext.perform {
            self.mainContext.delete(entity)
            self.saveMainContext()
        }
    }
}


