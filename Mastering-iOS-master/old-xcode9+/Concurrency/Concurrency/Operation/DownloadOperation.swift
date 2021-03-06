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

class DownloadOperation: Operation {
   let target: PhotoData
   
   init(target: PhotoData) {
      self.target = target
      
      super.init()
   }
   
   override func main() {
      autoreleasepool {
         print(self, "Start")
         
         defer {
            if isCancelled {
               print(self, "Cancelled")
            } else {
               print(self, "Done")
            }
         }
         
         guard !Thread.isMainThread else { fatalError() }
         
         guard !isCancelled else { print(self, "Cancelled"); return }
         
         do {
            let data = try Data(contentsOf: target.url)
            
            guard !isCancelled else { print(self, "Cancelled"); return }
            
            if let image = UIImage(data: data) {
               let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
               UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
               let frame = CGRect(origin: CGPoint.zero, size: size)
               image.draw(in: frame)
               let resultImage = UIGraphicsGetImageFromCurrentImageContext()
               UIGraphicsEndImageContext()
               
               guard !isCancelled else { print(self, "Cancelled"); return }
               
               target.data = resultImage
            }
         } catch {
            print(error.localizedDescription)
         }
         //?????? ???????????? ?????? ?????? ?????????, ???????????? ??????X
         Thread.sleep(forTimeInterval: TimeInterval(arc4random_uniform(4)))
      }
   }
   
   override func cancel() {
      super.cancel()
      //???????????? ?????? ??????
      print(self, "Cancel")
   }
}























