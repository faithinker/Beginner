
import UIKit
import CoreGraphics //BitmapContext is Required

class ImageResizingViewController: UIViewController {
  //iOS Image Resizing, Swift Image Resizing
    //조금 어렵다.
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let targetImage = UIImage(named: "photo") {
            let size = CGSize(width: targetImage.size.width/5, height: targetImage.size.height/5)
            //imageView.image = resizingWithImageContext(image: targetImage, to: size)  //보통 이걸 많이 사용함
            imageView.image = resizingWithBitmapContext(image: targetImage, to: size)
        }
    }
}




extension ImageResizingViewController {
    func resizingWithImageContext(image: UIImage, to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
        //그릴 수 있는 그림판  size, 투명도, 확대(배수)
        
        let frame = CGRect(origin: CGPoint.zero, size: size)
        image.draw(in: frame)
        
        let resultImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        //context에 그려져있는 이미지를 실제 이미로 바꿔야 한다.
        
        return resultImage
    }
}



extension ImageResizingViewController {
    func resizingWithBitmapContext(image: UIImage, to size: CGSize) -> UIImage? {
        guard let cgImage = image.cgImage else {
            return nil
        }
        let bpc = cgImage.bitsPerComponent
        let bpr = cgImage.bytesPerRow
        let colorSpace = cgImage.colorSpace!
        let bitmapInfo = cgImage.bitmapInfo
        
        //first param = rendering pointer
        guard let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: bpc, bytesPerRow: bpr, space: colorSpace, bitmapInfo: bitmapInfo.rawValue) else {
            return nil
        }
        //image quality config
        context.interpolationQuality = .high
        
        let frame = CGRect(origin: .zero, size: size)
        context.draw(cgImage, in: frame)
        guard let resultImage = context.makeImage() else {
            return nil
        }
        return UIImage(cgImage: resultImage)
    }
}













