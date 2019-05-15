//
//  MTTAssistantManager.swift
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
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/

enum MTTAssistantType {
    case interfaceAssistant //见面助手
    case launchAssistant    //启动助手
    case initializePetRecogniseData  //初始化宠物数据助手
}


import Foundation

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTAssistantManager: NSObject {
    
    // MARK: - variable 变量 属性
    
    // MARK: - instance method 实例方法
    // MARK: - class method  类方法
    
    static func generateAssistant(_ info: [String:Any]?, hirer: MTTAssistantInterface, assistantType: MTTAssistantType) -> Void {
        switch assistantType {
        case .interfaceAssistant:
            break
        case .launchAssistant:
            break
        case .initializePetRecogniseData:
            break
        }
    }
    
    // 将任务交给具体实施者
    static func assistantHandler(_ info: [String:Any]?, assistantType: MTTAssistantType) -> Void {
        switch assistantType {
        case .interfaceAssistant:
            let interfaceAssistant = MTTInterfaceAssistantManager()
            let application = info!["application"] as! UIApplication
            interfaceAssistant.handlerInterface(application: application)
            
        case .launchAssistant:
            handlerLaunch()
        case .initializePetRecogniseData:
            MTTPetRecogniseDataAssistant.initializePetRecogniseData()
        }
    }
    
    
    /// 处理用户主控制器 
    ///
    /// - Parameter application: application
    func handlerInterface(application: UIApplication) -> Void {
        
    }
    
    
    // MARK: - private method 私有方法
    
    
    /// 启动处理
    static func handlerLaunch() -> Void {
        let zeroDate = self.getMorningDate(date: Date())
        let zeroTimeInterval = Int(zeroDate.timeIntervalSince1970)
        
        let date = Date(timeIntervalSinceNow: 0)
        let currentTimeInterval = Int(date.timeIntervalSince1970)
        let result = MTTRealm.queryObjects(type: MTTLaunchProgressViewModel.self)
        // 已经插入数据了
        if (result?.count)! > Int(0) {
            let launchModel = result?.first as! MTTLaunchProgressViewModel
            var lastZeroTimeInterval = launchModel.lastZeroTimeInterval
            
            var isFirstLaunch:Bool = true
            
            // 是否当天启动
            if currentTimeInterval - lastZeroTimeInterval > 0 && currentTimeInterval - lastZeroTimeInterval < 3600 * 24 {
                lastZeroTimeInterval = zeroTimeInterval
                MTTUserInfoManager.sharedUserInfo.shouldLoadNewAd = false
                if launchModel.isFirstLaunch {
                    isFirstLaunch = false
                }
            } else {
                isFirstLaunch = true
                MTTUserInfoManager.sharedUserInfo.shouldLoadNewAd = isFirstLaunch
            }
            
            try! MTTRealm.sharedRealm.write {
                launchModel.isFirstLaunch = isFirstLaunch
                launchModel.lastLaunchTimeInterval = currentTimeInterval
                launchModel.lastZeroTimeInterval = lastZeroTimeInterval
            }
            //try! MTTRealm.sharedRealm.commitWrite()
            
        } else {
            MTTUserInfoManager.sharedUserInfo.shouldLoadNewAd = true
            MTTRealm.sharedRealm.beginWrite()
            let launchModel = MTTLaunchProgressViewModel()
            launchModel.isFirstLaunch = false
            launchModel.lastLaunchTimeInterval = currentTimeInterval
            launchModel.lastZeroTimeInterval = zeroTimeInterval
            MTTRealm.sharedRealm.add(launchModel)
            try! MTTRealm.sharedRealm.commitWrite()
        }
    }
    
    static func getMorningDate(date:Date) -> Date{
        let calendar = NSCalendar.init(identifier: .chinese)
        let components = calendar?.components([.year,.month,.day], from: date)
        return (calendar?.date(from: components!))!
    }
}

// MARK: - 见面助手
@available(iOS 11.0, *)
class MTTInterfaceAssistantManager: MTTAssistantManager {
    
    override func handlerInterface(application: UIApplication) {
        
        pSetupStatistic()
        
        _ = UMConfigure.deviceIDForIntegration()
        
        //MTTPrint("deviceID:\(deviceID)")
        
        self.setupMainUI()
        
        let appDelegate = application.delegate as! AppDelegate
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = makeChildControllers()
        appDelegate.window?.rootViewController = tabBarController
        appDelegate.window?.makeKeyAndVisible()
    }
    
    // 统计
    func pSetupStatistic() -> Void {
        Flurry.startSession("53JSXM4ZR45X2Q6D56X7", with: FlurrySessionBuilder
            .init()
            .withCrashReporting(true)
            .withLogLevel(FlurryLogLevelAll))
    }
    
    
    /// 实例化子控制器 
    ///
    /// - Returns: 子控制器集合 
    private func makeChildControllers() -> [UIViewController] {
        
        let controllers:[(UIViewController.Type, String, String)] = [(MTTCircleViewController.self, "萌圈", "circle"),(MTTPetRecogniseViewController.self, "鉴宠", "pet_recognise"),(MTTPetViewController.self, "我的", "personal")]
        return controllers.map {(controller, title, imageString) in
            
            let con = controller as! MTTViewController.Type
            
            let nav = UINavigationController(rootViewController: con.init(info: handlerAutoLogin()))
            nav.tabBarItem = UITabBarItem(title: "", image: imageString.normalImage, selectedImage: imageString.selectedImage)
            nav.tabBarItem.imageInsets = UIEdgeInsets(top: 8, left: 3, bottom: -8, right: -3)
            return nav
        }
    }
    
    
    /// 处理自动登录数据 
    ///
    /// - Returns: 自动登录相关数据 
    private func handlerAutoLogin() -> [String:Any] {
        
        var info:[String:Any] = ["deviceToken":"",
                                 "isNeedAutoLogin":false,
                                 "phone":"",
                                 "password":"",
                                 "isNormalLogin":true,
                                 "header_photo":""
                                 ]
        
        let realm = MTTRealm.realm()
        let results = realm.objects(MTTLoginInfoTable.self)
        if results.count > 0 {
            let result = results.first
            
            let deviceToken = result?.deviceToken
            let isNeedAutoLogin = result?.isNeedAutoLogin
            let phone = result?.phone
            let password = result?.password
            let isNormalLogin = result?.isNormalLogin
            let header_photo = result?.header_photo
            
            
            
            info.updateValue(deviceToken as Any, forKey: "deviceToken")
            info.updateValue(isNeedAutoLogin as Any, forKey: "isNeedAutoLogin")
            info.updateValue(phone as Any, forKey: "phone")
            info.updateValue(password as Any, forKey: "password")
            info.updateValue(isNormalLogin as Any, forKey: "isNormalLogin")
            info.updateValue(header_photo as Any, forKey: "header_photo")
        }
        
        MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin = info["isNeedAutoLogin"] as! Bool
        MTTUserInfoManager.sharedUserInfo.deviceToken = info["deviceToken"] as! String
        MTTUserInfoManager.sharedUserInfo.phone = info["phone"] as! String
        MTTUserInfoManager.sharedUserInfo.password = info["password"] as! String
        MTTUserInfoManager.sharedUserInfo.isNormalLogin = info["isNormalLogin"] as! Bool
        MTTUserInfoManager.sharedUserInfo.header_photo = info["header_photo"] as! String
        
        return info
    }
    
    private func setupMainUI() -> Void {
        
        //UIView.appearance().tintColor = Color.Brand
        
//        UITableView.appearance().backgroundColor = Color.Background
//        UITableView.appearance().separatorColor = Color.Separator
        
        UINavigationBar.appearance().isTranslucent = false
        UINavigationBar.appearance().barTintColor = UIColor.colorWithString(colorString: "#3399ff")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.font:  UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor.white]
        
        UITabBar.appearance().isTranslucent = false
        UITabBar.appearance().backgroundColor = UIColor.white.withAlphaComponent(0.5)
//        UITabBar.appearance().tintColor = Color.TabItemSelected
        
    }
}

@available(iOS 11.0, *)
class MTTPetRecogniseDataAssistant: MTTAssistantManager {
    
    static func initializePetRecogniseData() -> Void {
        let results = MTTRealm.queryObjects(type: MTTPetRecogniseDataInfo.self)
        if results != nil && (results?.count)! > 0 {
            return
        } else {
            let timeInterval:TimeInterval = 2.0
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval) { 
                
                for (index, value) in MTTPetRecogniseModel.originalObjects.enumerated() {
                    MTTRealm.sharedRealm.beginWrite()
                    let petRecongniseInfo = MTTPetRecogniseDataInfo()
                    petRecongniseInfo.id = UUID().uuidString
                    petRecongniseInfo.objectEnglishName = value
                    petRecongniseInfo.objectChineseName = MTTPetRecogniseModel.translateObjects[index]
                    MTTRealm.sharedRealm.add(petRecongniseInfo)
                    try! MTTRealm.sharedRealm.commitWrite()
                }
            }
        }
    }
}
