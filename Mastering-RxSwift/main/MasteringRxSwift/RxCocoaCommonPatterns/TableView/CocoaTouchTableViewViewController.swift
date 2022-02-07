
import UIKit

class CocoaTouchTableViewViewController: UIViewController {
   
   var nameList = appleProducts.map { $0.name }
   var productList = appleProducts
   
   @IBOutlet weak var listTableView: UITableView!
   
   let priceFormatter: NumberFormatter = {
      let f = NumberFormatter()
      f.numberStyle = NumberFormatter.Style.currency
      f.locale = Locale(identifier: "en_CA") //Ko_kr ja_JP en_CA
      
      return f
   }()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationItem.rightBarButtonItem = editButtonItem
   }
   
   override func setEditing(_ editing: Bool, animated: Bool) {
      super.setEditing(editing, animated: animated)
      
      if editing && !listTableView.isEditing {
         listTableView.setEditing(true, animated: true)
      } else {
         listTableView.setEditing(false, animated: true)
      }
   }
}

// delegate Pattern을 활용해서 필요한 기능 구현함
extension CocoaTouchTableViewViewController: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 2
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
      case 0:
         return nameList.count
      case 1:
         return productList.count
      default:
         return 0
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      switch indexPath.section {
      case 0:
         let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell", for: indexPath)
         
         cell.textLabel?.text = nameList[indexPath.row]         
         
         return cell
      case 1:
         let cell = tableView.dequeueReusableCell(withIdentifier: "productCell", for: indexPath) as! ProductTableViewCell
         
         let target = productList[indexPath.row]
         cell.categoryLabel.text = target.category
         cell.productNameLabel.text = target.name
         cell.summaryLabel.text = target.summary
         cell.priceLabel.text = priceFormatter.string(for: target.price)
         
         return cell
      default:
         fatalError()
      }
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      switch section {
      case 0:
         return "Standard Cell"
      case 1:
         return "Custom Cell"
      default:
         return nil
      }
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         switch indexPath.section {
         case 0:
            nameList.remove(at: indexPath.row)
         case 1:
            productList.remove(at: indexPath.row)
         default:
            fatalError()
         }
         
         tableView.deleteRows(at: [indexPath], with: .automatic)
      }
   }
   
   func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
      return true
   }
   
   func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
      if sourceIndexPath.section != proposedDestinationIndexPath.section {
         return sourceIndexPath
      }
      
      return proposedDestinationIndexPath
   }
   
   func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
      switch sourceIndexPath.section {
      case 0:
         let target = nameList.remove(at: sourceIndexPath.row)
         nameList.insert(target, at: destinationIndexPath.row)
      case 1:
         let target = productList.remove(at: sourceIndexPath.row)
         productList.insert(target, at: destinationIndexPath.row)
      default:
         fatalError()
      }
   }
}

// 각셀 터치하면 디버그 창에 이름 출력
extension CocoaTouchTableViewViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      switch indexPath.section {
      case 0:
         print(nameList[indexPath.row])
      case 1:
         print(productList[indexPath.row].name)
      default:
         break
      }
   }
   // 우측 -> 좌측 슬라이드시 dlete
   func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
    return .delete
   }
}
