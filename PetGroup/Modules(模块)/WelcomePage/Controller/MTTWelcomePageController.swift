//
//  MTTWelcomePageController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/22.
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
 视图相关:V开头 驼峰式 
 控制器相关:C开头 驼峰式 
 数据相关:M开头 驼峰式 
 代理相关:D开头 驼峰式 
 其他类似
 
 1. 类的功能:
 欢迎引导类 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/



import UIKit
import RealmSwift


/// controller delegate 回调 
protocol MTTWelcomePageControllerDelegate {
    
    /// 点击跳过按钮的最终回调 
    ///
    /// - Parameter info: info 
    /// - Returns: void 
    func DTappedSkipButtonCallBack(info:[String:Any]?) -> Void 
}

// MARK: - ***************** class 分割线 ******************
class MTTWelcomePageController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var OInfo:[String:Any]?
    var DDelegate:MTTWelcomePageControllerDelegate?
    
    
    /// 构造函数  
    ///
    /// - Parameter info: info 
    required init(info:[String:Any]?) {
        super.init(info: info)
        self.OInfo = info
    }
    
    /// 析构函数 
    deinit {
        print("welcome release")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let welcomePage = MTTWelcomePageView(frame: self.view.bounds, info: self.pSetupParameter(info: self.OInfo!))
        welcomePage.DDelegate = self
        self.view.addSubview(welcomePage)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func pSetupParameter(info:[String:Any]) -> [String:Any] {
        
        var parameter:[String:Any] = [:]
        var preString:String = ""
        var imageStrings:[String] = []
        
        
        let deviceModelType:MTTDeviceModelType = info["deviceModelType"] as! MTTDeviceModelType
        let totalCount:Int = info["totalCount"] as! Int
        
        
        switch deviceModelType {
        case .iPhone_5, .iPhone_5c, .iPhone_5s, .iPhone_SE:
            preString = "iPhone_5"
        case .iPhone_6, .iPhone_6s, .iPhone_7, .iPhone_8:
            preString = "iPhone_6"
        case .iPhone_6_plus, .iPhone_6s_plus, .iPhone_7_plus, .iPhone_8_plus:
            preString = "iPhone_6_plus"
        case .iPhone_X:
            preString = "iPhone_X"
        default:
            preString = "iPad"
        }
        
        for i in 0..<totalCount {
            let str = "welcome_page_" + String(i)
            imageStrings.append(str)
        }
        parameter.updateValue(imageStrings, forKey: "imageStrings")
        return parameter
    }
    
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}

extension MTTWelcomePageController:MTTWelcomePageViewDelegate
{
    func DTappedSkipButton(welcomePageView: MTTWelcomePageView?, info: [String : Any]?) {
        self.DDelegate?.DTappedSkipButtonCallBack(info: info)
    }
    
}

