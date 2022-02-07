//
//  PushManager.swift
//  Push
//
//  Created by 김주협 on 2020/12/11.
//

import UIKit
import UserNotifications

class PushManager: NSObject {
    static let shared = PushManager()
    
    let hub : SBNotificationHub
    
    private override init() {
        hub = SBNotificationHub(connectionString: hubConnectingString, notificationHubPath: hubName)
        super.init()
    }
    func setupCategory() {
        let confirmAction = UNNotificationAction(identifier: "ACTION_CONFIRM", title: "Confirm Request", options: [])
        let deleteAction = UNNotificationAction(identifier: "ACTION_DELETE", title: "Delete Request ", options: [])
        
        let friendRequestCategory = UNNotificationCategory(identifier: "CATEGORY_FRIEND_REQUEST", actions: [confirmAction, deleteAction], intentIdentifiers: [], options: [])
        
        UNUserNotificationCenter.current().setNotificationCategories([friendRequestCategory])
    }
    func setup() {
        let center = UNUserNotificationCenter.current()
        center.delegate = self
        center.requestAuthorization(options: [.sound, .badge, .alert]) { (granted, error) in
            if granted && error == nil {
                //APNS로 기기를 호출하고 델리게이트 메소드를 통해 결과를 알려준다.
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }
    func registerDevideToken(token: Data) {
        hub.registerNative(withDevice: token, tags: nil) { (error) in
            if let error = error {
                print("Reg Error : \(error.localizedDescription)")
            }else {
                prin("Reg OK")
            }
        }
    }
}

//UNUserNotification Center Delegate Protocol을 채용하도록 선언

extension PushManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if let aps = notification.request.content.userInfo["aps"] as? [AnyHashable: Any], let _ = aps["content-available"] {
            completionHandler([])
            return
        }
        print("#2 \(#function)", notification.request.content.userInfo, separator: "\n")
        completionHandler([.badge])
        
        if let data = notification.request.content.userInfo["data"] as? String {
            UserDefaults.standard.self(data, forkey:"data")
            UserDefaults.standard.synchronize()
            NotificationCenter.default.post(name: NSNotification.Name.DataDidReceive, object: nil)
        }
        completionHandler([.badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("#3 \(#function)", response.notification.request.content.userInfo, separator: "\n")
        
        if let data = response.notification.request.content.userInfo["data"] as? String {
            UserDefaults.standard.set(data, forKey: "data")
            UserDefaults.standard.synchronize()
            
            NotificationCenter.default.post(name: NSNotification.Name.DataDidReceive, object: nil)
        }
        
        switch response.actionIdentifier {
        case "ACTION_CONFIRM":
            print("confirm")
        case "ACTION_DELETE":
            print("delete")
        default:
            print("default")
        }
        
        completionHandler()
    }
}


//두개의 Scheme 사용하기 : 개발자용 / 배포용

//Project -> targets : 복제 만들기, 복제된 info.plist 삭제
//원래 타깃 - Build Settings - info.plist 더블클릭 복사 => 새 타깃 붙여넣기
//원래 타깃 - Build Settings - product module Name => 새 타깃 더블클릭 이름 똑같이 쓰기
//Scheme - Managee Scheme
