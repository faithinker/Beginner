//    Core Data 1장 : 4가지의 주요한 객체
//    1. NSPersistentStore> Persistent Store : 영구 저장소
//    영구저장소에 데이터를 메모리에 로딩하는 방식이 두가지로 (Atomic, Non-atomic) 나뉜다.
//    Atomic 데이터를 처리 할 때 모든 데이터를 메모리에 로드해야한다.
//    Non-atomic 필요한 부분만 메모리에 로드한다.
//     Atomic은 잘 사용하지 않고 In-Memory만 캐싱 구현할 때 사용한다.
//    2.NSManagedObjectModel> Object Model :
//    어떤 데이터가 저장되고 데이터들이 어떤 관계를 가지고 있는지 설명하는 객체이다.
//    영구 저장소에 데이터를 저장할려면 어떤 구조로 저장해야하는지 파악해야 하는데 여기에 필요한 모든 정보가 Object Model에 저장된다. XCode가 제공하느 모델 편집기를 쓴다.
//    3. NSPersistentStoreCoordinator > Persistent Store Coordinator
//     영구저장소 코디네이터 영구저장소에 있는 데이터를 가져오거나 저장하는 객체이다. 얘가 중개를 한다.
//    Context 객체 -> Object Model로 구조파악 -> 영구저장소에 알아서 저장
//    4. NSManagedObjectContext
//    CoreData에서 데이터 생성 -> Context 내부에 임시데이터로 유지 -> Context에게 저장요청 -> 영구저장소 저장
//
//     NSPersistentContainer >  Persistent Container
//    Container는 코어데이터스택을 캡슐화한 객체
//    attribute선택 > Data Inspector > Transient 영구저장소에 저장되지 않는 임시속성
//    주로 다른 attribute를 기반으로 계산되는 attribute이다.
//    >Optional : 체크시 선택적이다. == Not null (SQL)
//
//    Entity > Data Inspector > Class Section
//    name : entity와 연결되는 클래스의 이름. 접미어 "Entity"를 붙여라
//    일반클래스와 Entity클래스를 구분짓기 위함이다.
//
//    Codegen > Class Definition : entity Class가 자동으로 만들어진다.
//    Class Definition상태에서 entity를 직접 만들면 충돌해서 컴파일 오류가 발생한다.
//     Manual/Run : entity Class를 직접 만든다.
//
//    Entity Class 생성하는 법
//    DataModel 선택 > 메뉴 Editor > Create NSManagedObject Subclass : DataModel
//    -> Entity
//    CoreDataStack을 초기화하고 싱글톤 객체를 통해 접근하도록 구현해야 한다.

import UIKit
import CoreData

class DataManager {
  static let shared = DataManager()
  
  private init() { }
  
  var container: NSPersistentContainer?
  
  // 컨테이너가 생성한 기본 컨텍스트를 리턴한다.
  // viewContext 모든 기능을 제공한다. 이름 때문에 읽기만 제공한다고 착각하지 말자
  // 속성 이름이 mainContext인 이유는 이 컨텍스트가 MainThread에서 동작하기 때문이다.
  // Context가 제공하는 API는 쓰레드에 안전하지 않아서 반드시 동일한 쓰레드에서 호출해야 한다.
  // 데이터를 빠르게 처리하기 때문에 일반적인 상황에서는 Blocking 당하지 않는다.
  // 하지만 큰 데이터의 경우에는 BackgroundContext를 생성해야 한다.
  var mainContext: NSManagedObjectContext {
    guard let context = container?.viewContext else { fatalError() }
    return context
  }
    
    //
    lazy var backgroundContext: NSManagedObjectContext = {
        guard let context = container?.newBackgroundContext() else {
            fatalError()
        }
        return context
    }()
  
  //컨테이너 초기화: 생성자로 모델이름을 전달 후 메소드 하나만 호출 => Stack 초기화 완료
  func setup(modelName: String) {
    container = NSPersistentContainer(name: modelName)
    container?.loadPersistentStores(completionHandler: {(desc, error) in if let error = error {
      fatalError(error.localizedDescription)
    }
    })
  }
  
// context가 제공하는 perform메소드는 블록에 포함된 코드를 context가 생성된 쓰레드에서 실행한다.
// Thread에서 발생하는 문제점을 해결 할 수 있다.
  func saveMainContext() {
    mainContext.perform{
      // 저장하기 전에 비교하고 save 메소드 실행하기 때문에 효율적이다.
      if self.mainContext.hasChanges {
        do {
          try self.mainContext.save()
        } catch {
          print(error)
        }
      }
    }
  }
}
//  프로젝트에서 데이터 모델 사용시 (한개의 데이터 모델만 사용)
//1. 대부분 앱 시작시점(AppDelegate)에 스택을 초기화한다.
//2. 반면 특정씬에서 별도의 데이터 모델을 사용한다면 씬이 생성되는 시점에 초기화한다.

//opt + \ : «
//shift + opt + \ :  »
//cmd + \ : BreakLine
