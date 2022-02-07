//
//  ZoomAnimationController.swift
//  Transition
//
//  Created by 김주협 on 2021/02/09.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//
//
//  임시 이미지를 활용해서 Collection Cell View => 전체 Frame으로 확대하고 ToViewVC를 표시한다.
//
//  복구 할 때 취소 버튼이 자연스럽게 되도록 구현 -> ImageViewController > topConstraint

import UIKit

class ZoomAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    //트랜지션 실행시간으로 사용한다.
    let duration = TimeInterval(1)
    
    //트랜지션 대상 셀에 인덱스 패스와 이미지를 속성으로 선언
    var targetIndexPath: IndexPath?
    var targetImage: UIImage?
    
    //트랜지션 방향을 구분
    var presenting = true
    
    // 트랜지션 시간을 리턴
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    // 실제 트랜지션 코드를 이 함수에서 구현한다. 중요하다.
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        //프레젠테이션 if블록 구현
        if presenting {
        // 파라미터로 전달되는 Context에는 트랜지션 VC가 저장되어 있다.
        // 트랜지션이 시작되는 VC, 사라질 뷰 : From View Controller
        // From View Controller  -> naviagtor에 임베드 되어 있다. 그래서 가장 마지막에 있는 child에 접근해야 한다.
            guard let fromVC = transitionContext.viewController(forKey: .from)?.childViewControllers.last as? CustomTransitionViewController else { fatalError() }
        
        // transtion을 통해 새롭게 표시되는 VC, 나타날 뷰 : To View Controller
            guard let toVC = transitionContext.viewController(forKey: .to) as? ImageViewController else { fatalError() }
        
        // RootView 접근
            guard let fromView = transitionContext.view(forKey: .from) else { fatalError() }
            guard let toView = transitionContext.view(forKey: .to) else { fatalError() }
            
        // fromView는 자동으로 추가되지만 toView는 직접 추가해야한다.
            toView.alpha = 0.0
            containerView.addSubview(toView)
            
            
        // 사용자가 선택한 cell에 접근해서 CellFrame을 얻은 다음, RootView 좌표로 변환하고 상수에 저장한다.
            let targetCell = fromVC.listCollectionView.cellForItem(at: targetIndexPath!)
            let startFrame = fromVC.listCollectionView.convert(targetCell!.frame, to: fromView)
            
        //  트랜지션에 사용할 이미지 뷰를 생성
            let imgView = UIImageView(frame: startFrame)
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFill
            imgView.image = targetImage
            containerView.addSubview(imgView) // 사용자가 선택한 이미지를 설정하고 컨테이너뷰에 추가한다.
            
        // 최종 프레임을 상수에 저장하고 이미지 뷰 프레임 속성에 애니메이션을 적용한다.
            let finalFrame = containerView.bounds
            
        // 트랜지션이 완료된면 임시로 추가한 이미지뷰가 여전히 화면에 표시되어 있다.
        // completion Handler에서 이미지 뷰를 제거하고 toView 컨트롤러를 표시해야 한다.
            UIView.animate(withDuration: duration) {
                imgView.frame = finalFrame
            } completion: { (finished) in
                toView.alpha = 1.0
                imgView.alpha = 0.0
                imgView.removeFromSuperview()
                toVC.showCloseButton()
                
        // 트랜지션이 완료되면 컨텍스트에서 컴플리트 트랜지션 메소드를 반드시 호출해야 한다.
        // 이 메소드를 호출해야 UIKit이 트랜지션이 종료되었다는 것을 인식 할 수 있다.
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }

            
        
            
            
        
        }else {// dismissal transition을 구현, 이미지가 원래 위치로 돌아감. 강의 18분 부터
        // presenting Controller 가 ToView
        // Presented Controller가 FromView
            guard let toVC = transitionContext.viewController(forKey: .to)?.childViewControllers.last as? CustomTransitionViewController else { fatalError() }
            guard let fromVC = transitionContext.viewController(forKey: .from) as? ImageViewController else { fatalError() }
        
        
            
        // containerView에 추가하기 전에 Frame을 업데이트 해야한다.
            toVC.navigationController?.view.frame = containerView.bounds
        // containerView에 ToView에 RootView를 추가
        // 이전과 달리 ToVC는 네비게이션에 임베디드 되어 있다. naviControl에 루트뷰를 추가해야 한다.
            containerView.addSubview(toVC.navigationController!.view)
        // 화면을 새로운 프레임에 맞게 업데이트 한다.
            toVC.view.layoutIfNeeded()
            
        // 트랜지션에 사용할 이미지 뷰를 생성,
        // 프레젠테이션에서 만든 이미지 뷰와 동일하지만 시작 프레임을 fromview와 동일하게 설정
            let startFrame = fromVC.imageView.frame
            
            let imgView = UIImageView(frame: startFrame)
            imgView.clipsToBounds = true
            imgView.contentMode = .scaleAspectFit
            imgView.image = targetImage
            containerView.addSubview(imgView) //컨테이너뷰에 추가
            
        // 화면에서 감춤.
        // toVC에 있는 원래 위치로 돌아갈려면 fromVC 표시되지 않은 상태에서 트랜지션을 실행해야 한다.
            fromVC.view.alpha = 0.0
            
            let targetCell = toVC.listCollectionView.cellForItem(at: targetIndexPath!)
            let finalFrame = toVC.listCollectionView.convert(targetCell!.frame, to: toVC.view)
            
        // image뷰를 최종 프레임으로 애니메이션 시킨 다음, completion 핸들러에서 이미지를 제거한다.
            UIView.animate(withDuration: duration) {
                imgView.frame = finalFrame
                
            } completion: { (finished) in
                let success = !transitionContext.transitionWasCancelled
                
                //트랜지션이 취소되면.. 도로 보이도록 하고(117Line), toVC를(101 Line) 도로 제거
                if !success {
                    fromVC.view.alpha = 1.0
                    toVC.navigationController!.view.removeFromSuperview()
                }
                
                imgView.alpha = 0.0
                imgView.removeFromSuperview()
                
        // 트랜지션 완료후 호출
                transitionContext.completeTransition(success)
            }

        }
        
        
        
        
    }
    

}

//extension ZoomAnimationController : UIViewControllerTransitioningDelegate {
//    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
//
//        return true
//    }
//}
