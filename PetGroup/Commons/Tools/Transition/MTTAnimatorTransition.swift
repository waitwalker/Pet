//
//  MTTAnimatorTransition.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/5.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

/********** 文件说明 **********
 命名:见名知意
 方法前缀:
 私有方法:p开头 驼峰式
 代理方法:d开头 驼峰式
 接口方法:i开头 驼峰式
 其他类似
 
 成员变量(属性)前缀:
 视图相关:V开头 驼峰式 View
 控制器相关:C开头 驼峰式 Controller
 数据相关:M开头 驼峰式 Model
 viewModel相关: VM开头
 代理相关:D开头 驼峰式 delegate
 枚举相关:E开头 驼峰式 enum
 闭包相关:B开头 驼峰式 block
 bool类型相关:is开头 驼峰式
 其他相关:O开头 驼峰式 other
 其他类似
 
 1. 类的功能:
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/

import Foundation

// MARK: - 转场动画管理类
class MTTAnimatorTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    let direation:TimeInterval = 0.25
    
    var isShowPhotoBrowser:Bool = true
    
    
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return direation
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        // 获取容器视图
        let containerView = transitionContext.containerView
        
        // 判断是 present 还是dismiss
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from), let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return
            MTTPrint("获取ViewController  失败")
            transitionContext.completeTransition(false)
        }
        let presetion = (toVC.presentingViewController == fromVC)
        
        guard let openingView = transitionContext.view(forKey: presetion ? UITransitionContextViewKey.to : UITransitionContextViewKey.from) else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            
            MTTPrint("获取要打开的视图 失败")
            transitionContext.completeTransition(false)
            return
        }
        
        if presetion {
            containerView.addSubview(openingView)
        }
        
        //视图
        let beginAlpha = presetion ? 0.0 : openingView.alpha
        let endAlpha = presetion ? openingView.alpha : 0.0
        openingView.alpha = beginAlpha
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            openingView.alpha = endAlpha
        }) { (completed) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
    

    // MARK: - variable 变量 属性

    // MARK: - instance method 实例方法
    override init() {
        super.init()
    }
    // MARK: - class method  类方法
    
    // MARK: - private method 私有方法
    
    deinit {
        
    }
    
}
