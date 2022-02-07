
import UIKit

class MultipleSelectionViewController: UIViewController {
    
    let list = Region.generateData()
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    @objc func report() {
        if let indexPathList = listTableView.indexPathsForSelectedRows {
            let selected = indexPathList.map {
                list[$0.section].countries[$0.row]
            }.joined(separator: "\n")
            
            showAlert(with: selected)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Report", style: .plain, target: self, action: #selector(report))
    }
}



// 선택했으면 체크마크 표시하고 우상단의 Report 버튼 누르면 선택한 목록을 경고창에 표시
extension MultipleSelectionViewController: UITableViewDataSource {
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

extension MultipleSelectionViewController: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
//    }
//    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
//        tableView.cellForRow(at: indexPath)?.accessoryType = .none
//    }
}



class MultipleSelectionCell: UITableViewCell {
    // 선택상태가 바뀔때마다 호출된다. Cell이 재사용되는 시점에도 호출된다.
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
    }
    
}










