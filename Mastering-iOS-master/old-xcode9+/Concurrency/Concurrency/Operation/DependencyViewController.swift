// Operation 사이의 의존성은 순서를 결정한다. 단방향 의존성만 가능. 상호의존성 X
//

//실행순서 : 다운로드 실행 -> CollectionView를 Reloadgksms Op 실행 -> 의존성 가진 FilterOp가 동시 실행된다.
// 개별 셀을 Reload 하는 reloadItemOp 실행
import UIKit
//의존성을 추가 할 때는 Operation을 생성하고 의존성에 추가한다음에 배열에 할당한다.
//그리고 Operation Queue에 동시에 추가한다.
class DependencyViewController: UIViewController {
   
   let backgroundQueue = OperationQueue()
   let mainQueue = OperationQueue.main
   
   var uiOperations = [Operation]()
   var backgroundOperations = [Operation]()
   
   @IBOutlet weak var listCollectionView: UICollectionView!
   
   @IBAction func startOperation(_ sender: Any) {
      PhotoDataSource.shared.reset()
      listCollectionView.reloadData()
      uiOperations.removeAll()
      backgroundOperations.removeAll()
      
      //action은 메인쓰레드에서 실행, 블록킹을 방지하기 위해 백그라운드에서 실행
    DispatchQueue.global().async {
        let reloadOp = ReloadOperation(collectionView: self.listCollectionView)
        self.uiOperations.append(reloadOp)
        
        //Pthoto data에 있는 list source를 열거
        // 다운로드 -> Reload -> filter -> reloadItemOp 순으로 실행
        for (index, data) in PhotoDataSource.shared.list.enumerated() {
            let downloadOp = DownloadOperation(target: data)
            reloadOp.addDependency(downloadOp)
            self.backgroundOperations.append(downloadOp)
            
            let filterOp = FilterOperation(target: data)
            filterOp.addDependency(reloadOp)
            self.backgroundOperations.append(filterOp)
            
            let reloadItemOp = ReloadOperation(collectionView: self.listCollectionView, indexPath: IndexPath(item: index, section: 0))
            reloadItemOp.addDependency(filterOp)
            self.uiOperations.append(reloadItemOp)
        }
        //배열에 저장되어 있는 Op를 OperationQueue에 추가
        self.backgroundQueue.addOperations(self.backgroundOperations, waitUntilFinished: false)
        //true로 전달하면 모든 Op가 완료 될 때까지 Return 하지 않는다.
        //메인쓰레드에서 동작하는 오퍼레이션 큐는 false로 놓는게 좋다. 메인큐에 추가 할 때 True 전달하면 메인쓰레드가 블로킹 당하기 때문
        self.mainQueue.addOperations(self.uiOperations, waitUntilFinished: false)
    }
   }
   
   
   @IBAction func cancelOperation(_ sender: Any) {
        //mainQueue.cancelAllOperations() //이미지가 load됨
        //UIOp에 추가되어 있는 개별Op 마다 Cancel 메소드 호출
    uiOperations.forEach { $0.cancel()}
        backgroundQueue.cancelAllOperations()
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      PhotoDataSource.shared.reset()
    
    //동시에 실행할 Op의 숫자를 임의 설정함 ConcurrentQueue를 Serail Queue로 바꿀떄 자주 사용하는 패턴이다.
    backgroundQueue.maxConcurrentOperationCount = 5 //5이하로 값 주면 CPU 부하를 줄여줌
   }
}


extension DependencyViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return PhotoDataSource.shared.list.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      
      let target = PhotoDataSource.shared.list[indexPath.item]
      if let imageView = cell.contentView.viewWithTag(100) as? UIImageView {
         imageView.image = target.data
      }
      
      return cell
   }
}


extension DependencyViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let w = collectionView.bounds.width / 3
      return CGSize(width: w, height: w * (768 / 1024))
   }
}
