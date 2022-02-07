//
//  Copyright (c) 2019 KxCoding <kky0317@gmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import UIKit
import RxSwift

/*:
 # debounce
 */


//  debounce, throttle 연산자 : 짧은 시간 반복적으로 전달(방출)되는 이벤트를 효율적으로 처리(제어)한다.
// 연산의 결과가 다르기 때문에 잘 구분해야 한다.


let disposeBag = DisposeBag()

let buttonTap = Observable<String>.create { observer in
   DispatchQueue.global().async {
      for i in 1...10 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.3)
      }
      
      Thread.sleep(forTimeInterval: 1) //1초동안 쓰레드 중지
      
      for i in 11...20 {
         observer.onNext("Tap \(i)")
         Thread.sleep(forTimeInterval: 0.5)
      }
      
      observer.onCompleted()
   }
   
   return Disposables.create {
      
   }
}

// 1~10 연속적...  1초 쉬고  11~20까지 연속적.. 그래서 연속된것들중 마지막인 10과 20의 이벤트가 방출됨
// 타이머가 만료되기 전에 새로운 이벤트가 방출되는가 아닌가..   타이머 초기화됨

buttonTap
   .debounce(.milliseconds(1000), scheduler: MainScheduler.instance) // 두개만 전달됨
   .subscribe { print($0) }
   .disposed(by: disposeBag)


// time 연산자가 next이벤트를 방출할지 결정하는 조건으로 사용된다.
// 옵저버가 next 이벤트를 방출한 다음 지정된 시간동안 다른 next 이벤트를 방출하지 않는다면,
// 해당 시점에 마지막에 방출한 next 이벤트를 구독자에게 전달한다.
// 반대로 지정된 시간 이내에 또다른 next 이벤트를 방출했다면 timer를 초기화한다.
//
// timer를 초기화한다음에 다시 지정된 시간동안 대기한다. 이 시간 이내에 다른 이벤트가 방출되지 않는다면 마지막 이벤트를 방출하고
// 이벤트가 방출되면 timer를 다시 초기화한다.
//
// Scheduler 타이머를 실행 할 스케줄러를 전달한다.




