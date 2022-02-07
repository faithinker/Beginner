// EX) 쿠팡이츠 > 가게 선택 > 아래로 스크롤 : 컴포넌트로 있던 가게명이 네비게이션 컨트롤러 위로 올라감
// 사진이 큰 가게 선택 > 사진과 가게명이 애니메이션 되면서 새로운 화면으로 전환됨
// App Store > Todat > component 클릭
//
//    *** CustomTransition 개념, 동작원리 설명 ***
// Animation Controller : Transition Ani를 구현하는 객체이다.
// Presentaion Controller : 새로운 화면을 표시할 프레임을 설정하고 트랜지션 애니메이션을 실행.
// 트랜지션에 사용되는 커스텀 뷰를 관리한다.
// UIKit은 트랜지션을 실행 할 때 트랜지션 델리게이트에게 애니메이터와 인터렉티브 애니메이터를 요청한다.
// 직접 구현한 애니메이터를 실행하면 기본 애니메이터 대신 실행한다.
// UIKit은 트랜지션이 실해되기 전에 트랜지셔닝 컨텍스트를 생성하고 트랜지션에 필요한 속성을 저장한다. 직접 구현은 거의 안하고
// 애니메이터로 전달되는 컨텍스트를 그대로 사용한다.
// Transition Coordinator 트랜지션과 함꼐 실행할 애니메이션을 구현할 때 사용한다.
// 실행중인 트랜지션에 대한 다양한 정보를 제공한다.
//
//             ***    프레젠테이션이 처리되는 과정    ***
// UIKit은(VC) 새로운 화면을 표시하기 전에 트랜지션 델리게이트에게 애니메이터를 요청한다.
// delegate가 구현되어 있지 않거나 nil을 리턴하면 기본 애니메이터를 사용한다.
// 반대로 애니메이터를 리턴하면 Custom 트랜지션을 실행한다.
// 이후 VC가 트랜지션 델리게이트에게 인터렉티브 애니메이터를 요청하고 최종적으로 트랜지션 방식을 결정한다.
// 트랜지셔닝 컨텍스트가 생성되고 트랜지션에 필요한 정보가 저장된다.
// 컨텍스트는 애니메이터로 저장되고 트랜지션 실행시간을 확인한 다음 애니메이터에 구현되어 있는 트랜지션 애니메이션이 실행된다.
// 애니메이션이 완료되고 나서 트랜지셔닝 컨텍스트에서 completeTrasnsition 메소드를 호출하면 프레젠테이션이 완료된다.
// dismissal 과정은 메소드 이름에 프레젠테이션 대신 dismiss가 포함되는 점을 제외하면 프레젠테이션과 유사하다.


import UIKit

class CustomTransitionViewController: UIViewController {
   
   var list = (1 ... 10).map { return UIImage(named: "\($0)")! }
   
   let animator = ZoomAnimationController()
   // interactiveAnimator
   var interactiveAnimator: PinchTransitionController?
    
   @IBOutlet weak var listCollectionView: UICollectionView!
   
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if let vc = segue.destination as? ImageViewController {
         if let cell = sender as? UICollectionViewCell, let indexPath = listCollectionView.indexPath(for: cell) {
            vc.image = list[indexPath.item]
            animator.targetImage = vc.image
            animator.targetIndexPath = indexPath
            
            // 새로운 interactiveAnimator 생성, 새롭게 표시할 뷰 컨트롤러를 타깃으로 설정한다.
            interactiveAnimator = PinchTransitionController(viewController: segue.destination)
         }
      }
      // 현재 VC를 트랜지셔닝 델리게이트로 설정한다.
      segue.destination.transitioningDelegate = self
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
   }
}


// interactiveAnimator는 이 함수의 Animator와 함께 동작한다.
// 두 애니메이터가 모두 필요하다.
// 일반 Animator를 리턴하는 메소드를 구현하지 않으면 interactiveAnimator를 리턴하는 메소드가 호출되지 않는다.
//
// 반드시 두 애니메이터를 모두 구현하고 delegate method를 통해 모두 리턴해야 한다.
extension CustomTransitionViewController: UIViewControllerTransitioningDelegate {
    // 프레젠테이션에 사용할 애니메이터가 필요할 때마다 호출된다.
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = true
        return animator
    }
    // dismiss 될때마다 호출
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
    
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactiveAnimator
    }
//    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
//        <#code#>
//    }
}



extension CustomTransitionViewController: UICollectionViewDataSource {
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return list.count
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
      
      if let imgView = cell.contentView.viewWithTag(100) as? UIImageView {
         imgView.image = list[indexPath.item]
      }
      
      return cell
   }
    
}


extension CustomTransitionViewController: UICollectionViewDelegateFlowLayout {
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: (collectionView.bounds.width / 2), height: (collectionView.bounds.width / 2) * (768.0 / 1024.0))
   }

}













