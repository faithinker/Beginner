// UITableViewController 서브클래싱, Dynamic Prototype과 Static Cells 비교
// 테이블 뷰에 고정된 데이터 표시, Static Cells에서 Outlet 연결
//
// 테이블 뷰 컨트롤러를 활용해서 테이블 뷰를 조금 더 쉽게 구현하는 방법
//
// VC에서 TableView를 구현할 때는 프로토콜 채용하고 extension으로 메소드 직접 구현했다.
// UITableViewController는 상위 구현을 오버라이딩 하는 방식으로 구현한다.
//
//
// ** Storyboard TableView -> Attribute Inspector -> Content **
// Dynamic Prototype TableView : 프로토타입 셀을 구성하고 재사용메커니즘으로 Cell을 표시한다.
// 적은 메모리로 수많은 Cell을 표시 할 수 있다. 하지만 항상 Datasource를 구현해야 한다.
//
// Static Cell Table View : TableView에 표시되는 데이터가 고정되어 있을 경우
// Document Outline에서 TableView -> Section 클릭 후 Inspector : cell 숫자와 header,footer 표현 가능
//
// 다이나믹 프로토콜에서 Delegate로 구현했던 기능을 속성 설정으로 구현 가능함.
//
//
// 이전방식 새로운 클래스를 만듦 -> Class와 Cell을 연결, Switch를 아울렛으로 연결 -> 메소드 작성
// VC에 바로 연결


import UIKit

class MyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = "\(indexPath)"

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
