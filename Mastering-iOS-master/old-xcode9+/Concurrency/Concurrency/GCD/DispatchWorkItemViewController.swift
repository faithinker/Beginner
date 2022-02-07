// DispatchWorkItem : GCD에서 Task를 캡슐화하는 클래스이다.
// 캡슐화된 소스를 Dispatch queue나 DispatchSource에 추가해서 구현한다.
// 취소기능 API제공하지만 Op와 OpQueue를 활용하는 것이 효율적

import UIKit

class DispatchWorkItemViewController: UIViewController {
   
   let workQueue = DispatchQueue(label: "WorkQueue")
   var currentWorkItem: DispatchWorkItem!
   
   @IBAction func submitItem(_ sender: Any) {
    currentWorkItem = DispatchWorkItem(block: {
        for num in 0..<100 {
            guard !self.currentWorkItem.isCancelled else { return }
            print(num, separator: " ", terminator: " ")
            Thread.sleep(forTimeInterval: 0.1)
        }
    })
    workQueue.async(execute: currentWorkItem)
    
    //Dispatch Queue에서 데드락이 발생하면 실행되지 않는다.
    currentWorkItem.notify(queue: workQueue) {
        print("Done")
    }
    
    // currentWorkItem.wait()   //작업이 끝날때까지 대기
    //파라미터로 최대 대기시간 설정
    let result = currentWorkItem.wait(timeout: .now() + 2)
    switch result {
    case .timedOut: //시간초과(실패)
        print("TimedOut")
    case .success: //최대시간 이전에 완료
        print("Success")
    default:
        break
    }
    
    //notify는 비동기 메소드 wait는 동기 메소드(메인쓰레드에서 실행), wait가 실행되도 작업은 계속된다.
    //wait 때문에 액션이 블록처리됨. 지정된 시간동안 응답이 없을 경우 요청을 취소하는 기능을 구현한다. 지정된 시간동안 수행못한 작업을 취소할 때 유용하다.
   }
   
   @IBAction func cancelItem(_ sender: Any) {
    //DispatchWorkItem에 대한 상태를 저장해두었다가 cancel 메소드를 개별적으로 호출한다.
    currentWorkItem.cancel()
   }
}
