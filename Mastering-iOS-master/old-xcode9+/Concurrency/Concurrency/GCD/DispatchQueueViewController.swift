//GCD 쓰레드 자동생성 효율적 관리, 재사용 단순한 API 제공
// Concurrent Queue VS Serail Queue




import UIKit


class DispatchQueueViewController: UIViewController {
   
   @IBOutlet weak var valueLabel: UILabel!

    let serialWorkQueue = DispatchQueue(label: "SerialWorkQueue")
    //작업 동시실행하는 ConcurrentQueue
    let concurrentWorkQueue = DispatchQueue(label: "ConcurrentWorkQueue", attributes: .concurrent)
   
   //메인큐를 블로킹하지 않으면서 백그라운드에서 긴 작업을 할 수 있다.
   @IBAction func basicPattern(_ sender: Any) {
    DispatchQueue.global().async {
        var total = 0
        for num in 1...100 {
           total += num
           Thread.sleep(forTimeInterval: 0.1)
        }
        DispatchQueue.main.async {
            self.valueLabel.text = "\(total)"
        }
    }
    //완료되기까지 10초가 걸리는데 메인쓰레드가 블로킹 되고 다른 액션(이벤트)들을 처리 할 수 없다.
    //매우 빠르게 실행되는 코드와 UIUpdate 코드를 제외한 나머지 코드는 백그라운드에서 실행해야 한다.
//    var total = 0
//    for num in 1...100 {
//       total += num
//       Thread.sleep(forTimeInterval: 0.1)
//    }
//    valueLabel.text = "\(total)"
   }
   
    
    //sync async메소드는 실행할 작업을 Dispatch 메소드에 추가하는 작업이다. 실행메소드 아님
    //작업을 실제 진행하는것은 Dispatch Queue이다.
   @IBAction func sync(_ sender: Any) {
    //sync는 동기방식 진행 작업이 완료될때 까지 대기. 메인쓰레드에서 호출하면 크래쉬 발생한다.
    concurrentWorkQueue.sync {
        for _ in 0..<3 {
            print("Hello")
        }
        print("Point 1")
    }
        print("Point 2")
   }
   
   @IBAction func async(_ sender: Any) {
    //비동기 방식 : 작업을 추가하고 바로 리턴, 이어지는 코드가 바로 실행됨, 연관된 쓰레드를 블로킹하지 않기 때문에 대부분 async메소드를 씀
    concurrentWorkQueue.async {
        for _ in 0..<3 {
            print("Hello")
        }
        print("Point 1")
    }
        print("Point 2")
   }
   
   @IBAction func delay(_ sender: Any) {
    let delay = DispatchTime.now() + 3
    concurrentWorkQueue.asyncAfter(deadline: delay) {
        print("Point 1")
    }
    print("Point 2")
   }
   
    //반복코드를 빠르게 처리
   @IBAction func concurrentIteration(_ sender: Any) {
    var start = DispatchTime.now()
    for index in 0..<20 {
        print(index, separator: " ", terminator: " ")
        Thread.sleep(forTimeInterval: 0.2)
    }
    var end = DispatchTime.now()
    print("start :\(start), End : \(end)")
    print("\nfor-in :", Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000000)
    
    
    
    //실행 순서는 매번 달라지지만 병렬 수행을 통해 실행속도가 매우 빨라진다. 반복순서가 중요하지 않은 경우에만 사용한다!
    
    start = .now()
    //0~19사이의 인덱스가 전달된다.
    DispatchQueue.concurrentPerform(iterations: 20) { (index) in
        print(index, separator: " ", terminator: " ")
        Thread.sleep(forTimeInterval: 0.1)
    }
    end = .now()
    print("\nconcurrentPerform :", Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000000)
   }
}
























