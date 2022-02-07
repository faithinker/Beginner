// Prefetching API를 활용해서 지연없이 데이터를 표시하는 방법
// 이미지 다운로드, 스크롤 성능 향상, 중복 다운로드 방지, Pull to Refresh 구현, Refresh Control 커스터마이징
//
// TableView를 스크롤하면 새로운 이미지를 다운로드하고 Cell을 업데이트 한다.
// 약간의 지연이 발생한다. 네트워크 품질이 안좋으면 지연시간이 더욱 많이 생긴다.
//
// Model > Landscape.swift 파일

// rootView가 TableView이기 때문에 다른 뷰를 추가할 수 없다.
// 대신에 제약 추가 안해도 되고 delegate datasource가 이미 연결되어 있다.
// Cell을 구성하고 필요한 delegate 메소드만 구현하면 Table 구현이 완료된다.

import UIKit

class PrefetchingViewController: UIViewController {
    
    @IBOutlet weak var listTableView: UITableView!
    
    
    lazy var refreshControl: UIRefreshControl = { [weak self] in
        let control = UIRefreshControl()
        control.tintColor = self?.view.tintColor
        return control
    }()
    
    
    @objc func refresh() {
        DispatchQueue.global().async { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.list = Landscape.generateData()
            strongSelf.downloadTasks.forEach { $0.cancel() }
            strongSelf.downloadTasks.removeAll()
            Thread.sleep(forTimeInterval: 2)
            
            DispatchQueue.main.async {
                strongSelf.listTableView.reloadData()
                strongSelf.listTableView.refreshControl?.endRefreshing()
            }
        }
    }
    
    
    var list = Landscape.generateData()
    var downloadTasks = [URLSessionTask]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listTableView.prefetchDataSource = self
        
        // pull to refresh 기능이 활성화된다.
        listTableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
}
// prefetching API를 구현할 때는 동일한 Index가 짧은시간동안 연속적으로 전달되는 부분을 제대로 처리해야 한다.
extension PrefetchingViewController: UITableViewDataSourcePrefetching {
    // tableview는 다음에 표시될 Cell을 미리 판단하고 이 메소드를 호출함
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            downloadImage(at: indexPath.row)
        }
        
        print(#function, indexPaths)
    }
    // Prefetching을 취소한다.
    // => 사용자가 아주 빠르게 스크롤해서 맨밑에 있는 데이터만 볼려고 할 때 굳이 그 중간 과정에 있는 데이터를 볼 필요가 없다.
    // Prefetching 대상에서 제외된 Cell이 있을 때마다 반복적으로 호출된다.
    // indexPaths : 취소된 indexPaths가 전달됨
    //
    // ㅉ랍은시간동안 반복적으로 호출되는 부분을 제대로 처리해야 한다.
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        print(#function, indexPaths)
        
        for indexPath in indexPaths {
            cancelDownload(at: indexPath.row)
        }
    }
    
}

extension PrefetchingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        if let imageView = cell.viewWithTag(100) as? UIImageView {
            if let image = list[indexPath.row].image {
                imageView.image = image
            } else {
                imageView.image = nil
                downloadImage(at: indexPath.row)
            }
        }
        
        if let label = cell.viewWithTag(200) as? UILabel {
            label.text = "#\(indexPath.row + 1)"
        }
        
        return cell
    }
}




extension PrefetchingViewController {
    func downloadImage(at index: Int) {
        // 이미지가 이미 다운로드 되었는지 확인
        guard list[index].image == nil else {
            return
        }
        // 동일한 이미지를 다운로드하는 작업이 포함되어있는지 확인. 중복다운로드 방지
        let targetUrl = list[index].url
        guard !downloadTasks.contains(where: { $0.originalRequest?.url == targetUrl }) else {
            return
        }
        
        print(#function, index)
        
        let task = URLSession.shared.dataTask(with: targetUrl) { [weak self] (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            if let data = data, let image = UIImage(data: data), let strongSelf = self {
                strongSelf.list[index].image = image
                let reloadTargetIndexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    if strongSelf.listTableView.indexPathsForVisibleRows?.contains(reloadTargetIndexPath) == .some(true) {
                        strongSelf.listTableView.reloadRows(at: [reloadTargetIndexPath], with: .automatic)
                    }
                }
                
                strongSelf.completeTask()
            }
        }
        task.resume()
        downloadTasks.append(task)
    }
    
    
    func completeTask() {
        downloadTasks = downloadTasks.filter { $0.state != .completed }
    }
    
    
    func cancelDownload(at index: Int) {
        let targetUrl = list[index].url
        guard let taskIndex = downloadTasks.index(where: { $0.originalRequest?.url == targetUrl }) else {
            return
        }
        let task = downloadTasks[taskIndex]
        task.cancel()
        downloadTasks.remove(at: taskIndex)
    }
}















