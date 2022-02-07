// TableHeaderView, SectionHeader, Cell, SectionFooter,  TableFooterView
// 모두 다르다. 혼동하지 말자.
//
// TableHeaderView : Storyboard로 구현. Header에 Search Bar를 추가하고 검색 기능 구현
// TableFooterView : 코드로 구현. Footer에 Label을 추가하고 데이터 출력
//
// SearchBar의 delegate를 VC와 연결. SearchBar는 스크롤 되면 같이 사라진다.

import UIKit

class HeaderFooterViewViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPad", "iPad mini", "iPhone 8", "iPhone 8 Plus", "iPhone SE", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
    var filteredList = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPad", "iPad mini", "iPhone 8", "iPhone 8 Plus", "iPhone SE", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
    
    
    lazy var resultLabel: UILabel = { [weak self] in
        var frame = self?.view.bounds ?? .zero
        frame.size.height = 50
        
        let lbl = UILabel(frame: frame)
        lbl.textAlignment = .center
        lbl.textColor = UIColor.white
        lbl.backgroundColor = UIColor.gray
        return lbl
    }()
    
    
    @objc func handle(notification: Notification) {
        switch notification.name {
        case NSNotification.Name.UIKeyboardWillShow:
            if let frame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
                var inset = listTableView.contentInset
                inset.bottom = frame.height
                listTableView.contentInset = inset
            }
        case NSNotification.Name.UIKeyboardWillHide:
            var inset = listTableView.contentInset
            inset.bottom = 0
            listTableView.contentInset = inset
        default:
            break
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}




extension HeaderFooterViewViewController: UISearchBarDelegate {
    func filter(with keyword: String) {
        if keyword.count > 0 {
            filteredList = list.filter { $0.contains(keyword) }
        } else {
            filteredList = list
        }
        
        listTableView.reloadData()
        resultLabel.text = "\(filteredList.count) result(s) found"
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(with: searchText)
    }
    
    // 검색이 시작되는 시점에 호출
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        listTableView.tableFooterView = resultLabel
    }
    
    // 검색이 종료된 다음 호출
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = nil
        resultLabel.text = "0 result(s) found"
        listTableView.tableFooterView = nil
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        filter(with: searchBar.text ?? "")
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        filteredList = list
        listTableView.reloadData()
        
        searchBar.resignFirstResponder()
    }
}




extension HeaderFooterViewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = filteredList[indexPath.row]
        cell.textLabel?.text = target
        
        return cell
    }
}













