//사용자 선택에서 Allow Notification을 비활성화 시킨 상태에서도 LocalNoti를 예약 할 수 있다.
//Noti를 전달하는 시점에도 비활성화 상태이면, 계속해서 목록이 유지되고 설정이 활성화 되는 시점에 다시 전달한다.
//따라서 사용자가 Noti 폭탄 맞게되거나 Noti의 내용이 잘못 될 수도 있다.
//Noti가 활성화 되있는 상태에서도 사용자가 입력한 값에 따라서 예약되어 있는 Noti가 만료 될 수 있다.
//예약된 LocalNoti를 주기적으로 확인하고 만료된 Noti가 있다면 삭제해야 한다.


//NotiCenter에 추가되어 있는 Noti를 테이블뷰에 표시하고  NotiCenter에 있는 Noti삭제 기능을 구현

import UIKit
import UserNotifications

class DeliveredNotificationsTableViewController: UITableViewController {
   var deliveredNotifications = [UNNotification]()
   
   func refresh() {
      deliveredNotifications.removeAll()
    //NotiCenter에 추가되어 있는 Noti 중에서 현재 앱으로 전달된 모든 Noti를 클로저로 전달한다.
    //Local과 Push가 모두 포함되어 있다.
    UNUserNotificationCenter.current().getDeliveredNotifications { [weak self] (notifications) in
        //클로저의 파라미터는 메소드의 끝단어를 사용한다. getDeliveredNotifications = > notifications
        
        //pendingNoti의 scheduleNotifications을 갖고옴?
        self?.deliveredNotifications = notifications
        
        DispatchQueue.main.async {
            self?.tableView.reloadData()
        }
        
    }
   }   
  
   override func viewDidLoad() {
      super.viewDidLoad()
      
      refresh()
   }
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return deliveredNotifications.count
   }
   
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = deliveredNotifications[indexPath.row]
      cell.textLabel?.text = target.request.content.title
      cell.detailTextLabel?.text = target.request.identifier
      
      return cell
   }
    //삭제 구현
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let target = deliveredNotifications[indexPath.row]
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [target.request.identifier])
        deliveredNotifications.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    //추가되어 있는 Noti 중에서 사용자가 이미 앱을 확인한 내용이 포함 되어 있을 수도 있다. 그럴때는 자동으로 삭제하도록 구현하면
    //사용자경험 UX를 높일 수 있다.
}
