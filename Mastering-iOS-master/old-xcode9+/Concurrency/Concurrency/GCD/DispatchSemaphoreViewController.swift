//Counting Semaphore이다. 동기화 구현방법과 서로다른 DispatchQueue에 속한 실행 순서를 제어하는 방법

import UIKit

class DispatchSemaphoreViewController: UIViewController {
   
   var value = 0
   
   @IBOutlet weak var valueLabel: UILabel!
   
   let workQueue = DispatchQueue(label: "WorkQueue", attributes: .concurrent)
   let group = DispatchGroup()
   
   @IBAction func synchronize(_ sender: Any) {
      value = 0
      valueLabel.text = "\(value)"
      
      //ResourcePool을 관리할 때는 0보다 큰값을 전달한다. 여러작업을 하나씩 순서대로 실행해야 한다면 값을 1을 준다.
      let sem = DispatchSemaphore(value: 1)
    //Semaphore 구현방법은 요청과 대기의 반복이다. 작업을 실행하기 전에 Semaphore에게 요청한다.  Semaphore는 관리하고 있는 값이 0보다 큰지 확인한다. 0보다 크다면 value를 1 감소시키고 실행을 허가한다. 반대로 count가 0이라면 count가 증가 할 때까지 대기한다.
    // 이 역할을 수행하는것이 wait 메소드이다.
    
      workQueue.async(group: group) {
         for _ in 1...1000 {
            sem.wait() // 무한정대기하는 사태 없도록 해야하고 signal이 호출되도록 해야한다.
            self.value += 1
            //작업을 완료한 다음에는 대기중인 다른작업이 실행되도록 Semaphore에게 알려준다. count가 1 증가, 대기중 상태가 실행 상태로 바뀜
            sem.signal()
         }
      }
      
      workQueue.async(group: group) {
         for _ in 1...1000 {
            sem.wait()
            self.value += 1
            sem.signal()
         }
      }
      
      workQueue.async(group: group) {
         for _ in 1...1000 {
            sem.wait()
            self.value += 1
            sem.signal()
         }
      }
      
      group.notify(queue: DispatchQueue.main) {
        //wait() signal() 제거하면 모든 큐가 Value에 "동시" 접근하기 때문에 매번 다른값(3000보다 작은값)이 나옴
         self.valueLabel.text = "\(self.value)"
      }
   }
   //Semaphore를 활용해서 서로다른 큐에 있는 작업들을 제어 할 수 있다는것을 보여주기 위한것 코드를 홀용하지는 말아라
   @IBAction func controlExecutionOrder(_ sender: Any) {
      value = 0
      valueLabel.text = "\(value)"
      
      let sem = DispatchSemaphore(value: 0)
    
      workQueue.async {
         for _ in 1...100 {
            self.value += 1
            Thread.sleep(forTimeInterval: 0.1)
         }
//         DispatchQueue.main.async { //이렇게 해도 되긴 한다.
//            self.valueLabel.text = "\(self.value)"
//         }
        //카운트는 증가하지 않지만 wait를 호출하고 대기중인 코드에게 실행이 완료되었다는것을 알려준다.
        sem.signal()
      }
      //서로다른 큐에 추가된 작업을 제어해본다. semaphore활용
      DispatchQueue.main.async {
         sem.wait() //workQueue에 signal이 호출될 때까지 대기 / 메인큐에 탑재되어 다른 액션 실행못함(블로킹)
         self.valueLabel.text = "\(self.value)"
      }
    //workqueue에 추가된 작업이 먼저 실행되고  메인큐에 추가된 작업이 이어서 실행된다.
   }
}
















