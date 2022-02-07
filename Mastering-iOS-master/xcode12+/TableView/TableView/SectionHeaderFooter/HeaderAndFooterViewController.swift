// Section Header와 Footer를 설정하는 방법
// Model > Region.swift
//
//
//
// Custom Header Footer 설정
// 1. UITableView Header Footer View를 사용
// 2. 첫번째 방식을 SubClassing 하고 UI를 직접 구성하는 방법

import UIKit

class SectionHeaderAndFooterViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = Region.generateData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let headerNib = UINib(nibName: "CustomHeader", bundle: nil)
        // cell을 등록할 때 사용하는 메소드
//        listTableView.register(<#T##nib: UINib?##UINib?#>, forCellReuseIdentifier: <#T##String#>)
        // Header를 등록할 때 사용하는 메소드
        listTableView.register(headerNib, forHeaderFooterViewReuseIdentifier: "header")
        // UITableViewHeaderFooterView.self
        // 아래에 설정한 HeaderView 대신 CustomHeaderView를 사용함
    }
}



extension SectionHeaderAndFooterViewController: UITableViewDataSource {
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
    
    // Header에 표시할 함수
    // Storyboard > TableView > Inspector :
    // plained 스크롤 해도 고정되고 다른 Header로 교체됨, Grouped 스크롤 하면 Cell과 함께 스크롤 됨(사라짐)
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return list[section].title
//    }
}




extension SectionHeaderAndFooterViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        //dequeueReusableHeaderFooterView : 재사용 큐에 있는 뷰를 리턴하거나 새로운 뷰를 생성한다음 리턴한다.
        // dequeueReusableCell이 아니다.
        // 표시할 텍스트만 설정한다.
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as! CustomHeaderView
        // as! CustomHeaderView 부분 추가됨
        
        headerView.titleLabel.text = list[section].title
        headerView.countLabel.text = "\(list[section].countries.count)"
        
//        headerView?.textLabel?.text = list[section].title
//        headerView?.detailTextLabel?.text = "lorem Ipsum"
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 80
    }
    
    //Header를 표시하기 직전에 호출된다.
    // 표시할 텍스트에 대한 시각적인 속성을 설정하는 코드
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        if let headerView = view as? UITableViewHeaderFooterView {
//    //        headerView?.backgroundColor = .secondarySystemFill
//            headerView.textLabel?.textColor = .systemBlue
//            headerView.textLabel?.textAlignment = .center
//
//            // 위의 것을 주석처리하고 이렇게 하는 이유는 Swift가 backgroundColor에 직접 접근해서 수정하지 말고
//            // 새로운 뷰를 만들어서 색깔을 할당하라고 권고하기 때문이다.
//            if headerView.backgroundView == nil {
//                let v = UIView(frame: .zero)
//                v.backgroundColor = .secondarySystemFill
//                v.isUserInteractionEnabled = false //header의 터치 막음
//                headerView.backgroundView = v
//            }
//
//        }
//    }
}
// New > UserInterface > View(Empty가 아님)
// Attribute Inspector > Size > FreeForm
// Size Inspector > Height 80
// Home Indicator가 표시되기 때문에 지우기 위해 하단 Device Configuration을 선택하고 홈버튼 있는 모델 선택
// Secondary SystemBackgroundColor로 설정














