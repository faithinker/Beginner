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

class ImageAnimationViewController: UIViewController {
    //Image는 데이터가 크기 때문에 원래 크기와 맞춰주는게 좋다. 성능이 좋아진다.
    //imageview Inspector>view>contentMode : Aspect Fill
    // > > Drwaing : Clips to Bounds 언체크 frame 벗어난 부분도 보여줌
    //imageview의 크기를 직접 지정해야 autolayout시 문제 발생 X
    
    //imageView는 gif 지원안하지만 image sequence를 사용하여 gif와 비슷하게 사용함
    //image sequence에 포함된 모든 image는 size와 scaleVector가 동일해야한다.
    let images = [
        UIImage(systemName: "speaker")!,
        UIImage(systemName: "speaker.1")!,
        UIImage(systemName: "speaker.2")!,
        UIImage(systemName: "speaker.3")!
    ]
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func startAnimation(_ sender: Any) {
        imageView.startAnimating()
    }
    
    @IBAction func stopAnimation(_ sender: Any) {
        if imageView.isAnimating {
            imageView.stopAnimating()
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.animationImages = images

        imageView.animationDuration = 1.0
        // 이미지보여지는 시간 = 시간/이미지갯수, 0.0이 기본값
        imageView.animationRepeatCount = 3 //0이 기본값 무한반복
    }
}
