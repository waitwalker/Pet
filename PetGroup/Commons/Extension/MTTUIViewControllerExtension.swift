//
//  MTTUIViewControllerExtension.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/7/22.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

extension UIViewController: UIGestureRecognizerDelegate, MTTObjectInitialize
{
    
    static func initialized() {
        handlerSwizzledMethod()
    }
    
    
    static func handlerSwizzledMethod() -> Void {
        if self !== UIViewController.self {
            print("!= UIViewController.self")
            return
        }
        
        let viewWillAppearOriginalSelector = #selector(viewWillAppear(_:))
        let viewWillAppearSwizzledSelector = #selector(swizzle_viewWillAppear(_:))
        MTTRuntimeManager.swizzledInClass(UIViewController.self, originalSelector: viewWillAppearOriginalSelector, swizzledSelector: viewWillAppearSwizzledSelector)
        
        let viewDidLoadOriginalSelector = #selector(viewDidLoad)
        let viewDidLoadSwizzledSelector = #selector(swizzle_viewDidLoad)
        MTTRuntimeManager.swizzledInClass(UIViewController.self, originalSelector: viewDidLoadOriginalSelector, swizzledSelector: viewDidLoadSwizzledSelector)
        
        let viewDidAppearOriginalSelector = #selector(viewDidAppear(_:))
        let viewDidAppearSwizzledSelector = #selector(swizzle_viewDidAppear(_:))
        MTTRuntimeManager.swizzledInClass(UIViewController.self, originalSelector: viewDidAppearOriginalSelector, swizzledSelector: viewDidAppearSwizzledSelector)
        
        let viewWillDisappearOriginalSelector = #selector(viewWillDisappear(_:))
        let viewWillDisappearSwizzledSelector = #selector(swizzle_viewWillDisappear(_:))
        MTTRuntimeManager.swizzledInClass(UIViewController.self, originalSelector: viewWillDisappearOriginalSelector, swizzledSelector: viewWillDisappearSwizzledSelector)
        
    }
    
    @objc func swizzle_viewWillAppear(_ animated: Bool) -> Void {
        self.swizzle_viewWillAppear(animated)
        
        if let nav = self.navigationController {
            if !self.isModal()
            {
                showLeftBackButton(nav.viewControllers.count > 1)
            }
        }
        
    }
    
    @objc func swizzle_viewDidLoad() -> Void {
        self.swizzle_viewDidLoad()
    }
    
    @objc func swizzle_viewDidAppear(_ animated: Bool) -> Void {
        self.swizzle_viewDidAppear(animated)
        if let nav = self.navigationController {
            enableSwipeGesture(nav.viewControllers.count > 1)
        }
    }
    
    @objc func swizzle_viewWillDisappear(_ animated: Bool) -> Void {
        self.swizzle_viewWillDisappear(animated)
    }
    
    func showLeftBackButton(_ shouldShow: Bool) -> Void {
        if shouldShow
        {
            let backButton = UIBarButtonItem(image: UIImage(named: "left_back"), style: UIBarButtonItem.Style.plain, target: self, action: #selector(pop))
            self.navigationItem.leftBarButtonItem = backButton
            
        } else {
            self.navigationItem.leftBarButtonItem = nil
        }
    }
    
    func enableSwipeGesture(_ shouldShow: Bool) -> Void {
        if shouldShow {
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        } else {
            navigationController?.interactivePopGestureRecognizer?.delegate = nil
            navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        }
    }
    
    func addChildVC(_ childViewController: UIViewController) -> Void {
        view.addSubview(childViewController.view)
        addChild(childViewController)
        childViewController.didMove(toParent: self)
    }
    
    func removeChildVC(_ childViewController: UIViewController) -> Void {
        childViewController.willMove(toParent: nil)
        childViewController.view.removeFromSuperview()
        childViewController.removeFromParent()
    }
    
    func dismiss() -> Void {
        self.dismiss(animated: true) {
            
        }
    }
    
    @objc func close() -> Void {
        if let nav = self.navigationController, nav.viewControllers.count > 1 {
            self.pop()
        } else {
            self.dismiss()
        }
    }
    
    @objc func pop() -> Void {
        if (self.navigationController?.viewControllers.count)! > 0 {
            
            navigationController?.popViewController(animated: true)
        } else {
            self.dismiss()
        }
    }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        }
        
        if self.presentingViewController?.presentedViewController == self {
            return true
        }
        
        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }
        
        if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    /// Get top view controller in window.
    fileprivate class func getTopViewControllerInWindow() -> UIViewController? {
        guard let window = UIApplication.shared.keyWindow else { return nil }
        
        return topViewControllerWithRootViewController(rootViewController: window.rootViewController)
    }
    
    /// Get top view controller.
    fileprivate static func topViewControllerWithRootViewController(rootViewController: UIViewController!) -> UIViewController! {
        // Tab Bar View Controller
        if rootViewController is UITabBarController {
            let tabbarController =  rootViewController as! UITabBarController
            
            return topViewControllerWithRootViewController(rootViewController: tabbarController.selectedViewController)
        }
        // Navigation ViewController
        if rootViewController is UINavigationController {
            let navigationController = rootViewController as! UINavigationController
            
            return topViewControllerWithRootViewController(rootViewController: navigationController.visibleViewController)
        }
        // Presented View Controller
        if let controller = rootViewController.presentedViewController {
            return topViewControllerWithRootViewController(rootViewController: controller)
        } else {
            return rootViewController
        }
    }
}
