
import UIKit

class CocoaTouchURLSessionViewController: UIViewController {
   
   @IBOutlet weak var listTableView: UITableView!
   
   var list = [Book]()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      DispatchQueue.global().async {
         self.fetchBookList()
      }
   }

   /// URL 세션을 활용해서 네트워크 요청을 전달하고 있다.
   func fetchBookList() {
      DispatchQueue.main.async {
         UIApplication.shared.isNetworkActivityIndicatorVisible = true
      }
      
      guard let url = URL(string: booksUrlStr) else {
         fatalError("Invalid URL")
      }
      
      let session = URLSession.shared
      
      let task = session.dataTask(with: url) { [weak self] (data, response, error) in
         defer {
            DispatchQueue.main.async { [weak self] in
               self?.listTableView.reloadData() // 최종적으로 TableView를 Reload 하고 있다.
               UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
         }
         // 전달된 응답을 검증하고 있다.
         if let error = error {
            print(error)
            return
         }
         
         guard let httpResponse = response as? HTTPURLResponse else {
            print("Invalid Response")
            return
         }
         
         guard (200...299).contains(httpResponse.statusCode) else {
            print(httpResponse.statusCode)
            return
         }
         
         guard let data = data else {
            fatalError("Invalid Data")
         }
         // JSONDecoder를 통해 파싱하고 있다.
         do {
            let decoder = JSONDecoder()
            let bookList = try decoder.decode(BookList.self, from: data)
            
            if bookList.code == 200 {
               self?.list = bookList.list
            } else {
               self?.list = [Book]()
            }
         } catch {
            print(error)
         }
      }
      task.resume()
   }
}

extension CocoaTouchURLSessionViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return list.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = list[indexPath.row]
      cell.textLabel?.text = target.title
      cell.detailTextLabel?.text = target.desc
      
      return cell
   }
}
