//
//  MTTWelcomePageManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/2.
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

// MARK: - ***************** class 分割线 ******************
class MTTWelcomePageManager: NSObject {
    
    // MARK: - variable 变量 属性
    
    
    // MARK: - instance method 实例方法 
    
    // MARK: - class method  类方法 
    
    
    /// 处理启动页 :是否需要出现启动页    
    ///
    /// - Parameters:
    ///   - handler: 处理者 
    ///   - appVersion: 版本      
    static func handlerWelcomePage(handler:MTTWelcomePageInterface, appVersion:String) -> Void {
        let filterStr = "name = 'petGroup'"
        
        let result = MTTRealm.queryObject(type: MTTPetGroupInfoModel.self, filter: filterStr)
        
        // 已经插入数据了 
        if (result?.count)! > Int(0) {
            let petGroup = result?.first as! MTTPetGroupInfoModel
            var isShow:Bool = false
            
            if petGroup.version == appVersion
            {
                isShow = false
                handler.iShouldShowWelcomePage(show: isShow)
            }else {
                isShow = true
                MTTRealm.sharedRealm.beginWrite()
                petGroup.version = appVersion
                try! MTTRealm.sharedRealm.commitWrite()
                handler.iShouldShowWelcomePage(show: isShow)
            }
            
        } else {
            
            MTTRealm.sharedRealm.beginWrite()
            let petGroupInfo = MTTPetGroupInfoModel()
            petGroupInfo.name = "petGroup"
            petGroupInfo.version = appVersion
            MTTRealm.sharedRealm.add(petGroupInfo)
            try! MTTRealm.sharedRealm.commitWrite()
            handler.iShouldShowWelcomePage(show: true)
        }
    }
    
    // MARK: - private method 私有方法  
    
}

