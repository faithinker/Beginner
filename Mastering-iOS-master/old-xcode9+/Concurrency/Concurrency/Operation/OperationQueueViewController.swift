// Concurrency Programming
// 여러개의 작업이 동시에 실행 되도록 한다 (쓰레드) 빠르게 동작하는 것도 중요하지만 타이밍을 조절해서 반응성을 높이는것도 중요하다.
// CocoaFramweork Operation 과 GCD를 제공한다.
// Process : 앱을 시작하면 새로운 instance가 시작된다. iOS는 Process를 생성하고 리소스 할당
// Task : 앱에서 실행하는 작업  Task를 실행하는 쓰레드가 한개 이상 존재
// 메인쓰레드 자동생성 (UIUpdate, touch이벤트 처리), 백그라운드 쓰레드는 필요할때마다 직접 추가 네트워크 파일 처리 등이 있음
// Queue 쓰레드에서 실행 할 작업을 저장하는 요소
// Operation 작업사이의 의존성을 구현 또는 취소 기능을 구현할 때 사용한다.
// GCD 실행할 작업을 원하는 큐에 추가하면 멀티코어를 활용해서 최대한 빠르게 실행한다.

// Operation 하나의 작업을 나타내는 객체이다.
// Interoperation Dependencies :  Operation 사이에 의존성을 추가해서 실행 순서를 제어 할 수 있다.
// Cancellation 실행 취소 기능을 구현한다. Completion Handler을 구현하는데 필요한 API를 제공한다.
// Operation은 Single-shot Object 이다. 실행이 완료된 인스턴스는 다시 실행 할 수 없다. 동일한 작업을 반복적으로 사용해야하는 경우에는
// 매번 새로운 인스턴스를 생성해야 한다. Ready -> Executing -> Finished OR Cancelled
// Operation 상태 감시는 KVO를 활용한다.

//Operation.QueuePriority 동일한 큐에 추가되어 있는 Operation사이에  상대적인 우선순위를 설정한다.
//QualityOfService (QOS) 리소스 사용 우선순위를 결정한다.

//emoticon shortKey : ctrl + cmd + space


//처음부터 다시해야함 제대로 동작안함 Concurrency - Operation & Operation Queue

import UIKit

class OperationQueueViewController: UIViewController {
   
    let queue = OperationQueue() //백그라운드 큐에서 작업.  OperationQueue.main 메인 큐에서 실행
   
    var isCancelled = false
    
   @IBAction func startOperation(_ sender: Any) {
    
    isCancelled = false
    
    queue.addOperation {
        autoreleasepool { //메모리 관리를 직접 처리해주지 않는다. 그래서 autoreleasepool을 쓴다.
            for _ in 1...100 {
                guard !self.isCancelled else { return }
                print( "🐬", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.3)
            }
        }
    }
    //하나의 Operation에 두개 이상의 블록을 추가할 수 있다.
    let op = BlockOperation {
        autoreleasepool {
            for _ in 1...100 {
                guard !self.isCancelled else { return }
                print( "🙉", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    queue.addOperation(op)
    
    op.addExecutionBlock {
        autoreleasepool {
            for _ in 1...100 {
                guard !self.isCancelled else { return }
                print( "🐠", separator: " ", terminator: " ")
                Thread.sleep(forTimeInterval: 0.5)
            }
        }
    }
    let op2 = CustomOperation(type: "🐏")
    queue.addOperation(op2)
    op.completionBlock = {
        print("Done")
    }
    //실행이 완료된 경우에는 Block 추가에 주의해야 한다. cmd + T 새로운 탭 추가
    
    
    
    // queue.addOperation { <#code#> } // queue.addOperation(block : () -> Void )  instance 생성없이 블록형태로 추가
    //queue.addOperation(op: Operation)  개별 Operation 추가
    //queue.addOperations(ops : [Operation], waitUntilFinished: Bool) 의존성을 추가하거나 여러개를 동시에 추가 할 때
   }
   
   @IBAction func cancelOperation(_ sender: Any) {
    isCancelled = true
    queue.cancelAllOperations()
   }
   
   deinit {
      print(self, #function)
   }
    
    override func viewWillDisappear(_ animated: Bool) {
       super.viewWillDisappear(animated)
        isCancelled = true
        queue.cancelAllOperations()
    }
}
