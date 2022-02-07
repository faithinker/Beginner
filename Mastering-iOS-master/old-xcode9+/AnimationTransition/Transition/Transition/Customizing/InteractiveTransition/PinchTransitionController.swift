//
//  PinchTransitionController.swift
//  Transition
//
//  Created by 김주협 on 2021/02/09.
//  Copyright © 2021 Keun young Kim. All rights reserved.
//
//
// Interactive Transition : Interactive Animator
// touch 이벤트는 제스쳐리코그나이즈로 처리한다.
// 애니메이터를 대체하는 것이 아니다.
// 사용자의 터치에 따라서 트랜지션 진행상태와 진행률을 업데이트 한다.
//
// 인터렉티브 애니메이터는 트랜지션 진행상황에 따라서 나머지 트랜지션을 완료하거나 취소 할 수 있다.


import UIKit

class PinchTransitionController: UIPercentDrivenInteractiveTransition {
    var shouldCompleteTransition = true
    
    // 터치이벤트를 처리할 뷰컨트롤러 속성을 선언
    weak var targetViewController: UIViewController?
    
    //pinch 계산에 사용할 속성
    var startScale: CGFloat = 0.0
    
    // 제스쳐 핸들러 구현
    @objc func handleGesture(_ gestureRecognizer: UIPinchGestureRecognizer) {
        let scale = gestureRecognizer.scale
        
        switch gestureRecognizer.state {
        case .began:
        // 바로 dismiss하지 않고 UIKit에게 dismiss 트랜지션이 시작 되었다는 것을 알려준다.
            targetViewController?.dismiss(animated: true, completion: nil)
            startScale = scale
        case .changed: // 진행상태 계산
            var progress = 1.0 - (scale / startScale)
            progress = CGFloat(fminf(fmaxf(Float(progress), 0.0), 1.0))
            shouldCompleteTransition = progress > 0.5 // 계산값이 0.5 이상일 때 트랜지션 완료
            update(progress) //Interactive Animator에게 진행상태를 알려준다.
        // 애니메이터를 활용해서 동적으로 업데이트 한다.
        case .cancelled:
            cancel()
        case .ended:
            if shouldCompleteTransition {
                finish()
            }else {
                cancel()
            }
        default:
            break
        }
    }
    //  생성자 구현, TargetviewController와 Pinch Gesture를 초기화 한다.
    init(viewController: UIViewController?) {
        super.init()
        
        targetViewController = viewController
        
        let gesture = UIPinchGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        targetViewController?.view.addGestureRecognizer(gesture)
    }
}
