//
//  SimplePresentationController.swift
//  Transition
//
//  Created by 김주협 on 2021/02/08.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class SimplePresentationController: UIPresentationController {
    //visual EffectView 저장
    let dimmingView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
    
    //버튼에 애니메이션 지정
    let closeButton = UIButton(type: .custom)
    let closeImage = UIImage(systemName: "xmark.circle")
    
    // Close Button이 dismiss 할 때 좀 더 자연스럽게 사라지도록 하기 위한 코드
    let workaroundView = UIView()
    
    
    
    var closeButtonTopConstraint : NSLayoutConstraint?
    
    // 지정 생성자를 overriding
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        
        
        
        
        
        
        // frmae 개인설정이 가능
        
        // 버튼 이미지 추가, 액션 생성
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        // 프로토타이핑 제약이 추가되지 않도록 설정
        closeButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    // 닫기 버튼을 탭하면 호출된다.
    @objc func dismiss() {
        presentingViewController.dismiss(animated: true, completion: nil)
    }
    //presentation은 container라는 특별한 뷰에서 실행된다.
    //presentedVC는 container View 전체를 채우지만 이속성을 overriding하고 원하는 프레임으로 조정한다.
    override var frameOfPresentedViewInContainerView: CGRect {
        print(String(describing: type(of: self)), #function)
        
        guard var frame = containerView?.frame else { return .zero}
        
        frame.origin.y = frame.size.height/2
        frame.size.height = frame.size.height/2
        
        return frame     // presentedView의 크기
    }
    
    // animation에 필요한 속성 설정하고 실제 애니 구현
    // *가장 중요한 overriding 포인트이다.*
    override func presentationTransitionWillBegin() {
        print("\n\n")
        print(String(describing: type(of: self)), #function)
        
        // containerView를 상수에 바인딩
        guard let containerView = containerView else { fatalError() }
        
        // transition에 사용되는 모든 CustomView는 반드시 Container 속성이 return 하는 뷰에 추가해야 한다.
        // frame과 alpha 속성을 설정하고 container에 추가한다.
        dimmingView.alpha = 0.0
        dimmingView.frame = containerView.bounds
        containerView.insertSubview(dimmingView, at: 0)
        
        // 컨테이너에 더미 뷰를 추가한다.
        workaroundView.frame = dimmingView.bounds
        workaroundView.isUserInteractionEnabled = false
        containerView.insertSubview(workaroundView, aboveSubview: dimmingView)
        
        
        // 닫기버튼은 컨테이너뷰에 추가하고 제약을 추가한다.
        containerView.addSubview(closeButton)
        // 수평 가운데 정렬을 추가한다.
        closeButton.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        closeButtonTopConstraint = closeButton.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -80)
        closeButtonTopConstraint?.isActive = true
        containerView.layoutIfNeeded()
        
        // Top 제약추가, animation 실행
        closeButtonTopConstraint?.constant = 60
        
        guard let coordinator = presentedViewController.transitionCoordinator else { return dimmingView.alpha = 1.0
            presentingViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            containerView.layoutIfNeeded()
            return
        }
        
        // 애니 코드
        coordinator.animate(alongsideTransition: { (context) in
        self.dimmingView.alpha = 1.0
        self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        containerView.layoutIfNeeded()
        }, completion: nil)

    }
    
   //presentation이 완료된 후에 호출
    override func presentationTransitionDidEnd(_ completed: Bool) {
        print("\n\n")
        print(String(describing: type(of: self)), #function)
    }
    
    // 프레젠에서 추가한 닫기버튼과 dimming뷰는 여전히 프레젠 컨트롤러가 관리하고 있다. 다시 생성할 필요는 없다.
    // 닫기버튼과 dimming 뷰를 컨테이너에서 제거하고 프레젠뷰를 원래 크기로 복구한다.
    
    
    override func dismissalTransitionWillBegin() {
        print(String(describing: type(of: self)), #function)
        
        closeButtonTopConstraint?.constant = -80
        
        guard let coordinator = presentedViewController.transitionCoordinator else { dimmingView.alpha = 0.0
            presentingViewController.view.transform = CGAffineTransform.identity
            containerView?.layoutIfNeeded()
            return
        }
        
        
        coordinator.animate(alongsideTransition: { (context) in
        self.dimmingView.alpha = 1.0
        self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        self.containerView?.layoutIfNeeded()
        }, completion: nil)
        
// 원래는 위에 5줄이 맞는데 completion이 후행클로전화되서 바뀐다.
//        coordinator.animate { (context) in
//            self.dimmingView.alpha = 1.0
//            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
//            self.containerView?.layoutIfNeeded()
//        } completion: { (error) in
//            print(error)
//        }

    }
    
    // 화면을 제거한 다음 호출되는 뷰
    override func dismissalTransitionDidEnd(_ completed: Bool) {
        print(String(describing: type(of: self)), #function)
    }
    
    
    // 아래 두개 메소드는 transtion이 호출되는 동안 실행한다.
    // 주로 ContainerView에 추가한 CustomView를 추가할 때 쓴다.
    override func containerViewWillLayoutSubviews() {
        print(String(describing: type(of: self)), #function)
        
        //가로 회전시 autolayout을 하지못한 dimmingView와 presentedView가 깨짐
        // 닫기 dismiss를 해도 부모 VC에 UI가 빈 여백이 생김
        // 이유는 trasnform을 적용할 때 잘못된 스케일이 적용되기 때문이다.
        presentedView?.frame = frameOfPresentedViewInContainerView
        dimmingView.frame = containerView!.bounds
    }
    override func containerViewDidLayoutSubviews() {
        print(String(describing: type(of: self)), #function)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // 상위구현 호출
        super.viewWillTransition(to: size, with: coordinator)
        
        presentingViewController.view.transform = CGAffineTransform.identity
        
        coordinator.animate { (context) in
            self.presentingViewController.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.9)
        } completion: { (error) in
            print(error)
        }

    }

    
    
    // 컨테이너 뷰가 업데이트 되면 두가지 방법으로 처리한다.
    // 1. containerViewWillLayoutSubviews 메소드에서 frame을 업데이트 한다.
    // 2. viewWillTransition 메소드를 overriding 하는 것이다.
    
    
    
    //반복되는 호출되는 method는 가능한 빠르게 return해야 속도가 느려지지 않는다. (trans, ani 부드럽게 실행)

}
