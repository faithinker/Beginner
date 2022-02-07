//files에 있는 데이터들은 Bundle Container에 포함된다. 따라서 읽기만 가능하다.
//Bundle Container에 포함된 파일은 Bundle Class를 통해 접근
//Data Container에 있는 파일들은 기본적으로 구조체 제공하는 API를 통해 접근한다.
import UIKit


enum Type: Int {
   case directory
   case file
}


struct Content {
   let url: URL //구조체, 클래스로 사용하고 싶다면 NSURL 클래스를 사용한다. File URL, Network URL
   
   var name: String {
    let values = try? url.resourceValues(forKeys: [.localizedNameKey])
    return values?.localizedName ?? "???"
   }
   
   var size: Int {
    let values =  try? url.resourceValues(forKeys: [.fileSizeKey])
    return values?.fileSize ?? 0
   }
   
   var type: Type {
    let values = try? url.resourceValues(forKeys: [.isDirectoryKey])
    return values?.isDirectory == true ? .directory : .file
   }
   
   var isExcludedFromBackup: Bool {
    let values = try? url.resourceValues(forKeys: [.isExcludedFromBackupKey])
    return values?.isExcludedFromBackup ?? false
   }
}



class FileManagerTableViewController: UITableViewController {
   
   var currentDirectoryUrl: URL?
   
   var contents = [Content]()
   
   var formatter: ByteCountFormatter = {
      let f = ByteCountFormatter()
      f.isAdaptive = true
      f.includesUnit = true
      return f
   }()
   
   
   func refreshContents() {
    contents.removeAll() //배열 초기화
    
    defer { //메소드가 끝나면 테이블 업데이트
        tableView.reloadData()
    }
    ///표시할 디렉터로 URL이 없는 경우
    guard let url = currentDirectoryUrl else {
        //Error 이유 모름 잘 따라침
        fatalError("Empty url")
    }
    do { //이름 디렉토리Flag, File Size, BackUpFlag
        let properties : [URLResourceKey] = [.localizedNameKey, .isDirectoryKey, .fileSizeKey, .isExcludedFromBackupKey]
        //currentContentUrls : url이 배열로 저장됨.  skipsHiddenFiles : 숨겨진 파일은 결과에서 제거
        let currentContentUrls = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: properties, options: .skipsHiddenFiles)
        
        //결과배열을 열거하면서 content instance를 생성하고 컨텐츠 배열에 저장한다.
        
        for url in currentContentUrls {
            let content = Content(url: url)
            contents.append(content)
        }
        //디렉토리 파일순으로 정렬, 같은 타입에서는 이름을 기준으로 정렬, sorting을 이런식으로도 자유롭게 바꿔서 쓸 쑤 있구나...
        contents.sort { lhs, rhs -> Bool in
            if lhs.type == rhs.type {
                return lhs.name.lowercased() < rhs.name.lowercased()
            }
            return lhs.type.rawValue < rhs.type.rawValue
        }
    } catch {
        print(error)
    }
   }
   
   func updateNavigationTitle() {
    guard let url = currentDirectoryUrl else { navigationItem.title = "???"; return }
    do { //url과 관련된 속성 읽을 때 사용하는 메소드, 네비게이션 바에 디렉토리 이름이 표시됨
        let values = try url.resourceValues(forKeys: [.localizedNameKey])
        navigationItem.title = values.localizedName
    } catch {
        print(error)
    }
   }
   
   func move(to url: URL) { //이동할 URL
    do {//url에 파일이나 디렉토리가 존재하고 정상적으로 접근 가능하면 True를 리턴한다.
        let reachable = try url.checkResourceIsReachable()
        if !reachable {
            return
        }
    } catch {
        print(error)
        return
    }
    //접근 가능하면 새로운 vc 추가하고 push함
    if let vc = storyboard?.instantiateViewController(withIdentifier: "FileManagerTableViewController") as? FileManagerTableViewController {
        vc.currentDirectoryUrl = url
        
        navigationController?.pushViewController(vc, animated: true)
    }
   }

   
   func addDirectory(named: String) {
      //appendingPathComponent : url 마지막에 새로운 경로를 추가해서 새로운 url로 리턴함,
      //true 전달시 경로 마지막에 / 를 추가한다.
    guard let url = currentDirectoryUrl?.appendingPathComponent(named, isDirectory: true) else { return }
    do { //withIntermediateDirectories true : 경로에 포함된 디렉토리 중에서 생성되지 않은 모든 디렉토리를 자동으로 생성해줌
        // ex)A/B/C A가 생성되어 있고 나머지는 생성 x, C 생성시 B 디렉토리 자동생성됨
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        refreshContents() // table을 업데이트함
    } catch {
        print(error)
    }
   }
   
   func addTextFile() {
      //파일 종류를 구분하는 방법, 1.앱내부에서 파일 처리시에는 "확장자"로 구분,
    //2.앱사이에 전달할 수 있는 파일형식을 지정할 때는 UnitformTypeIdentity(UTI) 파일 종류를 고유한 문자열로 표현함
    guard let sourceUrl = Bundle.main.url(forResource: "lorem", withExtension: "txt") else { return }
    //파일을 저장할 경로
    guard let targetUrl = currentDirectoryUrl?.appendingPathComponent("lorem").appendingPathExtension("txt") else { return }
    do {//file 읽기
        let data = try Data(contentsOf: sourceUrl)
        try data.write(to: targetUrl)
        refreshContents() //목록 업데이트
        //String, NSArray, NSDictionary : write 메소드 제공함
        //특정형식의 데이터를 파일로 저장하는 코드를 쉽게 구현 할 수 있다.
    }catch {
        print(error)
    }
   }
   
   func addImageFile() {
    DispatchQueue.global().async { [weak self] in
        guard let url = Bundle.main.url(forResource: "fireworks", withExtension: "png") else { return }
        guard let targetUrl = self?.currentDirectoryUrl?.appendingPathComponent("fireworks").appendingPathExtension("png") else { return }
        do {
            let data = try Data(contentsOf: url)
            try data.write(to: targetUrl)
            self?.refreshContents()
        }catch {
            print(error)
        }
    }
   }
   
   func open(content: Content) { //file을 탭하면 새로운 화면에서 이미지 또는 txt가 나오는 함수
    //확장자 가져오기
    //lastPathComponent : 파일이름과 파일 형식이 String형태로 저장됨
    //NSString이 경로 처리하는 메소드 지원하기 때문에 Downcasting 해야함
    // pathExtension : 확장자를 리턴함
    let ext = (content.url.lastPathComponent as NSString).pathExtension.lowercased()
    
    switch ext { //확장자명에 따라 swgue 경로 지정해줌
    case "txt":
        performSegue(withIdentifier: "textSegue", sender: content.url)
    case "png","jpg":
        performSegue(withIdentifier: "imageSegue", sender: content.url)
    default: //지원 X 경고창 표시
        showNotSupportedAlert()
    }
   }
   
   func deleteDirectory(at url: URL) {
    DispatchQueue.global().async { [weak self] in
        do { //디렉토리,파일 삭제시 사용하는 메소드
            try FileManager.default.removeItem(at: url)
            DispatchQueue.main.async {
                self?.refreshContents()
            }
        } catch {
            print(error)
        }
    }
   }
    //파일 작업은 오래 걸리기 때문에 동시성을 고려해서 개발해야 한다.
   func deleteFile(at url: URL) {
    DispatchQueue.global().async { [weak self] in
        do {
            let manager = FileManager()
            try manager.removeItem(at: url)
            DispatchQueue.main.async {
                self?.refreshContents()
            }
            
        } catch {
            print(error)
        }
    }
    
   }
   
   func renameItem(at url: URL) { //이름 변경
    let newname = "NewName"
    let ext = (url.lastPathComponent as NSString).pathExtension
    
    let newUrl = url.deletingLastPathComponent().appendingPathComponent(newname).appendingPathExtension(ext)
    do {//대상을 새로운 위치로 이동하거나 이름을 변경할 떄 사용하느 메소드
        try FileManager.default.moveItem(at: url, to: newUrl)
        refreshContents()
        //복사 메소드
        //FileManager.default.copyItem(at: <#T##URL#>, to: <#T##URL#>)
    } catch {
        print(error)
    }
   }
   //사용자가 직접 생성하지 않은 파일은 반드시 백업대상에서 제외되어야 한다.
   func updateBackupProperty(of url: URL, exclude: Bool) {
    do { //속성을 바꿈
        var targetUrl = url
        var values = try targetUrl.resourceValues(forKeys: [.isExcludedFromBackupKey])
        values.isExcludedFromBackup = exclude
        try targetUrl.setResourceValues(values)
    } catch {
        print(error)
    }
    refreshContents()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      refreshContents() //디렉토리 내용 업데이트
      updateNavigationTitle() //네비게이션 바의 디렉토리 이름을 표시한다.
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let vc = segue.destination.children.first as? TextViewController {
         vc.url = sender as? URL
      } else if let vc = segue.destination.children.first as? ImageViewController {
         vc.url = sender as? URL
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
    if currentDirectoryUrl == nil {
        currentDirectoryUrl = URL(fileURLWithPath: NSHomeDirectory())
    }
      
   }
   
   // MARK: - Table view data source
   
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return contents.count
   }
   
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
      
      let target = contents[indexPath.row]
      
      switch target.type {
      case .directory:
         cell.textLabel?.text = "[\(target.name)]"
         cell.detailTextLabel?.text = nil
         cell.accessoryType = .disclosureIndicator
      case .file:
         print(target.size)
         cell.textLabel?.text = target.name
         cell.detailTextLabel?.text = formatter.string(fromByteCount: Int64(target.size))
         cell.accessoryType = .none
      }
      
      if target.isExcludedFromBackup {
         cell.textLabel?.textColor = UIColor.lightGray
      } else {
         cell.textLabel?.textColor = UIColor.black
      }
      
      cell.detailTextLabel?.textColor = cell.textLabel?.textColor
      
      return cell
   }
   
   override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
      
      let renameAction = UITableViewRowAction(style: .default, title: "Rename") { [weak self] (action, indexPath) in
         if let target = self?.contents[indexPath.row] {
            self?.renameItem(at: target.url)
         }
      }
      renameAction.backgroundColor = UIColor.darkGray
      
      let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { [weak self] (action, indexPath) in
         if let target = self?.contents[indexPath.row] {
            switch target.type {
            case .directory:
               self?.deleteDirectory(at: target.url)
            case .file:
               self?.deleteFile(at: target.url)
            }
         }
      }
      
      var actions = [deleteAction, renameAction]
      
      let target = contents[indexPath.row]
      
      if target.isExcludedFromBackup {
         let includeAction = UITableViewRowAction(style: .default, title: "Include to Backup") { [weak self] (action, indexPath) in
            if let target = self?.contents[indexPath.row] {
               self?.updateBackupProperty(of: target.url, exclude: false)
            }
         }
         includeAction.backgroundColor = UIColor.blue
         
         actions.append(includeAction)
      } else {
         let excludeAction = UITableViewRowAction(style: .default, title: "Exclude from Backup") { [weak self] (action, indexPath) in
            if let target = self?.contents[indexPath.row] {
               self?.updateBackupProperty(of: target.url, exclude: true)
            }
         }
         excludeAction.backgroundColor = UIColor.blue
         
         actions.append(excludeAction)
      }
      
      return actions
   }

   
   override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      tableView.deselectRow(at: indexPath, animated: true)
      
      let target = contents[indexPath.row]
      
      switch target.type {
      case .directory:
         move(to: target.url)
      case .file:
         open(content: target)
      }
   }
   
   @IBAction func showDirectoryMenu(_ sender: Any) {
      let menu = UIAlertController(title: "Directory Menu", message: nil, preferredStyle: .actionSheet)
      
      let addDirectoryAction = UIAlertAction(title: "Add Directory", style: .default) { [ weak self](action) in
         self?.showNameInputAlert()
      }
      menu.addAction(addDirectoryAction)
      
      let addTextFileAction = UIAlertAction(title: "Add Text File", style: .default) { [weak self] (action) in
         self?.addTextFile()
      }
      menu.addAction(addTextFileAction)
      
      let addImageFileAction = UIAlertAction(title: "Add Image File", style: .default) { [weak self] (action) in
         self?.addImageFile()
      }
      menu.addAction(addImageFileAction)
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      menu.addAction(cancelAction)
      
      if let pc = menu.popoverPresentationController {
         pc.barButtonItem = navigationItem.rightBarButtonItem
      }
      
      present(menu, animated: true, completion: nil)
   }
   
   func showNameInputAlert() {
      let inputAlert = UIAlertController(title: "Input Name", message: nil, preferredStyle: .alert)
      
      inputAlert.addTextField { (nameField) in
         nameField.placeholder = "Input Name"
      }
      
      let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] (action) in
         if let name = inputAlert.textFields?.first?.text {
            self?.addDirectory(named: name)
         }
      }
      inputAlert.addAction(createAction)
      
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
      inputAlert.addAction(cancelAction)
      
      present(inputAlert, animated: true, completion: nil)
   }
   
   func showNotSupportedAlert() {
      let alert = UIAlertController(title: "File Not Supported", message: nil, preferredStyle: .alert)
      
      let cancelAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
      alert.addAction(cancelAction)
      
      present(alert, animated: true, completion: nil)
   }
}
