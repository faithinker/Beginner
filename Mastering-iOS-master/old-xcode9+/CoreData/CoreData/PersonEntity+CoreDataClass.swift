//
//  PersonEntity+CoreDataClass.swift
//  CoreData
//
//  Created by 김주협 on 2021/01/11.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//
//

import UIKit
import CoreData

@objc(PersonEntity)
public class PersonEntity: NSManagedObject {
  // Model File > Entity > Inspector에서 설정한 name : PersonEntity로 생성되었다.
  
  // CodeGen : Class Definition으로 빌드해도 이 메소드는 사라지지 않는다.
  func doSomethingInClass() {
    
  }
  
  // XCode가 Entity 클래스를 생성하는 패턴
  // XCode는 Entity Class와 Extension파일을 하나씩 생성한다.
  // CoreDataClass == Class, CoreDataProperties == Extension
  //
  // 동일한 Entity에서 같은 작업을 반복하면 Class선언은 그대로 유지하고 ExtensionFile만 업데이트 한다.
  // 그래서 Entity에 필요한 기능을 추가할 때는 Class선언 부분에서 추가한다.
  // 속성이 바뀌더라도 Extension부분만 업데이트 되기 때문에 전혀 문제가 없다.
  // 그래서 두개의 파일을 생성하는 이유다.
  //
  // DataModel >  Entity Inspector > CodeGen : Class Definition
  //
  // Product > Clean Build Folder : XCode가 이전에 생성한 모든 파일을 삭제한다.
  // XCode가 생성한 Entity코드는 Build 과정에서 타깃에 자동으로 추가된다.
  // DataModel 상태에 따라 자동으로 업데이트 되기 떄문에 Class를 편집하는 것이 불가능하다.
  //
  // Datamodel의 Entity에서 Attribute를 여러개 추가 할 때 Calss를 다시 생성하는 것이 편하다.
  // DataModel Choosing ->  Editor -> Create NSManagedObject SubClass
  //
  // DataModel >  Entity Inspector > CodeGen : Category Extension
  // 속성이 선언되어있는 Extension을 자동으로 생성한다.
  // Extension은 생성하지만 Class는 생성하지 않기 때문에 직접 Class 설정 해줘야한다.
  // DataModel Choosing ->  Editor -> Create NSManagedObject SubClass으로 만들고
  // PersonEntity+CoreDataProperties를 삭제
  // Class Definition과 Manual/None의 이 두개의 장점을 합친 옵션이다.
  // 속성이 선언되어있는 Extension이 자동으로 생성되기 때문에
  // 새로운 Atribute를 추가할 때마다 파일을 다시 생성하거나 파일을 편집할 필요가 없다.

}
