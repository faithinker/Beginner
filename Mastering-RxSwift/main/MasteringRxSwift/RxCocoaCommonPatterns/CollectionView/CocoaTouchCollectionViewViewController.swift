
import UIKit

class CocoaTouchCollectionViewViewController: UIViewController {
   
   let list = MaterialBlue.allColors
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      
   }
}

extension CocoaTouchCollectionViewViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return list.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell
      
      cell.backgroundColor = list[indexPath.item]
      cell.hexLabel.text = list[indexPath.item].rgbHexString
      
      return cell
   }
}

// 선택 이벤트 처리
extension CocoaTouchCollectionViewViewController: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      collectionView.deselectItem(at: indexPath, animated: true)
      
      print(list[indexPath.item].rgbHexString)
   }
}

// 셀 크기 지정
extension CocoaTouchCollectionViewViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else {
         return CGSize.zero
      }
      
      let value = (collectionView.frame.width - (flowLayout.sectionInset.left + flowLayout.sectionInset.right + flowLayout.minimumInteritemSpacing)) / 2
      return CGSize(width: value, height: value)
   }
}
