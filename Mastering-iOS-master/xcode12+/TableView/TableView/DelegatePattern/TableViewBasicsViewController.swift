// Table View OverView
// Cell : 개별항목 Cell의 너비는 테이블 뷰의 너비와 동일. 두개 이상의 Cell을 수평으로 배치하지 못한다.
// Scroll의 방향도 세로방향으로 고정되어 있다. CGAffineTransform을 사용해서 스크롤 방향을 바꿀수도 있지만 UICollectionView가 있기 때문에 안쓴다.
//
// Section : Cell이 그룹으로 분류된 것 cell이 0개 이상이다.(없을 수도 있다.)
// Table View는 Section과 Cell을 2차원 배열로 관리한다.
// Cell Position = SectionIndex + Cell(Row)Index 두개의 인덱스로 표현한다.
// IndexPath : Index를 처리할 때 사용함
//
// * Table View의 스타일 *
// Grouped Style : Section이 시각적으로 구분되어 있다. (기본)
// Plain Style : 여러 섹션으로 구분되어 있지만 그룹 스타일과 다르게 여백으로 구분되어 있지 않다.
// Header를 통해서 섹션을 구분한다. Footer도 존재한다.
// 헤더,푸터는 기본 레이블이다. 문자열만 지정가능. 크기 색상 폰트는 지정못하므로 커스텀하게 하고 싶으면 델리게이트 패턴에서 원하는 뷰를 리턴하는 방식으로 구현해야 한다.
// 스크롤하면 Header가 네비게이션 바 하단에 붙는다. 고정된다. (Floating, Sticky 모드가 혼합된 형태로 표시된다.)
//
// * Cell 세부적으로 보기 *
// Accessory View : Cell 오른쪽 symbol. Cell 선택시 어떤 작업을 하는지에 대한 Hint 제공
// Separator : Cell과 Cell사이에 있는 회색 실선. 컬러 설정, 좌우여백 지정이 가능함. 표시 X 기능도 제공
//
//
// https://developer.apple.com/documentation/uikit/views_and_controls/table_views
// https://developer.apple.com/documentation/uikit/uitableviewdatasource
// https://developer.apple.com/documentation/uikit/uitableview


// alt + 파일 클릭 : 파일 분할됨.
// Focus Mode
// StoryBoard > Table View + Table Cell 추가
// Prototype Cells : 새로운 Cell을 만드는 템플릿으로 사용된다. Cell의 설계도
// TableView에 마우스 오버 후 우클릭 하면 Connection Pannel : 연결할 수 있는 목록이 표시 됨
// Connection Pannel 오른쪽 동그라미 O : connection wall? 웰?
// datasource와 File's Own 을 연결한다.
// VC이 TableView에 DataSourcce가 되고 앞으로 TableView는 Data가 필요할 때마다 VC에게 요청한다.
// VC이 DataSource로 지정되었다.== TableView와 연결된 VC에서 프로토콜메소드를 구현
//
// *  TableView Inspector  *
// Style : Basic, Right Detail, Left Detail, Subtitle
// Selection : Cell을 선택했을 때 시각적으로 강조하는 방법을 표시한다.



// delegate를 통해 필요한 데이터를 요청한다.
// Datasource : Data를 공급하는 delegate



import UIKit

class TableViewBasicsViewController: UIViewController {
    
    let list = ["iPhone", "iPad", "Apple Watch", "iMac Pro", "iMac 5K", "Macbook Pro", "Apple TV"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension TableViewBasicsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //cell의 갯수
        print("#1 : \(#function)")
        return 100
//        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //cell 생성. cell에 표시할 데이터를 설정한 다음 리턴
        // 델리게이트 메소드로 전달된 indexPath를 그대로 사용. Cell의 위치를 저장하는 타입이다.
        // Cell의 위치는 Section Index와 Row Index의 조합으로 표현하고 각각 Section속성과 Row 속성에 저장되어 있다.
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath) as! UITableViewCell
        print("#2 : \(#function)", indexPath)
//        cell.textLabel?.text = list[indexPath.row]
        cell.textLabel?.text = "\(indexPath.section) - \(indexPath.row)"
        return cell
    }
    
    // 새로운 뷰를 생성할 때는 생성자를 사용한다.
    // 하지만 Cell을 생성할 때는 TableView에게 요청해야 한다.
    // TableView는 메모리를 효율적으로 사용하고 성능을 높이기 위해서 재사용 메커니즘을 사용한다.
    // TableView는 내부에 재사용 큐를 관리하면서 cell을 요청할 때마다 큐에 저장되어 있는 cell을 리턴해준다.
    
}

// #1은 테이블뷰가 초기화되거나 reload Data Method를 호출해서 전체데이터를 갱신할 때 호출된다.
// #2은 새로운 Cell이 화면에 표시되는 시점마다 호출된다.
// 스크롤해서 Cell이 사라지고 다시 나타나면 #2 함수가 다시 호출된다. 재사용하기 때문이다.
//
// cell을 100개를 보여주기 위해 100개를 모두 만들면 안된다.
// 표시하는 Cell의 갯수에 비례하여 메모리 용량과 성능저하 문제가 발생한다.
// 이러한 문제를 해결하기 위해 "재사용 메커니즘"을 사용한다.
// dequeueReusableCell을 호출할 때 재사용 큐를 확인한다. 리턴할 Cell이 있다면 그대로 리턴하고 Cell이 없다면 PrototypeCell을 기반으로 새로운 Cell을 만들어서 리턴한다.
// 테이블뷰가 처음 표시 될 때는 재사용 큐에 Cell이 없기 때문에 화면에 표시되는 Cell 숫자만큼 새로운 Cell을 만들어서 리턴한다.
// 미리 여유분으로 화면에 보이지 않는 cell 1~2개 정도를 버퍼에 추가해서 만들어 둔다.
//
// * 15분부터 재사용에 관한 설명 *
// 스크롤(다운)해서 사라진 Cell은 메모리에서 바로 제거되지 않고 재사용 큐에 추가된다.
// 스크롤 다운하면 20번 cell이 재사용큐에 이있던 cell을 재사용한다.
// 재사용한 Cell의 텍스트 레이블을 다시 새롭게 수정한 뒤 cell을 리턴하여 원하는 내용을 보여줄 수 있다.


// 화면에 보여줄 cell과 1~2개의 버퍼만 추가로 있으면 이론상으로 무한대의 Cell을 성능정하없이 보여줄 수 있다.
// 메모리 사용량도 줄어들고 오버헤드도 발생하지 않는다.
// 하지만 구현에 따라서 성능저하가 발생 할 수 있기 때문에 코드 최적화에 신경써야 한다.
// cellForRowAt는 최대한 가볍게 코딩해야 한다. 16msec 안에 모든것을 처리하고 리턴해야 한다.
// 파일로딩 네트워크다운로드를 동기방식으로 구현하면 스크롤 성능이 심각하게 낮아진다.


// TableView 구현순서
// 1. 스토리보드에서 TableView를 화면에 추가하고 오토레이아웃 추가
// 2. 새로운 Prototype Cell을 추가하고 원하는 방식으로 구상한다.
// 3. Prototype Cell의 idetifier를 설정
// 4. TableView의 Datasource를 지정 (file's Owner)
// 5. Datasource로 지정된 클래스에서 UITableViewDataSource를 지정해주고 필수메소드를 구현한다.






