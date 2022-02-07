//DispatchQueue에 추가된 작업을 가상의 그룹으로 관리한다. 서로다른 디스패치큐에 추가된 작업을 동일한 그룹에 추가하는 것도 가능하다.
//Group은 여러 작업을 하나의 작업으로 묶는것

import UIKit

class DispatchGroupViewController: UIViewController {
   
   let workQueue = DispatchQueue(label: "WorkQueue", attributes: .concurrent)
   let serialWorkQueue = DispatchQueue(label: "SerialWorkQueue")
   
    let group = DispatchGroup()
    
   @IBAction func submit(_ sender: Any) {
    //group.enter()
    workQueue.async(group: group) {
         for _ in 0..<10 {
            print("🍏", separator: "", terminator: "")
            Thread.sleep(forTimeInterval: 0.1)
         }
        //self.group.leave() //옛날방식 그룹 Enter, Leave를 쌍으로 같이 써준다.
      }

      workQueue.async(group: group) {
         for _ in 0..<10 {
            print("🍎", separator: "", terminator: "")
            Thread.sleep(forTimeInterval: 0.2)
         }
      }

      serialWorkQueue.async(group: group) {
         for _ in 0..<10 {
            print("🍋", separator: "", terminator: "")
            Thread.sleep(forTimeInterval: 0.3)
         }
      }
    group.notify(queue: DispatchQueue.main) {
        print("Done")
    }
   }
}

















