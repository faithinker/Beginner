
import UIKit

class CustomizingSegmentedControlViewController: UIViewController {
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var titleField: UITextField!
    
    @IBAction func insertSegment(_ sender: Any) {
        
    }
    
    @IBAction func removeSegment(_ sender: Any) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let normalImage = UIImage(named: "segment_normal")
        let selectedImage = UIImage(named: "segment_selected")
        
        segmentedControl.setBackgroundImage(normalImage, for: .normal, barMetrics: .default)
        segmentedControl.setBackgroundImage(selectedImage, for: .selected, barMetrics: .default)
        
        
        var img = UIImage(named: "segment_normal_normal")
        print(img?.size)
        segmentedControl.setDividerImage(img, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        
        let halfWidth = (img!.size.width - 20) / 3.0
        var offset = UIOffset(horizontal: halfWidth, vertical: 0.0)
        segmentedControl.setContentPositionAdjustment(offset, forSegmentType: .left, barMetrics: .default)
        
        img = UIImage(named: "segment_normal_selected")
        segmentedControl.setDividerImage(img, forLeftSegmentState: .normal, rightSegmentState: .selected, barMetrics: .default)
        
        img = UIImage(named: "segment_selected_normal")
        segmentedControl.setDividerImage(img, forLeftSegmentState: .selected, rightSegmentState: .normal, barMetrics: .default)
        
        
        
    }
}


















