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

class ImagePickerViewController: UIViewController {
    
    lazy var images: [UIImage] = {
        return (0...6).compactMap { UIImage(named: "slot-machine-\($0)") }
    }()
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func shuffle(_ sender: Any?) {
        let first = picker.selectedRow(inComponent: 0)
        let second = picker.selectedRow(inComponent: 1)
        let third = picker.selectedRow(inComponent: 2)
        var number = [Int]()
        
        for i in 0..<3 {
            number.append(Int.random(in: 7...13))
            picker.selectRow(number[i], inComponent: i, animated: true)
        }
        //세개 모두 똑같을시 나오는 코드, 실패함 다시해야함
        if first == second && first == third {
            print("Jackpot!")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //또는 스토리보드 inspector에서 config 해도 됨
        picker.isUserInteractionEnabled = false
        
        picker.reloadAllComponents()  //code refresh
        shuffle(picker) //first state is mix
    }
}


extension ImagePickerViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return images.count * 3
    }
    
    
}

extension ImagePickerViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        if let imageView = view as? UIImageView {
            imageView.image = images[row % images.count]
            return imageView
        }
        
        let imageView = UIImageView()
        imageView.image = images[row % images.count]
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 60
    }
}
//    override func reloadInputViews() {
//        images
//    }


//1. 시작 시점을 두번째로 8번
//2.  터치 못하게 disenabled
//3. 이미지를 크게
//4. shuffle 터치시 무작위로 움직임




