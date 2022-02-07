// SectionIndexTitle : 연락처 > 오른쪽 조그마한 알파벳, 숫자 =>해당섹션으로 빠르게 이동한다.
// UITableViewDataSource에 구현되어있는 메소드 구현하면 됨

import UIKit

class SectionIndexViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = Region.generateData()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Storyboard > TableView  > Inspector > Section Index
        
        // sectionIndexTitle이 표시되는 프레임에 백그라운드 컬러이다.
        listTableView.sectionIndexColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1) //UIColor.systemBlue
        // Drag를 하고 있지 않은 normal 상태에서 표시된다.
        listTableView.sectionIndexBackgroundColor = UIColor.secondarySystemBackground
        // Drag를 하고 있는 상태에서 표시되는 색깔
        listTableView.sectionIndexTrackingBackgroundColor = UIColor.systemYellow
        
        
    }
}




extension SectionIndexViewController: UITableViewDataSource {
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
    
    // 문자열 배열을 리턴하면 SectionIndexTitle로 표시된다.
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//        return list.map { $0.title }
        return stride(from: 0, to: list.count, by: 2)
            .map { list[$0].title }
    }
    
    // 일부만 표시 : 높이가 확보되지 않는다면 title 수를 줄여서 표시해야 한다. 또는 디자인 때문
    // TableView는 Title과 실제 Section사이의 연관성을 파악하지 못한다.
    // 표시되는 Title 순서에 맞게 그냥 다음 섹션으로 이동할 뿐이다.

    // sectionIndexTitle을 드래그한 다음에 실제로 Section으로 이동하기 직전에 호출된다.
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index * 2
    }
}











