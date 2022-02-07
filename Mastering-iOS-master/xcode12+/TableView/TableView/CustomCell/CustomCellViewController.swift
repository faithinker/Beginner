// Model > WorldTime.swift

import UIKit


class CustomCellViewController: UIViewController {
    
    
    let list = WorldTime.generateData()
    
    @IBOutlet weak var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // interfaceFile이 저장되어있는 bundle을 전달. 동일한 파일에 포함되어 있다면 nil 전달
        // Nib File에서 Cell을 구성할 때는 Identifier를 설정할 필요가 없다.
        // 나중에 Cell을 등록할때 Identifier와 함께 등록하기 때문이다.
        let cellNib = UINib(nibName: "SharedCustomCell", bundle: nil)
        listTableView.register(cellNib, forCellReuseIdentifier: "SharedCustomCell")
    }
}

// UIView로 리턴해서 UILabel로 타입캐스팅함


extension CustomCellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    // viewWithTag 방식은 스토리보드 속성에서 설정하고 각각의 코드도 설정해줘야 한다. => 귀찮다. 실수 할 수 있다.
    // outlet 연결 방식을 많이 사용한다. 연결대상이 중요하다.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SharedCustomCell", for: indexPath) as! TimeTableViewCell  //withIdentifier: "customCell" 다운캐스팅함
        
        
        let target = list[indexPath.row]
        
        // Cell이 복잡 해질수록 더 유리한 방식임 타입캐스팅 필요없고 tag 신경 안써도 됨
        cell.dateLabel.text = "\(target.date), \(target.hoursFromGMT)시간"
        cell.locationLabel.text = target.location
        cell.ampmLabel.text = target.ampm
        cell.timeLabel.text = target.time
        
        //  ** Cell 높이 설정 **
        // Stroyboard에서 CustomCell 클릭 > Size Inspector > RowHeight 100
        // PrototypeCell을 구성할 때 사용하는 높이이고 Runtime시에는 다른 값(Code Rowheight)보다 우선 순위가 낮다.
        // Self Sizing 활성화(TableView SizeInspector의 Automatic), TableView에 설정되어 있는 높이  Delegate 표현하는 높이 그리고 Cell 높이 이렇게 총 4가지 방식이 있다.
        
//        let target = list[indexPath.row]
//
//        if let dateLabel = cell.viewWithTag(100) as? UILabel {
//            dateLabel.text = "\(target.date), \(target.hoursFromGMT)시간"
//        }
//        if let locationLabel = cell.viewWithTag(200) as? UILabel {
//            locationLabel.text = target.location
//        }
//        if let ampmLabel = cell.viewWithTag(300) as? UILabel {
//            ampmLabel.text = target.ampm
//        }
//        if let timeLabel = cell.viewWithTag(400) as? UILabel {
//            timeLabel.text = target.time
//        }
        
//        cell.textLabel?.text = target.location
//        cell.detailTextLabel?.text = "\(target.date) \(target.time)"
        
        return cell
    }
}
