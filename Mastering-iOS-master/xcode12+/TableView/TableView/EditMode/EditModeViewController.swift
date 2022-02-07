// 테이블 뷰 편집 모드를 구성하고 테이블 뷰를 편집하는 방법
// Edit Control, Reorder Control, Swipe to Delete(셀 스와이프), 셀 편집 모드 제어, Batch Updates
// Cell 왼쪽 추가, 삭제  | Cell오른쪽  Reorder

import UIKit

class EditModeViewController: UIViewController {
   
   var editingSwitch: UISwitch!
   @IBOutlet weak var listTableView: UITableView!
   
   var productList = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
   var selectedList = [String]()
   
   @objc func toggleEditMode(_ sender: UISwitch) {
//  listTableView.isEditing.toggle()
    listTableView.setEditing(sender.isOn, animated: true)
   }
   
   @objc func emptySelectedList() {
    productList.append(contentsOf: selectedList)
    selectedList.removeAll()
    
    // Section 자체를 업데이트 한다.
    listTableView.reloadSections(IndexSet(integersIn: 0...1), with: .automatic)
    
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      editingSwitch = UISwitch(frame: .zero)
      editingSwitch.addTarget(self, action: #selector(toggleEditMode(_:)), for: .valueChanged)
      
      let deleteButton = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(emptySelectedList))
      deleteButton.tintColor = UIColor.red
      
      navigationItem.rightBarButtonItems = [deleteButton, UIBarButtonItem(customView: editingSwitch)]
    
      editingSwitch.isOn = listTableView.isEditing
   }
}


extension EditModeViewController: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 2
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
      case 0:
         return selectedList.count
      case 1:
         return productList.count
      default:
         return 0
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      switch indexPath.section {
      case 0:
         cell.textLabel?.text = selectedList[indexPath.row]
      case 1:
         cell.textLabel?.text = productList[indexPath.row]
      default:
         break
      }
      
      return cell
   }
   
   func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
      switch section {
      case 0:
         return "Selected List"
      case 1:
         return "Product List"
      default:
         return nil
      }
   }
    
    // 특정 셀의 편집을 제한해야 할 때 사용
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    // 사용자가 삭제 또는 추가버튼을 탭하면 호출되는 메소드. editingStyle 어떤 버튼인지 확인 할 수 있다.
    // tableView는 실제 데이터와 화면에 표시된 실제 데이터가 일치해야 한다.
    // 셀을 추가하거나 삭제하기 전에 beginUpdates() 메소드를 호출하자. 그리고 추가삭제 행위가 끝나면 endUpdates() 호출
    // 배치 방식으로 구현함
    //
    // * Cell 추가 삭제 구현시 주의해야 할점 *
    // 배열에 저장된 데이터를 먼저 수정하고(105,106 Line) -> Cell을 추가하거나 삭제해야 한다. (109~113 Line)
    // 연관된 데이터를 먼저 업데이트하고 그다음 눈에 보이는 Cell을 업데이트 해야 한다.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .insert:
            let target = productList[indexPath.row]
            let insertIndexPath = IndexPath(row: selectedList.count, section: 0)
            
            selectedList.append(target)
            productList.remove(at: indexPath.row)
            
            // 블록방식 CompletionHandelr를 통해서 배치 업데이트가 완료된 다음에 원하는 코드를 실행하는 것도 가능하다.
            listTableView.performBatchUpdates { [weak self] in
                self?.listTableView.insertRows(at: [insertIndexPath], with: .automatic)
                self?.listTableView.deleteRows(at: [indexPath], with: .automatic)
            } completion: { (finished) in
            }

//             옛날방식 iOS 10 이하버전
//            listTableView.beginUpdates()
//
//            listTableView.insertRows(at: [insertIndexPath], with: .automatic)
//            listTableView.deleteRows(at: [indexPath], with: .automatic)
//
//            listTableView.endUpdates()
        case .delete:
            let target = selectedList[indexPath.row]
            let insertIndexPath = IndexPath(row: productList.count, section: 1)
            
            productList.append(target)
            selectedList.remove(at: indexPath.row)
            
            listTableView.performBatchUpdates { [weak self] in
                self?.listTableView.insertRows(at: [insertIndexPath], with: .automatic)
                self?.listTableView.deleteRows(at: [indexPath], with: .automatic)
            } completion: { (finished) in
                
            }

//            listTableView.beginUpdates()
//
//            listTableView.insertRows(at: [insertIndexPath], with: .automatic)
//            listTableView.deleteRows(at: [indexPath], with: .automatic)
//
//            listTableView.endUpdates()
        default:
           break
        }
    }
}


extension EditModeViewController: UITableViewDelegate {
    // Cell을 편집할 수 있다면 그다음에는 편집 스타일을 확인한다.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        switch indexPath.section {
        case 0:
            return .delete
        case 1:
            return .insert
        default:
            return .none
        // 편집모드로 전환은 되지만 Cell 왼쪽에 추가나 삭제버튼이 표시되지는 않는다. Reorder 순서 변경시에 주로 사용한다.
        }
    }
    
    // Swipe to Delete 모드가 시작되기 전에 호출된다. switch가 동적으로 변함
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        editingSwitch.setOn(true, animated: true)
    }
    // Swipe to Delete 모드가 종료된 이후에 호출된다.
    func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
        editingSwitch.setOn(false, animated: true)
    }
    
    // 다국어를 지원해야 한다면 번역된 문자열 리턴
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Remove"
    }
}



















