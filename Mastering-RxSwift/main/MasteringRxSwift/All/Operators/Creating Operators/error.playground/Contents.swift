
import UIKit
import RxSwift

/*:
 # error
 */

let disposeBag = DisposeBag()

enum MyError: Error {
   case error
}


Observable<Void>.error(MyError.error)
    .subscribe { print($0) }
    .disposed(by: disposeBag)











