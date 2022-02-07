//
//  NotificationViewController.swift
//  LocalNotificationContentExtension
//
//  Created by 김주협 on 2020/12/16.
//  Copyright © 2020 Keun young Kim. All rights reserved.
//



import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //rootView를 제약한다고 해서 이미지 사이즈 조정되지 않는다. 높이 제약을 직접 추가하거나 VC의 속성을 통해 원하는 크기를 지정해야 한다.
        preferredContentSize = CGSize(width: view.bounds.width, height: 200)
    }
    //payload에 포함된 데이터를 출력한다.
    func didReceive(_ notification: UNNotification) { //ContentExtension의 필수메소드
        //파라미터를 통해 payload가 전달된다.
        
        
        //attachment 존재 유뮤, 존재시 첫번째 어태치먼트 상수에 저장
        guard let imageAttachment = notification.request.content.attachments.first else { return }
        //imageAttachment에는 프로젝트에 저장된 이미지 url이 있다. extension에서 이 url을 직접 접근할 수 없기 때문에
        //startAccessingSecurityScopedResource() 함수를 호출해야 한다.
        if imageAttachment.url.startAccessingSecurityScopedResource() {
            if let imageData = try? Data(contentsOf: imageAttachment.url) {
                imageView.image = UIImage(data: imageData)
            }
            imageAttachment.url.stopAccessingSecurityScopedResource()
        }
    }

    
    //Noti의 AlertAction을 터치하면, AppDelegate에서 구현한 Delegate메소드가 호출된다.
    //Extension으로는 액션이 전달되지 않는다. didReceive completionHandler 함수를 써야 모든 액션이 Extension으로 전달된다.
    func didReceive(_ response: UNNotificationResponse, completionHandler completion: @escaping (UNNotificationContentExtensionResponseOption) -> Void) {
        //기존 레이블에 이모티콘 추가
        let title = response.notification.request.content.title
        
        switch response.actionIdentifier {
        case "ACTION_LIKE":
            titleLabel.text = "\(title) 👍"
        case "ACTION_DISLIKE":
            titleLabel.text = "\(title) 👎"
        default:
            break
        }
        
        //closure 호출 액션을 처리하는 방법을 파라미터로 전달해야 한다.
        //dismiss : 앱으로 액션을 전달하지 않고 배너를 닫는다.
        //dismissAndForwardAction : 앱으로 액션을 전달하고 배너를 닫는다.
        //doNotDismiss : 배너를 닫지않고 액션만 실행한다. 액션에 따라서 커스텀UI를 동적으로 변경할 때 쓰는 메소드 ex)카톡
        completion(.doNotDismiss)
        
    }
}
