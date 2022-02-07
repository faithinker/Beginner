//  https://developer.apple.com/documentation/coredata/nsfetchrequest

import UIKit
import CoreData

// fetch request를 비동기 방식으로 처리하면 blocking되지 않는다.
// backgroundContext를 사용하지 않더라도 문제가 어느정도 해결된다.
//
// AsyncFetching 진행상황을 파악 할 수 있고 직접 취소 할 수 있다.
// 단 key-Value 옵저버에 대한 이해가 필요하다.

class AsyncFetchingTableViewController: UITableViewController {
   
   var list = [NSManagedObject]()
   
    
    
   @IBAction func fetch(_ sender: Any?) {
      let request = NSFetchRequest<NSManagedObject>(entityName: "Employee")
//    제너릭 타입이기 때문에 형식 파라미터 지정해야 한다.
//    첫번째 파라미터 기본 패치 리퀘스트를 기반으로 생성한다.
//    fetchRequest와 연관된 속성을 직접 지정하지 않고 전달된 fetchRequest를 비동기 방식으로 실행한다.
      let asyncRequest = NSAsynchronousFetchRequest(fetchRequest: request) {   (result) in
          guard let list = result.finalResult else { return }
          self.list = list
          self.tableView.reloadData()
      }

  
      // fetch request가 완료될 때 실행할 코드
      let sortByName = NSSortDescriptor(key: "name", ascending: true)
      request.sortDescriptors = [sortByName]

      do { // 동기 메소드 request가 완료될 때까지 리턴하지 않는다.
         // list = try DataManager.shared.mainContext.fetch(request)
        
        // execute는 fetch 메소드와 달리 비동기 메소드이다.
        // fetch를 CoreData에 저장한 다음 바로 리턴한다.
        // 이제 블로킹 당할 일이 없다.
        try DataManager.shared.mainContext.execute(asyncRequest)
         tableView.reloadData()
      } catch {
         fatalError(error.localizedDescription)
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      fetch(nil)
      tableView.reloadData()
   }
}


extension AsyncFetchingTableViewController {
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      cell.textLabel?.text = list[indexPath.row].value(forKey: "name") as? String
      
      return cell
   }
}
