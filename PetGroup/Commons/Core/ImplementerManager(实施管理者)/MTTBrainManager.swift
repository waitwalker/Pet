//
//  MTTBrainManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/26.
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
 任务
 |
 生成大脑
 |
 组装躯体
 |
 分配任务
 |
 躯体组件领取任务
 |
 实施任务
 |
 输出任务结果
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation
import UIKit

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTBrainManager: NSObject {
    
    // MARK: - variable 变量 属性
    var EDeviceModelType:MTTDeviceModelType?
    
    // MARK: - instance method 实例方法 
    
    override init() {
        super.init()
        self.EDeviceModelType = MTTDeviceInfoManager.currentDeviceManager.deviceModelTypeName
    }
    
    
    /// 生成大脑 
    ///
    /// - Returns: 
    static func iGenerateBrainManager(taskType: MTTTaskCenterTaskType, info:[String:Any]?) -> MTTBrainManager?
    {
        /// 大脑指挥 分配任务
        switch taskType {
        
            //欢迎引导任务交由 手臂和大腿去完成 
        case .welcomePageTask:
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
            {
                return MTTArmManager()
            } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
            {
                return MTTLegManager()
            }
            
            //广告页任务交由手指去完成 
        case .luanchProgressTask:
            return MTTFingerManager()
        
        case .userIdentityTask:
            let identity = info!["identity"] as! Int
            if identity == 1
            {
                
            } else {
                
            }
            
            
        default:
            return nil
        }
        return nil
    }
    
    
    /// 欢迎页     
    ///
    /// - Parameters:
    ///   - launch: 启动接口 
    ///   - info: 信息 
    func applyWelcomePageTask(launch: MTTLaunchInterface, info: [String : Any]?) {
        
    }
    
    
    /// 广告页         
    ///
    /// - Parameters:
    ///   - launch: 接口调用者 
    ///   - info: 参数 
    func applyLaunchProgressPageTask(launch: MTTLaunchInterface, info: [String: Any]?) -> Void {
        
    }
    
    
    /// 处理用户身份  
    ///
    /// - Parameters:
    ///   - userIdentity: 接口调用者 
    ///   - info: info 
    func applyUserIdentityTask(userIdentity: MTTUserIdentityInterface, info: [String : Any]?) -> Void {
        
    }
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}


