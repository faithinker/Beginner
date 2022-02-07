// TableViewCell > Content View > Label, Image Button  ETC..


import UIKit

class TableViewCellViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    let list = ["iPhone", "iPad", "Apple Watch", "iMac Pro", "iMac 5K", "Macbook Pro", "Apple TV"]
    
    // cell을 선택한 상태에서 새로운 화면으로 전환되기 직전에 호출한다. label 정보fmf 새로운 View로 넘김
    // segue를 실행시킨 cell이 sender 파라미터로 전달된다.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let cell = sender as? UITableViewCell {
            if let indexPath = listTableView.indexPath(for: cell) {
                if let vc = segue.destination as? DetailViewController {
                    vc.value = list[indexPath.row]
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 특정 좌표를 지정. 지정한 좌표에 cell이 있다면 indexPath를 리턴 없다면 nil
//        listTableView.indexPathForRow(at: <#T##CGPoint#>)
        // Frame 지정 indexPath를 배열로 리턴
//        listTableView.indexPathsForRows(in: <#T##CGRect#>)
        // 화면에 표시되어 있는 Cell을 배열로 리턴
//        listTableView.visibleCells
        // 화면에 표시된 cell에 indexPath가 필요하다면  사용
//        listTableView.indexPathsForVisibleRows
        
    }
}



extension TableViewCellViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        cell.imageView?.image = UIImage(systemName: "star")
        return cell
    }
}



extension TableViewCellViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 파라미터로 전달된 IndexPath에 Cell이 있는지 확인하고 Cell이 있다면 그 Cell을 리턴해준다.
        // 없으면 nil 리턴
        if let cell = tableView.cellForRow(at: indexPath) {
            print(cell.textLabel?.text ?? "") //Nil 합병연산자
        }
    }
    
    
    // background 옵션 설정 : 모든 Cell에 코드로 적용한다면 awakeFromNib으로 설정
    // cell마다 background를 개별적으로 설정 : cellForRowAt 메소드에서 구현 또는 WillDisplay forRowAt 메소드에서 구현
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row.isMultiple(of: 2) {
            cell.backgroundColor = UIColor.systemBackground
        } else {
            cell.backgroundColor = UIColor.secondarySystemBackground
        }
    }
}

















