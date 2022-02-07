// custom type에 저장된 속성
// Coredata > Entity > Attribute : binary Data 또는 Transformer 속성으로 저장


import Foundation

public class Contact: NSObject, NSCoding {
   @objc public var tel: String
   @objc public var fax: String
   @objc public var email: String
   
   init(tel: String, fax: String, email: String) {
      self.tel = tel
      self.fax = fax
      self.email = email
      
      super.init()
   }
   
   public static func sample() -> Contact {
      let telStr = String(format: "010-%04d-%04d", Int.random(in: 1000...9999), Int.random(in: 1000...9999))
      let faxStr = String(format: "02-%04d-%04d", Int.random(in: 1000...9999), Int.random(in: 1000...9999))
      let emailStr = String(format: "example%03d@kxcoding.com", Int.random(in: 0...999))
      
      return Contact(tel: telStr, fax: faxStr, email: emailStr)
   }
   
   public func encode(with aCoder: NSCoder) {
      aCoder.encode(tel, forKey: "tel")
      aCoder.encode(fax, forKey: "fax")
      aCoder.encode(email, forKey: "email")
   }
   
   public required init?(coder aDecoder: NSCoder) {
      tel = aDecoder.decodeObject(forKey: "tel") as! String
      fax = aDecoder.decodeObject(forKey: "fax") as! String
      email = aDecoder.decodeObject(forKey: "email") as! String
      
      super.init()
   }
}
