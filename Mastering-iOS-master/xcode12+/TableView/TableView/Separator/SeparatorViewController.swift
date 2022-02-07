// Separator : Cell과 Cell 사이의 회색 Line. Cell을 시각적으로 구분.
// 컬러와 좌우여백 설정 제공. 높이는 설정 불가. cell을 활용해서 custom하게 만들어야 한다.
// StoryBoard > TableView > Inspector
//
// > Seprator :
// none : Custom하게 사용할 때 설정함
// Single Line : Default와 동일
// Single Line Etched : 더이상 사용않는 옵션
//
// > Separator Inset : Default(왼:15 오: 0),  Custom
// Inset을 계산하는 위치를 정함.
// From Cell Edges : Cell 경계를 기준으로 계산한다.
// From Automatic Inset : iOS가 환경에따라서 자동으로 계산한다.
//
// > Selction : 기본 여백을 활용해서 다른 것들과 겹치는 것을 방지할 때 주로 활용한다.
// Single Selection During Editing
// Multiple Selecion During Editing
//
// 개별 셀마다도 Separator 설정 가능. Automatic은 TableView의 설정 상속

import UIKit

class SeparatorViewController: UIViewController {
    
    let list = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.separatorStyle = .singleLine
        listTableView.separatorColor = UIColor.systemBlue
        listTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //Top Bottom 값은 무시된다.
        listTableView.separatorInsetReference = .fromCellEdges
        
    }
}




extension SeparatorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if indexPath.row == 1 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 0)
        }else if indexPath.row == 2 {
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        } else {  // 아래로 스크롤하면 다른 celld에도 적용됨 TableView가 재사용 메커니즘을 사용하기 때문이다.
            // listTableView의 separatorInset 속성을 할당함
            cell.separatorInset = listTableView.separatorInset
        }
        
        cell.textLabel?.text = list[indexPath.row % list.count]
        return cell
    }
}
























