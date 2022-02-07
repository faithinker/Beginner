// cell의 높이 설정
// Self sizing : cell에 표시되는 내용을 기반으로 높이를 자동으로 설정한다.
//
// Stroyboard > TableView 선택 > Size Inspector
// Row Height, Estimate, automatic
//
// Cliping : 글자가 짤리는 것
// Auto 일때는 뷰의 속성과 제약을 통해 cell의 높이를 결정한다.
// CustomCell을 직접 구현할 때는 높이를 정확히 계산 할 수 있도록 제약을 추가하는 것이 중요하다.
// cell의 높이가 고정되어 있다면 SelfSIzing을 끄고 고정된 셀 높이를 사용하는 것이 좋다. >> TableView가 계산을 하지 않아도 되기 때문에 스크롤 성능이 향상된다.
//
// Stroyboard의 Size Inspector의 Row Height, Estimate를 100으로 설정


import UIKit

class SelfSizingCellViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = [
        ("Always laugh when you can. It is cheap medicine.", "Lord Byron"),
        ("I probably hold the distinction of being one movie star who, by all laws of logic, should never have made it. At each stage of my career, I lacked the experience.", "Audrey Hepburn"),
        ("Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations.", "Steve Jobs")
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        listTableView.rowHeight = UITableViewAutomaticDimension
//        listTableView.estimatedRowHeight = UITableViewAutomaticDimension
    }
}



extension SelfSizingCellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let target = list[indexPath.row]
        cell.textLabel?.text = target.0
        cell.detailTextLabel?.text = target.1
        return cell
    }
}



extension SelfSizingCellViewController: UITableViewDelegate {
    // tableView에 설정되어 있는 rowHeight값이 무시된다.
    // 우선순위가 높다.
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        return UITableViewAutomaticDimension
    }
    
    // 코드로 rowHeight를 설정하는 경우 동일한 코드를 이 메소드에 설정해주면 스크롤 성능이 좀 더 향상된다.
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 100
        }
        return UITableViewAutomaticDimension
    }
}


























