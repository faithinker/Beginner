
import Foundation

// obj-c 에서 실행 할 수 있도록 특성 추가
//
// 보통 NSData거나 String 타입을 리턴한다.
// Contact Instance가 데이터 형식으로 저장된다.
@objc(ContactTransformer)
class ContactTransformer : ValueTransformer {
  override class func transformedValueClass() -> AnyClass {
    
    return NSData.self
  }
  // 역변환 코드
  override class func allowsReverseTransformation() -> Bool {
    return true
  }
  override func transformedValue(_ value: Any?) -> Any? {
    //없어진 문법
    //return NSKeyedArchiver.archivedData(withRootObject: value!)
    
    //return NSKeyedArchiver.archivedData(withRootObject: value!, requiringSecureCoding: false)
    return nil
  }
  // 저장소에 저장되어있는 데이터를 실제 형식으로 바꿔서 리턴
  override func reverseTransformedValue(_ value: Any?) -> Any? {
    guard let data = value as? Data else { fatalError() }
    // 없어진 문법
    // // NSKeyedUnarchiver.unarchiveObject(with: <#T##Data#>)
    
    //return NSKeyedUnarchiver.unarchivedObject(ofClass: <#T##NSCoding.Protocol#>, from: data)
    
    return nil
  }
}
