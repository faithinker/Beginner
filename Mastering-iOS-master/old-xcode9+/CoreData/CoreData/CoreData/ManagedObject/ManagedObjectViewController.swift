//  DB 2번째 강의 중요.  취업준비 때문에 계속 끊겨서 봤다. 한번더 공부 필요
//
//  Managed Object, Managed Object Context
//  CoreData는 모든 데이터를 Entity 단위로 처리한다.
//  Context에서 처리하는 실제 데이터는 Managed Object이다.
//  일반 객체와 달리 CoreData가 LifeCycle을 관리한다.
//
//  모델 파일에 정의되되어 있는 엔티티는 NSManagedObject클래스와 1대1로 매핑한다.
//  관리객체에 필요한 모든 기능이 구현되어 있다.
//  하지만 대부분 서브클래싱을 통해 엔티티클래스를 생성한다. 코드의 가독성 속도가 좋아짐
//
//
//  Managed Object Context 가장 중요한 객체
//
//  대부분의 작업은 Context에서 처리되고 ManagedObject는 항상 Context 내부에 존재한다.
//  새로운  Managed Object를 생성 할 때는 항상 Context를 지정해야 한다.
//  생성된 Managed Object는 컨텍스트에 등록된다.
//  영구저장소에 저장된 데이터를 가져오면 동일한 값을 가진 Managed Object복사본이 생성되고
//  Context에 등록된다. 어떤적업이든 시작은 Managed Object를 Context에 등록하는 것이다.
//
//  Context에서 실행되는 작업은 영구저장소에 실시간으로 반영되지 않는다.
//  Context에 시작된 작업을 영구저장소에 반영하려면 반드시 Context를 저장해야 한다.
//
//  newEntity.setValue(name, forkey:"name")
//  문제점
//  1.전달되는 값을 컴파일과 앱 실행 시점에 검증하지 못한다.
//  2. attribute 이름을 문자열로 전달해야 한다.
//
// NSManagedObject => SubClassing => attribute에 접근하는 커스텀속성을 선언하는 방식이 좋다.


import UIKit

class ManagedObjectViewController: UIViewController {
   
   var list = [PersonEntity]()
   var token: NSObjectProtocol!
  
   @IBOutlet weak var listTableView: UITableView!
  
  
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // Data Read -> List Array Save ->  tableView Reload()
      list = DataManager.shared.fetchPerson()
      listTableView.reloadData()
    
      // 새로운 Person Data를 추가하면 newPersonDidInsert Noti가 전달됨
      // Noti가 전달되면 Data를 다시 읽어온 다음, tableView를 Reload한다.
      token = NotificationCenter.default.addObserver(forName: PersonComposeViewController.newPersonDidInsert, object: nil, queue: .main, using: { [weak self] (noti) in
        self?.list = DataManager.shared.fetchPerson()
        self?.listTableView.reloadData()
      })
      
   }
   
   deinit {
      NotificationCenter.default.removeObserver(token)
   }
}


extension ManagedObjectViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return list.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
    //이름과 나이를 출력
      let person = list[indexPath.row]
      cell.textLabel?.text = person.name
      cell.detailTextLabel?.text = "\(person.age)"
    
    
      return cell
   }
   
   func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      switch editingStyle {
      case .delete:
        let person = list.remove(at: indexPath.row)
        DataManager.shared.delete(entity: person)
        tableView.deleteRows(at: [indexPath], with: .automatic)
      default:
         break
      }
   }
}


extension ManagedObjectViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      //Cell을 선택했을 때 새로운 Composer 씬을 만들고 편집 대상을 전달한다.
    let person = list[indexPath.row]
    
    if let nav = storyboard?.instantiateViewController(withIdentifier: "ComposeNav") as? UINavigationController, let composeVC  = nav.viewControllers.first as? PersonComposeViewController {
      composeVC.target = person
      present(nav, animated: true, completion: nil)
    }
   }
}
