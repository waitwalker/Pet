//
//  MTTRuntimeManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/18.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

protocol MTTObjectInitialize: class {
    static func initialized() -> Void
}

class MTTOnceTime 
{
    static func handlerOnceTime() -> Void {
        let typeCount = Int(objc_getClassList(nil, 0))
        let types = UnsafeMutablePointer<AnyClass>.allocate(capacity: typeCount)
        let autoreleasingTypes = AutoreleasingUnsafeMutablePointer<AnyClass>(types)
        objc_getClassList(autoreleasingTypes, Int32(typeCount))
        for index in 0 ..< typeCount {
            let type = types[index] as? MTTObjectInitialize.Type
            type?.initialized()
        }
        types.deallocate()
    }
}

extension UIApplication
{
    private static let runOnce:Void = {
//       MTTOnceTime.handlerOnceTime() 
    }()
    
    open override var next: UIResponder?
        {
        UIApplication.runOnce
        return super.next
    }
}

class MTTRuntimeManager: NSObject {
    
    
    /// 方法交换    
    ///
    /// - Parameters:
    ///   - forClass: 当前类 
    ///   - originalSelector: 原始的Selector 通过Selector获取方法名 
    ///   - swizzledSelector: 交换的Selector 通过Selector获取方法名 
    static func swizzledInClass(_ forClass: AnyClass, originalSelector: Selector, swizzledSelector: Selector) -> Void {
        
        let originalMethod = class_getInstanceMethod(forClass, originalSelector)
        let swizzledMethod = class_getInstanceMethod(forClass, swizzledSelector)
        
        guard originalMethod != nil && swizzledMethod != nil else {
            return
        }
        
        if class_addMethod(forClass, originalSelector, method_getImplementation(swizzledMethod!), method_getTypeEncoding(swizzledMethod!)) 
        {
            class_replaceMethod(forClass, swizzledSelector, method_getImplementation(originalMethod!), method_getTypeEncoding(originalMethod!))
        } else {
            method_exchangeImplementations(originalMethod!, swizzledMethod!)
        }
    }
    
}

