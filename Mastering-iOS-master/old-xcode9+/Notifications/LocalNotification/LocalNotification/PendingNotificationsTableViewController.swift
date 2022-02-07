//예약된 Noti를 삭제하는 씬 
import UIKit
import UserNotifications

class PendingNotificationsTableViewController: UITableViewController {
   var pendingNotifications = [UNNotificationRequest]()
   
    
   func refresh() {
      pendingNotifications.removeAll()
      
    UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self](requests) in
        self?.pendingNotifications = requests
        
        //예약된 목록을 바로 리턴하지 않는다. 클로저를 구현하고 파라미터를 통해 받아야 한다.
        //파라미터로 저장된 속성을 pendingNotification으로 저장하고 tableView를 업데이트한다.
        //클로저는 백그라운드에서 실행되기 때문에 reloadData() 메소드는 메이큐에서 호출해야 한다.
        
        DispatchQueue.main.async {
            self?.tableView.reloadData()
        }
    }
   }
   //UserNotificationCenter를 통해 예약된 목록을 가져오고 특정 항목을 삭제하는 코드
   @objc func scheduleNotifications() {
      for interval in 1...3 {
         let content = UNMutableNotificationContent()
         content.title = "Notification Title #\(interval)"
         content.body = "Notification Body #\(interval)"
         
         let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval*3), repeats: false)
        //예약된 LocalNotification을 관리 할 때는 식별자를 사용하기 때문에 가독성 높은 것을 설정하는 것이 좋다.
         let request = UNNotificationRequest(identifier: "nid22\(interval)", content: content, trigger: trigger)
         
         UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
      }
      
      refresh()
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleNotifications))
      //Scene에 진입하거나 앱이 foreground로 전활 될 떄 refresh()메소드 호출
      refresh()
   }
   
   override func numberOfSections(in tableView: UITableView) -> Int {
      return 1
   }
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return pendingNotifications.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = pendingNotifications[indexPath.row]
      cell.textLabel?.text = target.content.title
      cell.detailTextLabel?.text = target.identifier
      
      return cell
   }
    
    //UITableView Data Method 편집을 처리하는 메소드 // 예약취소 메소드
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let target = pendingNotifications[indexPath.row]
            //notification 삭제
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [target.identifier])
            
            //저장된 path 삭제, 테이블 Cell 삭제
            pendingNotifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        
    }
}
