//
//  MTTUIButtonExtension.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/18.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

public enum MTTButtonImagePostion 
{
    case Top
    case Left
    case Bottom
    case Right
}

extension UIButton
{
    
    /// 监听按钮事件  
    ///
    /// - Parameters:
    ///   - target: 事件(消息)的接收者
    ///   - action: 事件回调 
    ///   - controlEvents: 事件类型 
    func addTargetTo(_ target: Any?, action: Selector, for controlEvents: UIControl.Event) -> Void {
        UIApplication.shared.keyWindow?.endEditing(true)
        self.addTarget(target, action: action, for: controlEvents)
    }
    
    
    /// 重写父类中方法 拦截所有事件  
    ///
    /// - Parameters:
    ///   - action: 事件  
    ///   - target: 消息接收者 
    ///   - event: 事件类型 
    open override func sendAction(_ action: Selector, to target: Any?, for event: UIEvent?) {
        UIApplication.shared.keyWindow?.endEditing(true)
        super.sendAction(action, to: target, for: event)
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin == true {
            
        } else {
//            let info:[String:Any] = ["action":action, "target": target as Any]
//            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNeedLoginNotify), object: info)
        }
    }
    
    /// 设置按钮中图片和文字的间距   
    ///
    /// - Parameters:
    ///   - postion: 图片的位置 相对于文字 
    ///   - spacing: 间距 
    public func setImageWithPosition(postion:MTTButtonImagePostion,spacing:CGFloat) -> Void {
        self.setTitle(self.currentTitle, for: UIControl.State.normal)
        self.setImage(self.currentImage, for: UIControl.State.normal)
        
        let imageWidth = self.imageView?.image?.size.width
        let imageHeight = self.imageView?.image?.size.height
        
        let titleLabelTitle:NSString = (self.titleLabel?.text! as NSString?)!
        
        let labelWidth = titleLabelTitle.size(withAttributes: [NSAttributedString.Key.font : self.titleLabel?.font as Any]).width
        let labelHeight = titleLabelTitle.size(withAttributes: [NSAttributedString.Key.font : self.titleLabel?.font as Any]).height
        
        let imageOffsetX = (imageWidth! + labelWidth) / 2 - imageWidth! / 2 //image中心移动的x距离
        let imageOffsetY = imageHeight! / 2 + spacing / 2 //image中心移动的y距离
        let labelOffsetX = (imageWidth! + labelWidth / 2) - (imageWidth! + labelWidth) / 2 //label中心移动的x距离
        let labelOffsetY = labelHeight / 2 + spacing / 2 //label中心移动的y距离
        
        let tempWidth = max(labelWidth, labelWidth)
        let changedWidth = labelWidth + imageWidth! - tempWidth;
        let tempHeight = max(labelHeight, imageHeight!) 
        let changedHeight = labelHeight + imageHeight! + spacing - tempHeight 
        
        switch postion 
        {
        case MTTButtonImagePostion.Left:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: -spacing/2, bottom: 0, right: spacing/2);
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: -spacing/2);
            self.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: spacing/2);
            break
        case MTTButtonImagePostion.Right:
            self.imageEdgeInsets = UIEdgeInsets.init(top: 0, left: labelWidth + spacing/2, bottom: 0, right: -(labelWidth + spacing/2));
            self.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: -(imageWidth! + spacing/2), bottom: 0, right: imageWidth! + spacing/2);
            self.contentEdgeInsets = UIEdgeInsets.init(top: 0, left: spacing/2, bottom: 0, right: spacing/2);
            break
        case MTTButtonImagePostion.Top:
            self.imageEdgeInsets = UIEdgeInsets.init(top: -imageOffsetY, left: imageOffsetX, bottom: imageOffsetY, right: -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsets.init(top: labelOffsetY, left: -labelOffsetX, bottom: -labelOffsetY, right: labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsets.init(top: imageOffsetY, left: -changedWidth/2, bottom: changedHeight-imageOffsetY, right: -changedWidth/2);
            break
        case MTTButtonImagePostion.Bottom:
            self.imageEdgeInsets = UIEdgeInsets.init(top: imageOffsetY, left: imageOffsetX, bottom: -imageOffsetY, right: -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsets.init(top: -labelOffsetY, left: -labelOffsetX, bottom: labelOffsetY, right: labelOffsetX);
            self.contentEdgeInsets = UIEdgeInsets.init(top: changedHeight-imageOffsetY, left: -changedWidth/2, bottom: imageOffsetY, right: -changedWidth/2);
            break
        }
    }
}

extension UIButton: MTTObjectInitialize
{
    static func initialized() {
        //handlerSwizzleMethod()
    }
    
    static func handlerSwizzleMethod() -> Void {
        
        let originalSelector = #selector(sendAction(_:to:for:))
        
        let swizzledSelector = #selector(swizzled_send(_:to:for:))
        
        MTTRuntimeManager.swizzledInClass(UIButton.self, originalSelector: originalSelector, swizzledSelector: swizzledSelector)
        
    }
    
    @objc func swizzled_send(_ action: Selector, to target: Any?, for event: UIEvent?) -> Void {
        
        swizzled_send(action, to: target, for: event)
    }
}
