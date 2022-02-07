
import UIKit
import RxSwift
import RxCocoa

// UICollectionView + Rx 
// items : 옵저버블과 collectionView를 바인딩
// cellIdentifier, cellType
//  다양한 Delegate Wrapper 

class RxCocoaCollectionViewViewController: UIViewController {
   
   let bag = DisposeBag()
   
   @IBOutlet weak var listCollectionView: UICollectionView!
    
   //CocoaTouch에서는 배열에 저장된 데이터를 CollectionView에 표시한다. RxCocoa에서는 Observable을 CollectionView에 바인딩한다.
    let colorObservable = Observable.of(MaterialBlue.allColors)
    
   override func viewDidLoad() {
      super.viewDidLoad()
      // RxCocoa에서는 DataSource와 Delgate를 직접 연결하지 않는다.
    // 클로저 파라미터 : itemIndex, modelData, CollectionViewCell
        colorObservable.bind(to: listCollectionView.rx.items(cellIdentifier: "colorCell", cellType: ColorCollectionViewCell.self)) { index, color, cell in
        
            // 재사용 큐에서 cell을 꺼내고 리턴하는 것은 자동으로 처리된다.
            cell.backgroundColor = color
            cell.hexLabel.text = color.rgbHexString
        }
        .disposed(by: bag)
        // cell을 선택하면 컬러값을 출력
        listCollectionView.rx.modelSelected(UIColor.self)
            .subscribe(onNext: { color in
            print(color.rgbHexString)
        })
        .disposed(by: bag)
    
    // delegate 직접 지정했기 때문에 Rxcocoa가 제대로 동작하지 않는다.
//    listCollectionView.delegate = self
    listCollectionView.rx.setDelegate(self)
        .disposed(by: bag)
   }
}

// Cell Size 지정
extension RxCocoaCollectionViewViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
         return CGSize.zero
      }
      
      let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
      return CGSize(width: value, height: value)
   }
}


// Assignment : 두개 이상의 섹션을 표시하거나 편집기능을 구현해야 한다면 Rxcocoa만으로는 부족하다. RxDatasource Library와 delegate 패턴을 적절히 조합해서 사용한다.
