//
//  MTTFingerManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/4.
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
 手指类:处理广告页功能 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTFingerManager: MTTBrainManager {
    
    // MARK: - variable 变量 属性
    private var ILaunch:MTTLaunchInterface!
    private var VProgressView:MTTLaunchProgressView!
    
    
    // MARK: - instance method 实例方法 
    override init() {
        super.init()
    }
    
    override func applyLaunchProgressPageTask(launch: MTTLaunchInterface, info: [String : Any]?) {
        self.ILaunch = launch
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        VProgressView = MTTLaunchProgressView(frame: UIScreen.main.bounds, info: info, progress: self)
        
        appDelegate.window?.addSubview(VProgressView)
    }
    
    
    /// 移除 广告页 
    private func pRemoveProgressView() -> Void {
        if VProgressView != nil {
            VProgressView.removeFromSuperview()
            VProgressView = nil
        }
    }
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}

@available(iOS 11.0, *)
extension MTTFingerManager:MTTProgressInterface
{
    func iTappedImageAction(info: [String : Any]?) {
        self.pRemoveProgressView()
        ILaunch.iLaunchProgressPage(info: info)
    }
    
    func iTappedSkipButtonAction(info: [String : Any]?) {
        UIView.animate(withDuration: 0.5, animations: { 
            self.VProgressView.alpha = 0
        }) { (completed) in
            if completed 
            {
                self.pRemoveProgressView()
            }
        }
    }
    
    
}
