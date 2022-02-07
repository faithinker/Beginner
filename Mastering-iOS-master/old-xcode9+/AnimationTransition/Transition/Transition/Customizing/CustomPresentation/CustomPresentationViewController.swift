//
//  Copyright (c) 2018 KxCoding <kky0317@gmail.com>
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

class CustomPresentationViewController: UIViewController {
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      // segue 실행전에 modal 프레젠 style을 csutom으로 바꾸고
      // SimplePre~를 사용하도록 델리게이트로 구현한다.
        segue.destination.modalPresentationStyle = .custom
        segue.destination.transitioningDelegate = self
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
}

// 커스텀 프레젠 컨트롤러가 필요할 때마다 호출된다.
// 여기에서 return하는 컨트롤러가 기본 컨트롤러 대신 사용된다.

extension CustomPresentationViewController: UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        // instance를 생성 할 때는 반드시 VC를 파라미터로 받는 생성자를 구현해야 한다.
        if #available(iOS 13.0, *) {
            return SimplePresentationController(presentedViewController: presented, presenting: presenting)
        } else {
            // Fallback on earlier versions
            return nil
        }
        return nil
    }
}















