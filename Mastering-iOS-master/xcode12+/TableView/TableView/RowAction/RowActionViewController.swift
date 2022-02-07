// Row Action을 활용해서 셀 오른쪽에 액션 버튼을 추가하고 이벤트를 처리하는 방법
// Row Action으로 기본 삭제 버튼 대체. Row Action 커스터마이징

import UIKit
import MessageUI

class RowActionViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    var list = ["iMac Pro", "iMac 5K", "Macbook Pro", "iPad Pro", "iPhone X", "Mac mini", "Apple TV", "Apple Watch"]
    
    
    func sendEmail(with data: String) {
        guard MFMailComposeViewController.canSendMail() else {
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setSubject("Test Mail")
        composer.setMessageBody(data, isHTML: false)
        
        present(composer, animated: true, completion: nil)
    }
    
    
    func sendMessage(with data: String) {
        guard MFMessageComposeViewController.canSendText() else {
            return
        }
        
        let composer = MFMessageComposeViewController()
        composer.messageComposeDelegate = self
        composer.body = data
        
        present(composer, animated: true, completion: nil)
    }
    
    
    func delete(at indexPath: IndexPath) {
        list.remove(at: indexPath.row)
        listTableView.deleteRows(at: [indexPath], with: .automatic)
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}



extension RowActionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = list[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return indexPath.row != 0
    }
}



// iOS13 이상부터는 UITableViewRowAction이 아니라 UIContextualAction으로 구현하는 것이 좋다.
extension RowActionViewController: UITableViewDelegate {
    // Cell을 왼쪽으로 Swipe하면 호출되는 메소드. 기본으로 표시되는 삭제버튼을 대체한다.
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let emailAction = UITableViewRowAction(style: .default, title: "Email") { [weak self] (action, indexPath) in
            if let data = self?.list[indexPath.row] {
                self?.sendEmail(with: data)
            }
        }
        emailAction.backgroundColor = UIColor.black
        // Font 컬러(흰색 고정), 글자 크기는 지정 못함
        
        let messageAction = UITableViewRowAction(style: .normal, title: "Message") { [weak self] (action, index) in
            if let data = self?.list[indexPath.row] {
                self?.sendMessage(with: data)
            }
        }
        
        let deleteAction  = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
            self?.delete(at: indexPath)
        }
        return [emailAction, messageAction, deleteAction]
        // Swipe해서 보면 배열에 저장된 순서대로 오른쪽에서 부터 표시된다.
    }
}




extension RowActionViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}




extension RowActionViewController: MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}


















