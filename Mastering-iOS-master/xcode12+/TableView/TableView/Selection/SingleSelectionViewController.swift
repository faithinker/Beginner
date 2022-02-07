// TableView에서 선택 이벤트를 처리하는 방법
// 단일 선택과 다중 선택 구현, 선택 이벤트 처리, 선택 제어, Highlighted 상태 활용
//
// StoryBoard > TableView > Inspector > Selection : No/Single/Multiple Selection. Cell 선택안함, 한개, 여러개(2개이상)
// Editing > No/Single/Multiple Selection During Editing : 편집상태에서도 검색기능이 필요한지를 선택하는 옵션
//
// Cell > Inspector > Selection : 선택시 강조색. Default 또는 None을 주로 사용함 Custom : SelectedBackgroundView


// 대략 4~5시간만 더 하면 TableView 강의가 끝남

import UIKit

class SingleSelectionViewController: UIViewController {
    
    let list = Region.generateData()
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    func selectRandomCell() {
        let section = Int.random(in: 0 ..< list.count)
        let row = Int.random(in: 0..<list[section].countries.count)
        let targetIndexPath = IndexPath(row: row, section: section)
        
        // 특정 셀을 선택할 때 사용하는 메소드
        listTableView.selectRow(at: targetIndexPath, animated: true, scrollPosition: .top)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) { [weak self] in
            let first = IndexPath(row: 0, section: 0)
            self?.listTableView.scrollToRow(at: first, at: .top, animated: true)
        }
    }
    
    
    func deselect() {
        if let selected = listTableView.indexPathForSelectedRow {
            listTableView.deselectRow(at: selected, animated: true)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showMenu(_:)))
    }
    
    
    @objc func showMenu(_ sender: UIBarButtonItem) {
        let menu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let selectRandomCellAction = UIAlertAction(title: "Select Random Cell", style: .default) { (action) in
            self.selectRandomCell()
        }
        menu.addAction(selectRandomCellAction)
        
        let deselectAction = UIAlertAction(title: "Deselect", style: .default) { (action) in
            self.deselect()
        }
        menu.addAction(deselectAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        menu.addAction(cancelAction)
        
        if let pc = menu.popoverPresentationController {
            pc.barButtonItem = sender
        }
        
        present(menu, animated: true, completion: nil)
    }
}




extension SingleSelectionViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].countries.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = list[indexPath.section].countries[indexPath.row]
        cell.textLabel?.text = target
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return list[section].title
    }
}



// Cell의 상태에 따라 TextColor 바꾸기
// Cell 상태에 따라 디자인을 업데이트 하거나 이벤트를 처리해야 할 때 활용하는 방법
// 선택상태와 강조상태
extension SingleSelectionViewController: UITableViewDelegate {
    // Cell이 선택되기 전에 호출. 특정 셀의 선택을 금지할 때 사용
//    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
//        if indexPath.row == 0 {
//            return nil
//        }
//        // 터치하면 선택금지되지만 길게 Press 하면 회색 바뀜
//        // TableViewCell은 터치 이벤트가 전달되면 짧은시간동안 강조상태로 전달되었다가 선택상태로 전환되거나 일반상태로 돌아간다.
//
//        return indexPath
//    }
//    // Cell이 선택된 직후에 호출. 선택된 셀의 위치
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let target = list[indexPath.section].countries[indexPath.row]
//        showAlert(with: target)
//
//        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
//    }
//    // 선택이 된 Cell에서 선택이 해제되기 직전에 호출된다.
//    func tableView(_ tableView: UITableView, willDeselectRowAt indexPath: IndexPath) -> IndexPath? {
//        return indexPath
//    }
//    // 선택되었던 Cell이 선택 해제된 후에 호출됨
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        print(#function, indexPath)
//        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .systemGray3
//    }
//    // Cell을 강조하기 전에 호출된다. true 강조됨 false 강조 안됨
//    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
//        return indexPath.row != 0
//    }
//    // Cell이 강조된 다음에 호출
//    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
//    }
//    // 강조효과가 제거된 다음 호출
//    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .systemGray3
//    }
}




extension UIViewController {
    func showAlert(with value: String) {
        let alert = UIAlertController(title: nil, message: value, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
    }
}


// CustomCell CodeUICell 코드로 구현
// Cell의 선택상태는 이미지 뷰에도 영향을 준다.
class SingleSelectionCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabel?.textColor = .systemGray3
        textLabel?.highlightedTextColor = .black
    }
    // 선택상태가 바뀔때마다 호출됨
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    // 강조상태가 바뀔때마다 호출됨
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        
    }
}






