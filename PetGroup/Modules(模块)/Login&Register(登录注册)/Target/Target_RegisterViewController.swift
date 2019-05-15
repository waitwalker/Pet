//
//  Target_RegisterViewController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/25.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

@available(iOS 11.0, *)
@objc(Target_RegisterViewController)
class Target_RegisterViewController: NSObject {
    
    @objc
    func Action_registerRegisterModule(parameter:[String:Any]?) -> UIViewController {
        
        if parameter == nil {
            return MTTiPhoneRegisterViewController(info: nil)
        }
        
        let isiPhoneDevice = parameter!["isiPhoneDevice"] as! Bool
        if isiPhoneDevice 
        {
            return MTTiPhoneRegisterViewController(info: parameter)
        } else {
            return MTTiPadRegisterViewController(info: parameter)
        }
    }
}
