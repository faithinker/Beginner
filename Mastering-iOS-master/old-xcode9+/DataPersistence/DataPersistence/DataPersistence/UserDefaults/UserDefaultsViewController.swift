//UserDefault : plist 설정데이터와 같은 작은 데이터를 저장할 떄 사용하는 로컬 저장소이다.
//메모리(램) 일시 저장이 아니라 샌드박스내에 영구히 저장
//UserDefault는 전체 데이터를 메모리에 캐시로 저장
//NSCodingProtocol 채택 -> NSKeyedArchiver 아카이빙 -> 데이터 형식으로 저장

import UIKit

class UserDefaultsViewController: UIViewController {
   
   @IBOutlet weak var keyLabel: UILabel!
   
   @IBOutlet weak var valueLabel: UILabel!
   
   @IBOutlet weak var lastUpdatedLabel: UILabel!
   
    let key = "sampleKey"
    
   func updateDateLabel() {
      let formatter = DateFormatter()
      formatter.dateStyle = .none
      formatter.timeStyle = .medium
      
      lastUpdatedLabel.text = formatter.string(from: Date())
   }
   
   @IBAction func saveData(_ sender: Any) {
    //SingletonPattern
    //UserDefaults.standard.set("Hello", forKey: key)
    UserDefaults.standard.set(5.23, forKey: key)
   }
   
   @IBAction func loadData(_ sender: Any) { //get이 아니라 반환타입(float,string 등)이 첨자이다.
    //valueLabel.text = UserDefaults.standard.string(forKey: key) ?? "Not set"
    valueLabel.text = "\(UserDefaults.standard.integer(forKey: thresholdKey))"
    keyLabel.text = thresholdKey
    //UserDefault는 앱을 중지해도 데이터가 사라지지 않는다.
        //IntergerForkey 메소드는 저장된 값이 없거나 변환 할 수 없는 값이 저장되어 있다면 0을 리턴한다.
    //UserDefault는 최대한 에러안나게 동작하기 때문에 제대로 값을 읽어오는것이 중요하다.
   }
    @IBAction func removeData(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: key)
        
        valueLabel.text = "Remove Data"
        keyLabel.text = "Remove Key"
        //1. 삭제방법
        //UserDefaults.standard.set(nil, forKey: key)
        //2. 삭제방법2
        //UserDefaults.standard.removeObject(forKey: key)
    }
    //Noti 보낼때만 시간 레이블 뜸
    var token : NSObjectProtocol?
    
    deinit {
        if let token = token {
            NotificationCenter.default.removeObserver(token)
        }
    }
   override func viewDidLoad() {
      super.viewDidLoad()
    token = NotificationCenter.default.addObserver(forName: UserDefaults.didChangeNotification, object: nil, queue: OperationQueue.main, using: { [weak self] (noti) in
        self?.updateDateLabel()
    })
    
    
      //모든 값을 딕셔너리로 리턴해서 보여줌 디버깅 할때 유용
    //print(UserDefaults.standard.dictionaryRepresentation())
    //내가 설정한 것만 출력
    print(UserDefaults.standard.dictionaryWithValues(forKeys: [key]))
      
   }
}
