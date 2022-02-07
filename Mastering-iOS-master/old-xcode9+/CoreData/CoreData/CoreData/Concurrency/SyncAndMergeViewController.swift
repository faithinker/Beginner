// Context는 독립적인 공간에서 메모리 작업을 처리한다.
// 동일한 entity를 여러공간에서 처리할 때 동기화 문제가 발생한다.
// 데이터 읽기는 문제가 없으나 업데이트 삭제 할 시 명확성의 문제, 지정을 해야한다.
//
// 업데이트 즉시 동기화가 구현되는 코드. context를 저장할 때 데이터 충돌을 처리하는 merge 정책을 설정
//
//  *** Optimistic Locking ***
//
// backgroundContext에서 fetch(가져오고)하고 save 해도 업데이트 된 내용이 없기 때문에 아무런 작업을 하지 않는다.
// CoreData는 영구저장소에서 데이터를 가져올(fetch) 때마다 해당 시점의 값을 저장하는 "스냅샷"을 생성한다. Context를 저장하면
// Update된 객체에 스냅샷과 영구저장소에 있는 값을 비교한다. 두값이 동일하다면 마지막 fetch 이후에 저장된 값이 업데이트 되지 않는다. merge 정책을 통해서 어느것이 올바른 것인지 판단한다.
//
// 데이터를 충돌시키고 저장하지 않는다.


import UIKit
import CoreData


class SyncAndMergeViewController: UIViewController {
   
   lazy var formatter: NumberFormatter = {
      let f = NumberFormatter()
      f.locale = Locale(identifier: "en_US")
      f.numberStyle = .currency
      return f
   }()
   
   @IBOutlet weak var nameLabel: UILabel!
   
   @IBOutlet weak var mainContextSalaryLabel: UILabel!
   
   @IBOutlet weak var backgroundContextSalaryLabel: UILabel!
   
    // ManagedObject는 쓰레드에 안전하지 않다. 다른 쓰레드에서 접근하면 오류가 난다.
    // 그래서 속성에 저장할 때는 접두어나 접미어 활용해서 Context임을 알 수 있도록 하자.
   var employeeInMainContext: EmployeeEntity?
   var employeeInBackgroundContext: EmployeeEntity?
   
   let mainContext = DataManager.shared.mainContext
   let backgroundContext = DataManager.shared.backgroundContext
   
   @IBAction func fetchIntoMainContext(_ sender: Any) {
    mainContext.perform {
        self.employeeInMainContext = DataManager.shared.fetchEmployee(in: self.mainContext)
        
        self.nameLabel.text = self.employeeInMainContext?.name
        self.mainContextSalaryLabel.text = self.formatter.string(for: self.employeeInMainContext?.salary)
    }
   }
   
   @IBAction func fetchIntoBackgroundContext(_ sender: Any) {
    backgroundContext.perform {
        self.employeeInBackgroundContext = DataManager.shared.fetchEmployee(in: self.backgroundContext)
        
        // label 업데이트 하는 코드는 메인쓰레드에서 실행해야 한다.
        // ManagedObject를 다른 쓰레드로 바로 전달하면 문제가 발생 할 수 있다.
        // 필요한 값을 따로 저장한 다음 이 값을 메인쓰레드로 전달해야 한다.
        let salary = self.employeeInBackgroundContext?.salary?.decimalValue
        
        DispatchQueue.main.async {
            self.backgroundContextSalaryLabel.text = self.formatter.string(for: salary)
            
        }
        
    }
   }
   // Salary값 랜덤으로 줌
   @IBAction func updateInMainContext(_ sender: Any) {
    mainContext.perform {
        let newSalary = NSDecimalNumber(integerLiteral: Int.random(in: 30...90) * 1000)
        self.employeeInMainContext?.salary = newSalary
        self.mainContextSalaryLabel.text = self.formatter.string(for: newSalary)
    }
   }

   @IBAction func updateInBackgroundContext(_ sender: Any) {
    backgroundContext.perform {
        let newSalary = NSDecimalNumber(integerLiteral: Int.random(in: 30...90) * 1000)
        self.employeeInBackgroundContext?.salary = newSalary
        
        DispatchQueue.main.async {
            self.backgroundContextSalaryLabel.text = self.formatter.string(for: newSalary)
        }
    }
   }
   
   @IBAction func saveInMainContext(_ sender: Any) {
      mainContext.perform {
         do {
            try self.mainContext.save()
         } catch {
            print(error)
         }
      }
   }

   @IBAction func saveInBackgroundContext(_ sender: Any) {
      backgroundContext.perform {
         do {
            try self.backgroundContext.save()
         } catch {
            print(error)
         }
      }
   }
   // 163 ~ 186까지 주석처리후  Refresh 버튼 실행. 객체를 최신값으로 업데이트함
   // fetch 이후에 값을 업데이트하면 업데이트 된 값이 최신 값으로 사용된다.
    
    // 메인 update->save, background update하면  back에서 refresh해도 영구저장소에 있는 값을 무시하고 가장 최근에 update한 값을 가져오기 때문이다.

   @IBAction func refreshInMainContext(_ sender: Any) {
      // false : 객체가 fault 상태로 전환, true : 영구저장소에 있는 값과 context값 중에서 최신 값으로 업데이트 한다.
    mainContext.perform {
        self.mainContext.refresh(self.employeeInMainContext!, mergeChanges: true)
        
        self.mainContextSalaryLabel.text = self.formatter.string(for: self.employeeInMainContext?.salary)
    }
    
   }
   // 영구저장소에 있는 값을 최신 값으로 사용하고 가져온다.
   @IBAction func refreshInBackgroundContext(_ sender: Any) {
    backgroundContext.perform {
        self.backgroundContext.refresh(self.employeeInBackgroundContext!, mergeChanges: true)
        
        let salary = self.employeeInBackgroundContext?.salary?.decimalValue
        
        DispatchQueue.main.async {
            self.backgroundContextSalaryLabel.text = self.formatter.string(for: salary)
        }
        
        
    }
   }
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
    
    //  10분 50초부터
    //  영구저장소 = 내부 메모리
    //  스냅샷 = 외부 메모리
    //
    // NSErrorMergePolicy : 데이터 충돌시 오류 발생 시키고 저장 X (영구저장소,스냅샷 값)
    //
    // 정책이 적용되는 단위는 "어트리뷰트" 이다.
    // NSMergeByPropertyStoreTrumpMergePolicy : 새로 저장할 값과 스냅샷에 저장된 값이 충돌할 때 영구저장소에 있는  현재 값을 저장한다.  
    // NSMergeByPropertyObjectTrumpMergePolicy : Context에서 업데이트한 값을 저장
    //
    // NSOverwriteMergePolicy : 충돌을 무시하고 현재값을 저장
    // NSRollbackMergePolicy : 업데이트된 모든 값을 버리고 영구저장소에 있는 값으로 대체함
    
    mainContext.mergePolicy = NSOverwriteMergePolicy
    backgroundContext.mergePolicy = NSOverwriteMergePolicy
      
    

      NotificationCenter.default.addObserver(forName: NSNotification.Name.NSManagedObjectContextObjectsDidChange, object: nil, queue: OperationQueue.main) { (noti) in
         guard let userInfo = noti.userInfo else { return }
         guard let changedContext = noti.object as? NSManagedObjectContext else { return }

         print("===========================")

        // 이 아래  부분 이해 필요. 코더처럼 치기만 함
        if let inserts = userInfo[NSInsertedObjectsKey] as? Set<NSManagedObject>, inserts.count > 0 {
            
        }
        
        if let deletes = userInfo[NSDeletedObjectsKey] as? Set<NSManagedObject>, deletes.count > 0 {
            
        }
        
        if let updates = userInfo[NSUpdatedObjectsKey] as? Set<NSManagedObject>, updates.count > 0 {
            guard changedContext != self.backgroundContext else { return } //무한루프 방지
            
            for update in updates {
                self.backgroundContext.perform {
                    for (key, value) in update.changedValues() {
                        self.employeeInBackgroundContext?.setValue(value, forKey: key)
                    }
                }
                
                let salary = self.employeeInBackgroundContext?.salary?.decimalValue
                DispatchQueue.main.async {
                    self.backgroundContextSalaryLabel.text = self.formatter.string(for: salary)
                }
            }
        }
      }
   }
}

// context에서 값을 업데이트한 시점에 다른 context와 동결시킨다.

// 추가된 데이터 / 업데이트된 데이터 / 삭제된 데이터 3개가 set으로 저장되어 있다.
