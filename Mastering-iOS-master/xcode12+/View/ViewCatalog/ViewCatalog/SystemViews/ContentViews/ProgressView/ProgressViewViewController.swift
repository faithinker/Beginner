
import UIKit

class ProgressViewViewController: UIViewController {
    //ProgressView>Style : Bar toolbar나 Navigation에 추가 할 때 사용한다.
    //progress : 진행상태 0.0 ~ 1.0
    
    @IBOutlet weak var progress: UIProgressView!
    
    
    @IBAction func update(_ sender: Any) {
        //progress.progress = 0.7
        progress.setProgress(0.8, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progress.progress = 0.0
        progress.tintColor = UIColor.systemGray
        progress.progressTintColor = .systemRed
    }
    
}
