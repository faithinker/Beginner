//설정데이터는 기본값을 가지고 있다. 기본값을 저장하는 패턴을 구현해본다.
// 기본값은 앱을 설치하고 최초로 한번만 실행해야 한다. 그렇지 않으면 앱 실행 할때마다 매번 설정해야 한다.

import UIKit

let thresholdKey = "thresholdKey" //가상의 설정데이터를 설정
let initialLaunchKey = "initialLaunchKey" //최초 실행시점 파악


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?


   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
    //키의 값이 없으면 (존재하지 않으면) => 한번만 등록시, 이런패턴 자주쓴다.
    if !UserDefaults.standard.bool(forKey: initialLaunchKey) {
        let defaultsKey = [thresholdKey: 123] as [String : Any]
        
        //register로 다수의 기본값을 한번에 등록 할 수 있다.
        UserDefaults.standard.register(defaults: defaultsKey)
        UserDefaults.standard.set(true, forKey: initialLaunchKey)
        
        print("Initial Launch")
    }
      
      
      return true
   }
}

