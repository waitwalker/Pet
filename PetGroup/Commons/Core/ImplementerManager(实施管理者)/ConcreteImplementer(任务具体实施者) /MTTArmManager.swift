//
//  MTTArmManager.swift
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
class MTTArmManager: MTTBrainManager {
    
    // MARK: - variable 变量 属性
    
    // MARK: - instance method 实例方法 
    
    
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
    func pGetDeviceModelType() -> MTTDeviceModelType {
        return MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName
    }
    
    override func applyWelcomePageTask(launch: MTTLaunchInterface, info: [String : Any]?) {
        launch.iLaunchiPhoneDeviceWelcomePage(info: info)
    }
}

