// User Defaults, Property List : 설정정보와 같은 간단한 데이터, 쿼리기능 제공 X. 검색 어려움
// Keychain : Privacy 정보
// CoreData : 다수의 데이터를 저장, 모든 데이터를 객체 그래프로 관리, 검색 정렬 쉬움
// Binary Data : NSCoding Codable Protocol을 채택
// APFS(AppleFileSystem) : iOS에서 사용하는 파일 시스템
// App Sandbox : 앱과 관련된 모든정보를 저장함
// Bundle Container : 앱 실행파일과 리소스 저장, 읽기전용
// Data Container : 앱에서 데이터 저장시 사용되는 공간, 애플 가이드라인 통해서 적절한 데렉토리에 저장해야 한다.
// Documents : 사용자가 직접 저장한 데이터
// Library : 사용자가 직접 사용하지 않은 데이터 중에서 영구적으로 저장 되어야 하는 데이터
// > Caches : 캐시로 사용하는 데이터, 저장공간이 부족한 경우 자동 삭제. 항상 존재한다고 가정하면 안됨
//파일을 읽기전에 확인하고새로운 캐시를 생성하는 코드를 작성해야 한다.
// > Application Support : 설정파일처럼 앱 실행에 필요한 파일들
// tmp : 특정작업에 사용하는 임시 파일. iOS는 앱이 실행하고 있지 않다면 특정 시점에 tmp에 있는 파일을 삭제한다. 사용후 바로 삭제하는 편이 낫다.
// iCloud Container : iCloud 동기화 데이터가 저장됨

//파일이나 디렉토리가 백업되는 것이 중요하다.

//사용자가 직접 생성하지 않은 파일, 다운로드한 파일, 다시 생성 가능한 파일, 캐시파일 등은 반드시 백업에서 제외시켜야 한다. 지키지 않으면 리젝 당할 수도 있다.


//Info.plist  {
// application supports iTunes File sharing : YES,
// Supports Opening documents in place : YES
//}

// 아이폰 연결 -> 빌드 -> 중지 -> Window> Devices and Simulators
//아이폰 > 내 앱 우클릭 > Download Container.. > Save > save한 파일 우클릭 "패키지 내용 보기" > App Data : Documents, Library, tmp 와 같은 구조로 디렉토리가 생성되어 있음

// Database - Entity Hierarchy and Relationship 강좌
//
// CoreData는 Entity Hierarchy 계층을 지원한다.
// 공통된 attribute를 가진 parent Entity를 추가하고 나머지를 Child Entity로 구성한다.
// 데이터 모델에 구성에 대한 시간이 줄어들고 데이터 모델도 단순해진다.
// 단점 : CoreData는 동일한 Parent 가진 모든 Entity를 하나의 테이블에 저장한다.
// Entity에 포함되어 있는 attribute가 많을수록 child Entity와 저장된 데이터의 수가 늘어날수록 성능이 저하됨
// 기준 : Entity 계층을 2단계 이하로 구성할 수 있고 계층에 포함된 전체 attribute 수가 10개 이하일 때 사용해라
//
//
// 실습 3단계
// 1. 기존에 추가했던 Person Entity를 추상 엔티티로 바꾸고 employee Entity를 Parent Entity로 바꿈
// Depart Entity를 추가한 다음, Employee Entity와 연결
// 2. JSON Data를 파싱한 다음, 영구저장소에 Import한다.
// 3. Department Entity와 Employee Entity를 테이블 뷰에 표시한다. 두 Entity 사이의 관계를 처리하는 코드를 구현한다.
//
//
// Person Entity > Inspector : Abstract Entity
// 추상클래스와 동일한 개념 Peson Entity instance를 생성 못함. child 통해서만 Instance 생성 가능
//
// RDB와 달리 CoreData는 ManagedObject를 직접 연결하기 때문에 id Attribute가 필요없다.
//
// CoreDatasms 두가지 관계를 지원한다.
// To-One Relationship : 일대일로 연결되는 관계   Relationship Attribute : 단수이름을 쓴다.
// To-Many Relationship : 일대다 연결  Relationship Attribute : 복수이름을 쓴다. Entity를 Set으로 반환한다.(Not Array), 정렬 X
// Department -> Employee   Source -> Destination
//
// Relationship > Inverse : 역관계를 지정. 부서에 속한 직원을 확인한다 <-> 직원이 속한 부서도 확인 할 수 있다.
// Inverse > Inspector > Count 관계에 속할 수 있는 Entity의 수를 지정한다.
// Arrangement > Ordered : 순서 정렬
// Delete Rule : Source Entity를 삭제 할 때 처리방식을 결정한다.
// Option : No Action, Deny, Cascade, Nullify
// No Action : 아무런 행동을 하지 않는다.
// 개발부서 삭제해도 개발부서 속한 직원 Entity 그대로 직원 부서 접근시 Error
// Deny : Destination에 Entity가 존재하는 경우 Source를 삭제할 수 없다.
// 개발부서 삭제시, 개발부서 속한 직원 모두 다른부서 옮기거나 없앰
// Cascade : Source를 삭제할 때, Destination에 속한 모든 Entity를 함께 삭제
// 개발부서 삭제시, 속한 직원 모두 삭제
// Nullify : Sourcce를 삭제한 다음 두 Entity사이의 관계를 삭제함.
// 개발부서가 삭제되면, 여기에 속한 모든 직원 데이터에서 연결되어있던 부서 데이터만 삭제된다.
// 
// Editor Style > 화살표  : 한개 - To-One, 두개 - To-Many
//

import Foundation

struct DepartmentJSON: Codable {
   let id: Int
   let name: String
   
   static func parsed() -> [DepartmentJSON] {
      do {
         guard let fileUrl = Bundle.main.url(forResource: "department", withExtension: "json") else {
            fatalError()
         }
         
         guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError()
         }
         
         let decoder = JSONDecoder()
         return try decoder.decode([DepartmentJSON].self, from: data)
      } catch {
         fatalError(error.localizedDescription)
      }
   }
}



struct EmployeeJSON: Codable {
   let name: String
   let age: Int
   let address: String
   let salary: Int
   let department: Int
   
   static func parsed() -> [EmployeeJSON] {
      do {
         guard let fileUrl = Bundle.main.url(forResource: "employee", withExtension: "json") else {
            fatalError()
         }
         
         guard let data = try? Data(contentsOf: fileUrl) else {
            fatalError()
         }
         
         let decoder = JSONDecoder()
         return try decoder.decode([EmployeeJSON].self, from: data)
      } catch {
         fatalError(error.localizedDescription)
      }
   }
}
