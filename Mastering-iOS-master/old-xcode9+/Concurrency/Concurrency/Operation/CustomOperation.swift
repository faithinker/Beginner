
import UIKit

//9분

class CustomOperation : Operation {
    let type : String
    
    init(type: String) {
        self.type = type
    }
    
    override func main() {
        autoreleasepool {
            for _ in 1...100 {
                guard !isCancelled else { return } //isCancelled 속성을 확인하고 작업을 종료하는 코드 구현해야 한다.
                print(type, separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.9)
            }
        }
    }
}






























