

import UIKit

class ImageViewController: UIViewController {
   
   var url: URL?
   
   @IBOutlet weak var imageView: UIImageView!
   
   @IBAction func close(_ sender: Any) {
      dismiss(animated: true, completion: nil)
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
    //Data형식으로 읽어와서 UIImage 생성
    if let url = url, let data = try? Data(contentsOf: url) {
        imageView.image = try? UIImage(data: data)
        navigationItem.title = url.lastPathComponent
    }
    
//    if let url = url {
//        imageView.image = try? UIImage(contentsOfFile: "url")
//    }
      
   }
}
