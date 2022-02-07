
import UIKit
import RxSwift

/*:
 # Observers
 */

Observable<Int>.create { (observer) -> Disposable in
   observer.on(.next(0))
   observer.onNext(1)
   
   observer.onCompleted()
   
   return Disposables.create()
}



Observable.from([1, 2, 3])

















