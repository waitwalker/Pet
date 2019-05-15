//
//  Target_CircleViewController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/13.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
@objc(Target_CircleViewController)
class Target_CircleViewController: NSObject {
    
    @objc
    func Action_registerCircleModule(parameter:[String:Any]?) -> UIViewController {
        let circleVC = MTTCircleViewController(info: parameter)
        return circleVC
    }
    
}
