// Reorder Control : 셀 순서를 변경하는 방법
// 순서 변경 기능 활성화, Cell Indentation, 최종 이동 위치 제어
//
// 시계앱 편집모드 -> Cell 드래그

import UIKit

class ReorderingViewController: UIViewController {
    
    var firstList = [String]()
    var secondList = [String]()
    var thirdList = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPad", "iPad mini", "iPhone 8", "iPhone 8 Plus", "iPhone SE", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    @objc func reloadTableView() {
        listTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.setEditing(true, animated: false)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reload", style: .plain, target: self, action: #selector(reloadTableView))
    }
}




extension ReorderingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return firstList.count
        case 1:
            return secondList.count
        case 2:
            return thirdList.count
        default:
            return 0
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = firstList[indexPath.row]
        case 1:
            cell.textLabel?.text = secondList[indexPath.row]
        case 2:
            cell.textLabel?.text = thirdList[indexPath.row]
        default:
            break
        }
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "First Section"
        case 1:
            return "Second Section"
        case 2:
            return "Third Section"
        default:
            return nil
        }
    }
    
    // 특정 셀만 move 허용하고 싶으면 indexPath 파라미터 통해서 true 지정
    // 기본값 false 이다.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Cell을 드래그해서 원하는 위치에 드롭하면 호출되는 메소드 : Reordering Content가 표시된다.
    // sourceIndexPath : 시작위치, destinationIndexPath : 드롭한 최종 위치
    // Cell 이동과 애니메이션만 처리해준다.
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        var target: String? = nil
        
        switch sourceIndexPath.section {
        case 0:
            target = firstList.remove(at: sourceIndexPath.row)
        case 1:
            target = secondList.remove(at: sourceIndexPath.row)
        case 2:
            target = thirdList.remove(at: sourceIndexPath.row)
        default:
            break
        }
        
        guard let item = target else { return }
        
        switch destinationIndexPath.section {
        case 0:
            firstList.insert(item, at: destinationIndexPath.row)
        case 1:
            secondList.insert(item, at: destinationIndexPath.row)
        case 2:
            thirdList.insert(item, at: destinationIndexPath.row)
        default:
            break
        }
    }
    
    // 왼쪽 여백 제거
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}




extension ReorderingViewController: UITableViewDelegate {
    // Cell 왼쪽에 Editing Control 만 시각적으로 표시되지 않을뿐 기능은 동작한다.
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .none
    }
    
    // Cell을 드래그 한다음 원하는 위치에서 Drop 할 때 호출된다.
    // sourceIndexPath로 처음 위치가 전달되고 proposedDestinationIndexPath로 최종 위치가 전달이 된다.
    // Cell이 이동하는 최종 위치는 이 메소드가 리턴하는 IndexPath에 따라 결정된다.
    // sourceIndexPath 이동을 제한할 때 사용한다.
    func tableView(_ tableView: UITableView, targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath, toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        // 첫번째 섹션에 드롭되는 것을 막는다.
        if proposedDestinationIndexPath.section == 0 {
            return sourceIndexPath
        }
        return proposedDestinationIndexPath
    }
}














