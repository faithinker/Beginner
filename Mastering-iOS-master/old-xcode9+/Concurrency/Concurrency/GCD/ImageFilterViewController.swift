//DownloadQueue에 추가된 작업이 동시에 실행된다. 모든 작업은 동일한 그룹에 추가되어 있고 그룹에 포함된 모든 작업이 완료되면
//CollectionView가 메인큐에서 Reload 된다. 같은시점에 Filter를 적용하고 Cell을 Reload하는 코드가 병렬적으로 실행된다.
//모등 작업이 동시에 실행되지는 않는다. 가능한 숫자만큼 필터가 실행되고 나서 하나가 완료되면 대기중인 작업이 이어서 실행된다.

import UIKit

class ImageFilterViewController: UIViewController {
   
   @IBOutlet weak var listCollectionView: UICollectionView!
    
    let downloadQueue = DispatchQueue(label: "DownloadQueue", attributes: .concurrent)
    let downloadGroup = DispatchGroup()
    
    let filterQueue = DispatchQueue(label: "FilterQueue", attributes: .concurrent)
   
   var isCancelled = false
   
   @IBAction func start(_ sender: Any) {
      PhotoDataSource.shared.reset()
      listCollectionView.reloadData()
      
      isCancelled = false
   
      //배열에 저장되어있는 데이터를 열거하면서 다운로드& 리사이즈 메소드를 호출하고  다운로드큐에 추가한다.
    PhotoDataSource.shared.list.forEach { (data) in
        self.downloadQueue.async(group: self.downloadGroup) {
            self.downloadAndResize(target: data)
        }
    }
    //다운로드에 속한 모든 작업이 완료되면, 컬렉션뷰를 Reload함 / UIUpdate이기 때문에 메인큐에서 실행
    self.downloadGroup.notify(queue: DispatchQueue.main) {
        self.reloadCollectionView()
    }
    //filter작업을 실행하고 개별 cell을 업데이트 해야한다.
    self.downloadGroup.notify(queue: self.filterQueue) {
        DispatchQueue.concurrentPerform(iterations: PhotoDataSource.shared.list.count) { (index) in
            //block 내부로 이동한 다음 대상 데이터를 가져와서 데이터 상수에 저장한다.
            let data = PhotoDataSource.shared.list[index]
            self.applyFilter(target: data)
            
            //Reload할 Cell 위치를 생성
            let targetIndexPath = IndexPath(item: index, section: 0)
            DispatchQueue.main.async {
                self.reloadCollectionView(at: targetIndexPath)
            }
        }
    }
   }
   
   @IBAction func cancel(_ sender: Any) {
      isCancelled = true
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      PhotoDataSource.shared.reset()
   }   
}


extension ImageFilterViewController {
   func reloadCollectionView(at indexPath: IndexPath? = nil) {
      guard !isCancelled else { print("RELOAD: Cancelled"); return }
      
      print("RELOAD: Start", indexPath ?? "")
      
      defer {
         if isCancelled {
            print("RELOAD: Cancelled", indexPath ?? "")
         } else {
            print("RELOAD: Done", indexPath ?? "")
         }
      }
      
      if let indexPath = indexPath {
         if listCollectionView.indexPathsForVisibleItems.contains(indexPath) {
            listCollectionView.reloadItems(at: [indexPath])
         }
      } else {
         listCollectionView.reloadData()
      }
   }
   
   func downloadAndResize(target: PhotoData) {
      print("DOWNLOAD & RESIZE: Start")
      
      defer {
         if isCancelled {
            print("DOWNLOAD & RESIZE: Cancelled")
         } else {
            print("DOWNLOAD & RESIZE: Done")
         }
      }
      
      guard !Thread.isMainThread else { fatalError() }
      
      guard !isCancelled else { print("DOWNLOAD & RESIZE: Cancelled"); return }
      
      do {
         let data = try Data(contentsOf: target.url)
         
         guard !isCancelled else { print("DOWNLOAD & RESIZE: Cancelled"); return }
         
         if let image = UIImage(data: data) {
            let size = image.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
            UIGraphicsBeginImageContextWithOptions(size, true, 0.0)
            let frame = CGRect(origin: CGPoint.zero, size: size)
            image.draw(in: frame)
            let resultImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            guard !isCancelled else { print("DOWNLOAD & RESIZE: Cancelled"); return }
            
            target.data = resultImage
         }
      } catch {
         print(error.localizedDescription)
      }
   }
   
   func applyFilter(target: PhotoData) {
      print("FILTER: Start")

      defer {
         if isCancelled {
            print("FILTER: Cancelled")
         } else {
            print("FILTER: Done")
         }
      }

      guard !Thread.isMainThread else { fatalError() }
      guard !isCancelled else { print("FILTER: Cancelled"); return }
      
      guard let source = target.data?.cgImage else { fatalError() }
      let ciImage = CIImage(cgImage: source)
      
      guard !isCancelled else { print("FILTER: Cancelled"); return }
      
      let filter = CIFilter(name: "CIPhotoEffectNoir")
      filter?.setValue(ciImage, forKey: kCIInputImageKey)
      
      guard !isCancelled else { print("FILTER: Cancelled"); return }
      
      guard let ciResult = filter?.value(forKey: kCIOutputImageKey) as? CIImage else { fatalError() }
      
      guard !isCancelled else { print("FILTER: Cancelled"); return }
      
      guard let cgImg = PhotoDataSource.shared.filterContext.createCGImage(ciResult, from: ciResult.extent) else {
         fatalError()
      }
      target.data = UIImage(cgImage: cgImg)
      
      Thread.sleep(forTimeInterval: TimeInterval(arc4random_uniform(3)))
   }
}

extension ImageFilterViewController: UICollectionViewDataSource {
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


extension ImageFilterViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let w = collectionView.bounds.width / 3
      return CGSize(width: w, height: w * (768 / 1024))
   }
}
