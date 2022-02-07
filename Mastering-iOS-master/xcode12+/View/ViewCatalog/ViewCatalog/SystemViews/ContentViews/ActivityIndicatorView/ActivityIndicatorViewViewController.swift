//
//  Mastering iOS
//  Copyright (c) KxCoding <help@kxcoding.com>
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

class ActivityIndicatorViewViewController: UIViewController {
    //완료시점을 안다면 ProgressView, 모른다면 ActivityIndicator
    //ActivityIndicator>Behavior : Animating, Hides when Stopped
    @IBOutlet weak var hiddenSwitch: UISwitch!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    
    
    @IBAction func toggleHidden(_ sender: UISwitch) {
        
    }
    
    @IBAction func start(_ sender: Any) {
        //animation이 실해중이지 않은 상태에서만 호출한다.
        if !loader.isAnimating {
            loader.startAnimating()
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        if loader.isAnimating {
            loader.stopAnimating()
            //보통 애니메이션이 중지하면 화면에서 제거한다.
            loader.hidesWhenStopped = true
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hiddenSwitch.isOn = loader.hidesWhenStopped
        //loader.isAnimating = true 직접 값 제어 불가, 메소드 제공
        loader.startAnimating()
    }
}
