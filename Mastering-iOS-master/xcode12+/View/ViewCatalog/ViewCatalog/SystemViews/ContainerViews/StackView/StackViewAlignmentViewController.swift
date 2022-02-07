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

class StackViewAlignmentViewController: UIViewController {
    //label에 text 입력시 option + return 키를 하면 줄바꿈이 된다.
    //Inspector>StackView>First Baseline : Label의 첫번째줄 기준으로 정렬
    @IBOutlet weak var horizontalStackView: UIStackView!
    
    @IBAction func alignmentChanged(_ sender: UISegmentedControl) {
        let options : [UIStackView.Alignment] = [.fill, .top, .center, .bottom]
        UIView.animate(withDuration: 0.3) {
            self.horizontalStackView.alignment = options[sender.selectedSegmentIndex]
        }
        
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
}















