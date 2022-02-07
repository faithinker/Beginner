// iOS11 부터 Row Action이 Swipe Action으로 변경되었다. Cell을 좌우로 스와이프 해보면 나타남.
// 예시 : 메일 앱 좌우 스와이프
//
// Row Action과 달리 이미지를 표시할 수 있고 Full Swipe Action을 처리 할 수 있다.
// Swipe Action을 활용해서 셀 양쪽에 액션 버튼을 추가하고 이벤트를 처리하는 방법
// Swipe Action으로 셀 양쪽에 액션 추가, Swipe Action 커스터마이징, Full Swipe Action


import UIKit

class SwipeActionViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var list = [("Always laugh when you can. It is cheap medicine.", "Lord Byron"), ("I probably hold the distinction of being one movie star who, by all laws of logic, should never have made it. At each stage of my career, I lacked the experience.", "Audrey Hepburn"), ("Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations.", "Steve Jobs")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}



extension SwipeActionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row].0
        cell.detailTextLabel?.text = list[indexPath.row].1
        
        return cell
    }
}



@available(iOS 11.0, *)
extension SwipeActionViewController: UITableViewDelegate {
    // 사용자가 Cell에서 오른쪽으로 스와이프하면 호출되는 함수
    // 액션을 실행했을 때 전달할 클로저
    // code 컬러와 백그라운드 컬러는 바꿀 수 없지만 백그라운드 컬러는 바꿀 수 있다.
    // 충분한 높이가 확보되야만 이미지와 텍스트가 함께 표시된다. 그렇지 않으면 이미지민 보여진다.
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let unreadAction = UIContextualAction(style: .normal, title: "읽지않음") { action, view, completion in
            
            completion(true)
        }
        
        unreadAction.backgroundColor = UIColor.systemBlue
        unreadAction.image = UIImage(systemName: "envelope")
        
        let configuration = UISwipeActionsConfiguration(actions: [unreadAction])
        
        return configuration
    }
    
    // 사용자가 Cell을 왼쪽으로 스와이프하면
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "휴지통") { (action, view, completion) in
            
            self.list.remove(at: indexPath.row)
            self.listTableView.deleteRows(at: [indexPath], with: .automatic)

            completion(true)
        }
        
        deleteAction.backgroundColor = UIColor.systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        
        let flagAction = UIContextualAction(style: .normal, title: "깃발") { (action, view, completion) in
            
            completion(true)
        }
        
        flagAction.backgroundColor = UIColor.systemOrange
        flagAction.image = UIImage(systemName: "flag")
        
        let menuAction = UIContextualAction(style: .normal, title: "기타") { (action, view, completion) in
            completion(true)
        }
        
        menuAction.backgroundColor = UIColor.systemYellow
        menuAction.image = UIImage(systemName: "ellipsis")
        
        let configuration  = UISwipeActionsConfiguration(actions: [deleteAction, flagAction, menuAction])
        
        // Cell 전체를 스와이프 했을 때(Full Swipe) 첫번째 액션이 자동으로 실행된다.
        configuration.performsFirstActionWithFullSwipe = true
        
        return configuration
    }
}















