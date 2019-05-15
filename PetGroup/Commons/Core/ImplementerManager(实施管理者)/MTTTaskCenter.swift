//
//  MTTTaskCenter.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/27.
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
 任务中心 
 分配未完成任务 
 产出已完成任务 
 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/

import Foundation
import UIKit



/// 任务中心 
///
/// - deviceTypeTask: 区分设备类型任务 
public enum MTTTaskCenterTaskType:Int {
    case deviceTypeTask     = 0//设备类型任务
    case luanchProgressTask = 1//广告业任务
    case welcomePageTask    = 2//欢迎页任务
    case userIdentityTask   = 3//用户身份任务 
}


/// 任务中心父类 接口 
@available(iOS 11.0, *)
protocol MTTTaskCenterInterface {
    
    /// 注册任务中心 初始化一个辅助类和功能:
    ///
    /// - Parameter appliaction: application 
    /// - Returns: 
    func iResgisterTaskCenter(appliaction: UIApplication) -> Void 
    
    
    /// 生成操作大脑 
    ///
    /// - Parameter taskType: 任务类型 
    /// - Returns: 具体操作 
    static func iGenerateBrain(taskType:MTTTaskCenterTaskType, info:[String:Any]?) -> MTTBrainManager 
    
    
    /// 派遣任务    
    ///
    /// - Parameters:
    ///   - registerTo: 注册到具体类 
    ///   - taskType: 任务类型  
    ///   - info: info 
    /// - Returns: 
    static func iDispatchTask(registerTo:Any, taskType:MTTTaskCenterTaskType, info: [String:Any]?) -> Void 
    
    
    /// 处理广告页任务     
    ///
    /// - Parameters:
    ///   - launch: 任务处理完成接收者 
    ///   - info: info 
    /// - Returns: void 
    static func iApplyLuanchProgressPageTask(launch: MTTLaunchInterface, info:[String:Any]?) -> Void 
    
    
    /// 处理欢迎页任务 
    ///
    /// - Parameters:
    ///   - launch: 任务处理完成接收者 
    ///   - info: info 
    /// - Returns: void 
    static func iApplyWelcomePageTask(launch: MTTLaunchInterface, info: [String:Any]?) -> Void 
    
    
    /// 处理用户身份任务    
    ///
    /// - Parameters:
    ///   - userIdentity: 任务处理完成接收者 
    ///   - info: info
    /// - Returns: void
    static func iApplyUserIdentityTask(userIdentity:MTTUserIdentityInterface, info: [String:Any]?) -> Void 
}

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTTaskCenter: NSObject {
    
    // MARK: - variable 变量 属性
    static let sharedTaskCenter = MTTTaskCenter()
    
    static var MBrainManager:MTTBrainManager!
    
    
    // MARK: - instance method 实例方法 
    private override init() {
        super.init()
    }
    
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
    
}

// MARK: - ******************* 实现 接口方法 *******************
@available(iOS 11.0, *)
extension MTTTaskCenter: MTTTaskCenterInterface
{
    
    /// 注册任务中心 
    ///
    /// - Parameter appliaction: application 
    func iResgisterTaskCenter(appliaction: UIApplication) {
        
    }
    
    /// 派遣任务    
    ///
    /// - Parameters:
    ///   - registerTo: 派遣到谁 
    ///   - taskType: 任务类型 
    ///   - info: info 
    static func iDispatchTask(registerTo: Any, taskType: MTTTaskCenterTaskType, info: [String : Any]?) {
        self.MBrainManager = self.iGenerateBrain(taskType: taskType, info: info)
        switch taskType {
        case .welcomePageTask: 
            iApplyWelcomePageTask(launch: registerTo as! MTTLaunchInterface, info: info)
            break
        case .luanchProgressTask:
            iApplyLuanchProgressPageTask(launch: registerTo as! MTTLaunchInterface, info: info)
        default:
            break
        }
    }
    
    /// 根据具体任务生成具体处理者 
    ///
    /// - Parameter taskType: 任务类型 
    /// - Returns: 处理者 
    static func iGenerateBrain(taskType: MTTTaskCenterTaskType, info:[String:Any]?) -> MTTBrainManager 
    {
        return MTTBrainManager.iGenerateBrainManager(taskType: taskType, info: info)!
    }
    
    /// 处理广告页任务     
    ///
    /// - Parameters:
    ///   - launch: 
    ///   - info: info  
    static func iApplyLuanchProgressPageTask(launch: MTTLaunchInterface, info: [String : Any]?) {
        self.MBrainManager.applyLaunchProgressPageTask(launch: launch, info: info)
    }
    
    /// 处理欢迎引导页     
    ///
    /// - Parameters:
    ///   - launch: 
    ///   - info: info 
    static func iApplyWelcomePageTask(launch: MTTLaunchInterface, info: [String : Any]?) {
        let the_info:[String:MTTDeviceModelType] = ["deviceModelType": self.MBrainManager.EDeviceModelType!]
        self.MBrainManager.applyWelcomePageTask(launch: launch, info: the_info)
    }
    
    
    /// 处理用户身份回调    
    ///
    /// - Parameters:
    ///   - userIdentity: 
    ///   - info: 
    static func iApplyUserIdentityTask(userIdentity: MTTUserIdentityInterface, info: [String : Any]?) {
        
    }
}

