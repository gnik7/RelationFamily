//
//  Router.swift
//  RelationFamily
//
//  Created by Nikita Gil on 07.01.17.
//  Copyright © 2017 Nikita Gil. All rights reserved.
//

import UIKit

class Router: NSObject {
    
    private var navigationController : UINavigationController?
    let animator = Animator()
    
    //*****************************************************************
    // MARK: - Init
    //*****************************************************************
    
    init(navigationController :UINavigationController)  {
        
        self.navigationController = navigationController
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func popViewController(animated: Bool) {
        self.navigationController?.popViewController(animated: animated)
    }
    
    func visibleViewController() -> UIViewController {
        return (self.navigationController?.visibleViewController)!
    }
    
//    func popToRootViewController() {
//        self.navigationController?.popToRootViewController(animated: true)
//    }
    
    class func topViewController() -> UIViewController {
        
        return (UIApplication.shared.keyWindow?.rootViewController)!
    }
    
    class func navigationControllerWithID(identifier :String, storyboardName :String) -> UIViewController {
        
        let storyboard = UIStoryboard.init(name: storyboardName, bundle: nil)
        let mainViewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return mainViewController
    }
    
    //*****************************************************************
    // MARK: - Private
    //*****************************************************************
    
    private class func viewControllerWithClass(className: String, storybordName :String) -> UIViewController {
        let storyboard = UIStoryboard.init(name: storybordName, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: String(className))
        return viewController
    }
    
    func switchRootViewController(rootViewController: UIViewController, animated: Bool, completion: (() -> Void)?) {
        
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        
        if animated {
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: {
                let oldState: Bool = UIView.areAnimationsEnabled
                UIView.setAnimationsEnabled(false)
                let navigation = UINavigationController(rootViewController: rootViewController)
                window.rootViewController = navigation
                UIView.setAnimationsEnabled(oldState)
            }, completion: { (finished: Bool) -> () in
                if (completion != nil) {
                    completion!()
                }
            })
        } else {
            window.rootViewController = rootViewController
        }
    }
    
    //*****************************************************************
    // MARK: - Home
    //*****************************************************************
    
    
    func setupHomeRootViewController() {
        
        let mainViewController = Router.viewControllerWithClass(className: String(describing: HomeViewController.self), storybordName: "Home")
        self.navigationController = UINavigationController(rootViewController: mainViewController)
        self.navigationController?.delegate = self
        UIApplication.shared.delegate?.window??.rootViewController = self.navigationController
    }
    
    func showInfoViewController() {
        
        let viewController = Router.viewControllerWithClass(className: String(describing: InfoViewController.self) , storybordName: "Home") as! InfoViewController
        self.navigationController?.delegate = self
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension Router: UINavigationControllerDelegate {
    
    //*****************************************************************
    // MARK: - UINavigationControllerDelegate
    //*****************************************************************

    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if operation == UINavigationControllerOperation.push {
            return self.animator
        }
        if operation == UINavigationControllerOperation.pop {
            return self.animator
        }
        return nil
    }
}

class Animator: NSObject {
    
}

extension Animator: UIViewControllerAnimatedTransitioning {
    
    internal func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0
    }
    
    internal func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        _ = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(
            forKey: UITransitionContextViewControllerKey.to)
        
        containerView.addSubview(toVC!.view)
        toVC!.view.alpha = 0.0
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toVC!.view.alpha = 1.0
        }, completion: { finished in
            let cancelled = transitionContext.transitionWasCancelled
            transitionContext.completeTransition(!cancelled)
        })
    }
}

