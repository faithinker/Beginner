
import UIKit
import RxSwift
import RxCocoa

// Delegate 패턴을 구현하지 않는다. 대신 옵저버블을 테이블뷰에 바인딩한다.
// MasteringRxSwift > Common > Models > Product.swift
// TableView > Cell > ProductTableViewCell.swift
//
// UITableView+Rx > items : 옵저버블을 테이블 뷰에 바인딩 할 때 사용함. 샘플코드 확인
// 오버로딩이 구현되어 있다. 커스텀 셀 VS 기본셀 사용하는 메소드가 달라짐
class RxCocoaTableViewViewController: UIViewController {
   
   @IBOutlet weak var listTableView: UITableView!
   
   let priceFormatter: NumberFormatter = {
      let f = NumberFormatter()
      f.numberStyle = NumberFormatter.Style.currency
      f.locale = Locale(identifier: "Ko_kr")
      
      return f
   }()
   
   let bag = DisposeBag()
   
    let nameObservable = Observable.of(appleProducts.map { $0.name})
    let productObservable = Observable.of(appleProducts)
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
    // 파라미터 클로저 : 테이블뷰 참조, row Index, 표시할 요소
      // #1
//      nameObservable.bind(to: listTableView.rx.items) { tableView, row, element in
//         let cell = tableView.dequeueReusableCell(withIdentifier: "standardCell")!
//         cell.textLabel?.text = element
//         return cell
//      }
//      .disposed(by: bag)
    
        // #2   #1과 같은 결과이지만 코드가 단순해짐
        // Cell idetifier를 재사용 Queue에서 Cell을 꺼낸 다음 Closure로 전달해준다.
        // 파라미터 클로저 : row Index, 표시할 요소, cell  세개가 전달됨
        // Cocoa Touch Framework와 비교하면 데이터소스를 연결하고 필수메소드를 구현할 필요가 없다.
        // 데이터를 방출하는 옵저버블과 테이블뷰를 바인딩하고 클로저에서 셀을 구성하는 것으로 끝난다.
        
//        nameObservable.bind(to: listTableView.rx.items(cellIdentifier: "standardCell")) { row, element, cell in
//            cell.textLabel?.text = element
//        }
//        .disposed(by: bag)
    
        // #3 상세정보 표시  클로저 파라미터 cell이 ProductTableViewCell 형식으로 타입캐스팅 됨. 연결된 아울렛에 접근할 때 별도의 타입 캐스팅이 필요없다.
        productObservable.bind(to:listTableView.rx.items(cellIdentifier: "productCell", cellType: ProductTableViewCell.self)) { [weak self] row, element, cell in
        
            cell.categoryLabel.text = element.category
            cell.productNameLabel.text = element.name
            cell.summaryLabel.text = element.summary
            cell.priceLabel.text = self?.priceFormatter.string(for: element.price)
        
        }
        .disposed(by: bag)
    // Cell을 탭하면 선택한 제품 이름을 console에 출력
    // touch 이벤트 구현 방법
    // Cocoa Touch Delegate 메소드를 구현
    // RxCocoa Extension에 추가되어 있는 옵저버블을 구독하면 된다.
    //
    // itemSelected : ControlEvent 형식으로 선언되어 있다. next 이벤트에 IndexPath가 저장되어 있는 것을 방출한다.
    // modelSelected : 실제 모델 데이터를 방출한다. 모델 타입을 파라미터로 전달한다.
            // ##1
//        listTableView.rx.modelSelected(Product.self)
//            .subscribe(onNext: { product in
//            print(product.name)
//        })
//        .disposed(by: bag)
//          // ##2 선택상태 바로제거 (회색화면 백그라운드 없앰)
//        listTableView.rx.itemSelected
//            .subscribe(onNext: { [weak self] indexPath in
//            self?.listTableView.deselectRow(at: indexPath, animated: true)
//        })
//        .disposed(by: bag)
//          // ##1과 ##2를 합침 itemSelected, modelSelected 모두 ControlEvent를 리턴함. IndexPath와 모델데이터를 방출하는데 항상 매칭되는 데이터를 방출한다.
    // 첫번째 셀 선택시 첫번째 인덱스패스와 첫번째 데이터를 방출함 두개의 ControlEvent를 zip 연산자로 방출 할 수 있다.
         Observable.zip(listTableView.rx.modelSelected(Product.self), listTableView.rx.itemSelected)
            .bind { [weak self] (product, indexPath) in
            self?.listTableView.deselectRow(at: indexPath, animated: true)
            print(product.name)
         }
         .disposed(by: bag)
    // 선택 이벤트를 처리하면서 데이터가 필요하다면 modelSelected. 인덱스 패스만 필요하다면 itemSelected. 둘다 필요하다면 zip 사용
    
    
    // Rxcocoa에서 CocoaTouch의 delegate 활용법.  지정하는 방식이 다름
    // cocoaTouch로 방식으로 delegate를 구현하면 RxCocoa로 구현한 방식은 더이상 동작하지 않는다.
//        listTableView.delegate = self
    
    // RxCocoa를 활용한 delegate를 직접 지정해야 delegate패턴을 Rx와 함께 사용 할 수 있다.
    listTableView.rx.setDelegate(self)
        .disposed(by: bag)
   }
}




extension RxCocoaTableViewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
    }
}

// Asignment : 두개의 섹션을 표시하고 삭제와 이동을 구현. RxCocoa가 제공하는 extension으로는 구현이 어렵다.(복잡해진다.)
//  delegate 패턴만으로 구현  VS RxDataSource 활용하기



