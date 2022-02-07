// CoreDataClass와 CoreDataProperties가 생성된 이유는
// "Data Model File의 Update"에 대응하기 위해서이다.
// PersonEntity를 사용해서 KeyValue Coding을 사용하지 않고 ManagedObject를 사용할 수 있다.
//
// XCode가 자동으로 추가하는 파일은 AppDelegate에 추가된다.
// 따라서 스택에 접근할 때마다 AppDelegate에 접근하는 코드가 필요하므로 불편하다.
//
// CoreData를 초기화하고 Singleton객체를 구현하여 접근하는 것이 좋은 코딩이다.

import UIKit
import CoreData


extension PersonEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PersonEntity> {
        return NSFetchRequest<PersonEntity>(entityName: "Person")
    }
    @NSManaged public var age: Int16
    @NSManaged public var name: String?
  
//  Dummy 메소드이다. CodeGen : Class Definition 설정시 사라진다는 것을 보여주기 위함
//  func doSomethingInExtension() {
//
//  }

}
