//
//  MTTUIImageViewExtension.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/2.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

extension UIImageView
{
    private struct AssociateKey {
        static var indexPathKey:String = "indexPathKey"
        
    }
    
    
    /// 给系统SDK API UIImageView 添加一个属性 
    var indexPath:IndexPath {
        get{
            return objc_getAssociatedObject(self, &AssociateKey.indexPathKey) as! IndexPath
        }
        
        set{
            objc_setAssociatedObject(self, &AssociateKey.indexPathKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
}
