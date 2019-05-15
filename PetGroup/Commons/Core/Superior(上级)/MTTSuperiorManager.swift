//
//  MTTSuperiorManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/5.
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
 上级管理者 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation
import IQKeyboardManagerSwift

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTSuperiorManager: NSObject {
    
    // MARK: - variable 变量 属性
    private var OReachability:Reachability?
    var DDelegate:MTTNetworkConnectTypeDelegate?
    
    // MARK: - instance method 实例方法 
    static let sharedSuperiorManager = MTTSuperiorManager()
    override init() {
        super.init()
        //MTTNetworkManager.sharedManager
    }
    
    func registerSuperiorManager() -> Void {
        //初始化工作 
        setupReachability(hostName: "www.baidu.com")
        
        let _ = MTTNetworkManager.sharedManager
        
        // 键盘弹出 视图上移
        IQKeyboardManager.shared.enable = true
        
        // swizzle method 
        UIViewController.initialized()
    }
    
    func applyAssitant(application: UIApplication, assistantType:MTTAssistantType) -> Void {
        MTTAssistantManager.assistantHandler(["application": application], assistantType: assistantType)
    }
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 初始化网络设置模块  
    private func setupReachability(hostName: String?) -> Void {
        if let hostNames = hostName {
            OReachability = Reachability(hostname: hostNames)
        } else {
            OReachability = Reachability(hostname: "www.baidu.com")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChangedAction(notify:)), name: .reachabilityChanged, object: nil)
        do {
            try OReachability?.startNotifier()
        } catch {
            print("reach error:")
            return
        }
    }
    
    @objc func reachabilityChangedAction(notify:Notification) -> Void {
        let reach = notify.object as! Reachability
        var type:MTTNetworkConnectType = .waiting
        if reach.connection != .none {
            if reach.connection == .wifi
            {
                type = .ethernetOrWiFi
            } else {
                type = .WWAN
            }
        } else {
            type = .notReachable
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNetworkStatusNotify), object: ["connectType": type])
    }
    
}
