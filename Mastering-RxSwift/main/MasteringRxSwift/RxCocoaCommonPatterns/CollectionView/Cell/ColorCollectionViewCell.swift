
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
   @IBOutlet weak var hexLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
      hexLabel.text = ""
   }
   
   override func prepareForReuse() {
      super.prepareForReuse()
      
      hexLabel.text = ""
   }
}
