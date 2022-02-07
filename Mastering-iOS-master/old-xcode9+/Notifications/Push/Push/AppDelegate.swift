//
//  AppDelegate.swift
//  Push
//
//  Created by 김주협 on 2020/12/09.


import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    //14 25sec

    //silent push notification = background update notification 새로운 내용이 있을때 백그라운드에서 앱을 업데이트 할 때 사용


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //이 키가 존재한다면 pushnoti를 이용해 앱을 실행 한 것이고 payload에 포함된 데이터를 활용해서 초기화코드를 구현 할 수 있다.
        if let payload = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {

        }
        PushManager.shared.setUp()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    //silent Push가 전달되면 이 메소드가 호출되고 userInfo 파라미터에 payload의 내용이 전달된다.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        //print("#1 \(#function)",userInfo, seperator: "\n")
    }
    //새로운 데이터가 있다.newData 없다. noData 처리과정에서 오류라면 failed
}
//VC에서 옵저버를 추가하고 앱이 백그라운드여도 레이블 내용 변경하게 코드 구현한다.


//앱이 종료(terminated) 상태에서 push 보내면 백그라운드에서 실행하게 되고 didReceiveRemoteNotification 메소드를 호출한다.
//그리고 그 함수 안의 completionHandler를 호출하면 실행이 자동으로 종료된다.


//category push 방법


extension AppDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        PushManager.shared.registerDeviceToken(token: deviceToken)
    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetechCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("#1 \(#function)", userInfo, separator: "\n")
        
        if let data = userInfo["data"] as? String {
            UserDefaults.standard.set(data, forKey: "data")
            UserDefaults.standard.synchronize()
        }
        if application.applicationState == .active {
            NotificationCenter.default.post(name: NSNotification.Name.DataDidReceive, object: nil)
        }
        completionHandler(UIBackgroundFetchResult.newData) //.noData
    }
}
