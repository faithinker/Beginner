

import UIKit

class ImageViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //UIImgw(named: ) 형식을 선호한다.
        let img1 = UIImage(named: "delivery-man")
        let img2 = #imageLiteral(resourceName: "enterprise")
        imageView.image = img1
        
        
        if let ptSize = img1?.size, let scale = img1?.scale {
            let px = CGSize(width: ptSize.width * scale, height: ptSize.height * scale)
            print("Image Size : \(ptSize) \n Image PixelSize : \(px)")
        }
        
        //UIImage Image Literal은 불변객체이다.
        //bitmap데이터에 직접 접근 할 수 없고 CG, CI를 사용해야한다.
        img1?.cgImage  //CoreGraphics
        img1?.ciImage  //CoreImage
        //네트워크를 통해 송수신하거나 파일저장을 하고 싶으면 binary 형태로 바꿔야 한다.
        
        //압축률 0.0 ~ 1.0 값 작을수록 크기 ↓ 클수록 이미지 품질 ↑
        let pngData = img1?.pngData()
        let jpgData = img1?.jpegData(compressionQuality: 0.5)
    }
}













