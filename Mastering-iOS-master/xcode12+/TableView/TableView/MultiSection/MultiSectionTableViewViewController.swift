// 아이폰 설정 - photo 들어가면 나오는 tableView와 비슷하게 만든다.
// 스토리보드 우클릭 connection wall -> Scence Doc
// DataSource -> Files Owner


import UIKit

class MultiSectionTableViewViewController: UIViewController {
    
    let list = PhotosSettingSection.generateData()
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    // 두번째 스위치
    @objc func toggleHideAlbum(_ sender: UISwitch) {
        print(#function)
        list[1].items[0].on.toggle()
    }
    
    @objc func toggleAutoPlayVideos(_ sender: UISwitch) {
        print(#function)
        list[2].items[0].on.toggle()
    }
    
    @objc func toggleSummarizePhotos(_ sender: UISwitch) {
        print(#function)
        list[2].items[1].on.toggle()
    }
    
    @objc func toggleShowHolidayEvents(_ sender: UISwitch) {
        print(#function)
        list[3].items[1].on.toggle()
    }
    
    func showActionSheet() {
        let sheet = UIAlertController(title: nil, message: "Resetting will allow previously blocked people, places, dates, or holidays to once again be included in new Memories.", preferredStyle: .actionSheet)
        
        let resetAction = UIAlertAction(title: "Reset", style: .destructive, handler: nil)
        sheet.addAction(resetAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        sheet.addAction(cancelAction)
        
        if let pc = sheet.popoverPresentationController {
            if let tbl = view.subviews.first(where: { $0 is UITableView }) as? UITableView {
                if let cell = tbl.cellForRow(at: IndexPath(row: 0, section: 3)) {
                    pc.sourceView = cell
                    pc.sourceRect = tbl.frame
                }
            }
        }
        
        present(sheet, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // 씬이 호출되기 직전에 표시된다. 다른화면으로 갔다가 돌아올때도 호출된다.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 회색강조된 셀을 다시 흰색으로 변환
        if let selected = listTableView.indexPathForSelectedRow {
            listTableView.deselectRow(at: selected, animated: true)
        }
    }
}


extension MultiSectionTableViewViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return list.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list[section].items.count //각각의 리스트에 있는 섹션의 아이템(셀)들을 리턴한다.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // section 데이터에 저장된 배열에서 현재 Cell에 표시할 데이터를 가져온다.
        let target = list[indexPath.section].items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: target.type.rawValue, for: indexPath)
        
        cell.textLabel?.text = target.title
        switch target.type {
        case .disclosure:
            cell.imageView?.image = UIImage(systemName: target.imageName ??  "")
        case .switch:
            if let switchView = cell.accessoryView as? UISwitch {
                switchView.isOn = target.on
                
                // 연결되어있는 메소드 해제
                switchView.removeTarget(nil, action: nil, for: .valueChanged)
                
                // 스위치 탭하면 #selector 메소드 호출됨
                if indexPath.section == 1 && indexPath.row == 0 { // 1번째 섹션 0번째 Cell album
                    switchView.addTarget(self, action: #selector(toggleHideAlbum(_:)), for: .valueChanged)
                }
                if indexPath.section == 2 && indexPath.row == 0 {
                    switchView.addTarget(self, action: #selector(toggleAutoPlayVideos(_:)), for: .valueChanged)
                }
                if indexPath.section == 2 && indexPath.row == 1 {
                    switchView.addTarget(self, action: #selector(toggleSummarizePhotos(_:)), for: .valueChanged)
                }
                if indexPath.section == 2 && indexPath.row == 1 {
                    switchView.addTarget(self, action: #selector(toggleShowHolidayEvents(_:)), for: .valueChanged)
                }
            }
            
        case .action:
            break
        case .checkmark:
            cell.accessoryType = target.on ? .checkmark : .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section 데이터에 저장되어 있는 header 문자열을 리턴
        return list[section].header
    }
    
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return list[section].footer
    }
    // 스토리보드 TableView 클릭 > Inspector
    // backgorundColor : System Grouped BackgroundColor
}

extension MultiSectionTableViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 && indexPath.row == 0 {
            showActionSheet()
            tableView.deselectRow(at: indexPath, animated: true) // 선택 상태 제거
        }
        
        // 나의 해결책
        if indexPath.section == 4, let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .checkmark
        }
        
        // 강의 내용
        //TableView가 선택한 Cell을 리턴했다면 Datasource부터 새로운 값을 바꿔야 한다.
//        if indexPath.section == 4 {
//            if let cell = tableView.cellForRow(at: indexPath) {
//                list[indexPath.section].items[indexPath.row].on.toggle()
//                cell.accessoryType = list[indexPath.section].items[indexPath.row].on ? .checkmark : .none
//            }
//        }
        // cell 체크시 다른것도 untoggle 되게 만들어라.
    }
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if indexPath.section == 4, let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
        }
    }
}




















