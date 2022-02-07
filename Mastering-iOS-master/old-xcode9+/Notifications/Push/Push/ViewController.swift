//
//  ViewController.swift
//  Push
//
//  Created by 김주협 on 2020/12/09.

//Target Config에서 Provisininf에서 생성한 ID를 bundle Idetifier에서 똑같이 맞춰 줘야 한다.

// 10m 20sec  11m 10sec response 파라미터가 중요하다.

//Config - Capabilities - Noti : Check, Background Modes : Remote Notifications

//{
//  "aps": {
//    "alert": {
//      "title": "Hello",
//      "body": "Notification Hub"
//    },
//    "badge" : 123,
//    "sound" : "default"
//  },
//  "data" : "other data like or dislike"
//}

//{
//  "aps": {
//    "content-available": 1,
//    "badge" : 123
//  },
//  "data" : "Silent Push"
//}

import UIKit

extension NSNotification.Name {
    static let DataDidReceive = NSNotification.Name(rawValue: "DataDidReceiveNotification")
}

class ViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    
    @objc func updateLabel() {
        DispatchQueue.main.async {
            self.label.text = UserDefaults.standard.string(forKey: "data")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabel()
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: NSNotification.Name.DataDidReceive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateLabel), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)

    }

}




//전달된 payload를 새로운 payload로 바꿀 수 있다.  암호화된 데이터(개인 정보)를 원본 데이터로 교체
//File > New > Target > Noti Service Extension, 만약 경고창 표시되면 activate 클릭하면 된다.
//Deployment Target을  Project하고 동일시 한다.


//banner tittle에 Hello [modified] 로 뜸
//{
//  "aps": {
//    "alert": {
//      "title": "Hello",
//      "body": "Notification Service Extension"
//    },
//    "badge" : 3,
//    "sound" : "default",
//    "mutable-content":1
//  },
//  "url" : "https://goo.gl/image"
//  "enc-data" : "end2dd"
//}
//enc-data  base64로 인코딩된 문자열
