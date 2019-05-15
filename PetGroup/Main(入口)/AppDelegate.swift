//
//  AppDelegate.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/7.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit
import UserNotifications

@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        MTTSuperiorManager.sharedSuperiorManager.registerSuperiorManager()
        
        MTTSuperiorManager.sharedSuperiorManager.applyAssitant(application: application, assistantType: MTTAssistantType.launchAssistant)
        
        // 注册欢迎引导页,判断是否弹出欢迎引导页
        MTTWelcomePageManager.handlerWelcomePage(handler: self, appVersion: MTTDeviceInfoManager.currentDeviceManager.appVersion)
        
        pSetupUMeng(launchOptions: launchOptions)
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let data = NSData(data: deviceToken)
        let device = data.description.replacingOccurrences(of:"<", with:"").replacingOccurrences(of:">", with:"").replacingOccurrences(of:" ", with:"")
        MTTPrint("deviceToken:\(device)")
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if DTOpenAPI.handleOpen(url, delegate: self) {
            return true
        }
        let result = UMSocialManager.default().handleOpen(url, options: options)
        if !result {
            // 其他sdk回调
        }
        
        return result
    }

    // 新浪微博的H5网页登录回调需要实现这个方法
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        if DTOpenAPI.handleOpen(url, delegate: self) {
            return true
        }
        
        // 这里的URL Schemes是配置在 info -> URL types中, 添加的新浪微博的URL schemes
        // 例如: 你的新浪微博的AppKey为: 123456789, 那么这个值就是: wb123456789
        let result = UMSocialManager.default()?.handleOpen(url, sourceApplication: sourceApplication, annotation: annotation)
        if !result! {
            // 其他sdk回调
        }
        return result!
    }

    func pSetupUMeng(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Void {
        
        // 设置日志
        UMConfigure.setLogEnabled(true)
        UMConfigure.initWithAppkey("5b737e3ea40fa31a7b000721", channel: "App Store")
        
        // 监控崩溃 调试模式不起作用
        UMErrorCatch.initErrorCatch()
        
        // 设置社会化组件
        setupSharePlatform()
        
        // 统计
        MobClick.setScenarioType(eScenarioType.E_UM_NORMAL)
        
        // 设置推送
        let entity = UMessageRegisterEntity()
        entity.types = Int(UMessageAuthorizationOptions.alert.rawValue)|Int(UMessageAuthorizationOptions.badge.rawValue)|Int(UMessageAuthorizationOptions.sound.rawValue)
        UMessage.registerForRemoteNotifications(launchOptions: launchOptions, entity: entity) { (granted, error) in
            if granted{
                
            } else {
                
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
    }
    
    // MARK: - 设置分享平台
    func setupSharePlatform() -> Void {
        DTOpenAPI.registerApp("dingoabu7vij6ejemd4f74")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.wechatSession, appKey: "wx1f392c7da3b36480", appSecret: "e86a624bb571c1dbf812bffd9c77f942", redirectURL: nil)
        UMSocialManager.default().setPlaform(UMSocialPlatformType.sina, appKey: "2363051363", appSecret: "1d2c11fced4a01e8a0e2b51a81c14fbc", redirectURL: "http://www.sina.com")
        UMSocialManager.default().setPlaform(UMSocialPlatformType.QQ, appKey: "1107768358", appSecret: "2sLJS9RXDVDURhbA", redirectURL: nil)
        UMSocialManager.default()?.setPlaform(UMSocialPlatformType.dingDing, appKey: "dingoabu7vij6ejemd4f74", appSecret: "USrD1c3EAFlxbrdkEZahdxiPtMc7DlHq6nQuAwG3MZIh1-Aa2ohOeMdJQjyG1FXx", redirectURL: nil)
    }

}

@available(iOS 11.0, *)
extension AppDelegate: UNUserNotificationCenterDelegate
{
    // 处理前台收到通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let userInfo = notification.request.content.userInfo
        if (notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            
            UMessage.setAutoAlert(false)
            UMessage.didReceiveRemoteNotification(userInfo)
        }
        
        completionHandler([.alert,.sound,.badge])
    }
    
    // 处理后台点击通知的代理方法
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        if (response.notification.request.trigger?.isKind(of: UNPushNotificationTrigger.self))! {
            UMessage.didReceiveRemoteNotification(userInfo)
        }
        
    }
}

extension AppDelegate: DTOpenAPIDelegate {
    func onReq(_ req: DTBaseReq!) {
        
    }
    
    func onResp(_ resp: DTBaseResp!) {
        if resp.isKind(of: DTAuthorizeResp.self) {
            let newResp = resp as! DTAuthorizeResp
            let name = "钉钉用户" + String.getCurrentTimeStamp()
            let uid = newResp.accessCode
            let userInfo = ["name":name,"uid":uid]
            NotificationCenter.default.post(name: NSNotification.Name.init(kDingTalkLoginSuccess), object: userInfo, userInfo: nil)
        }
    }
}

@available(iOS 11.0, *)
extension AppDelegate: MTTWelcomePageInterface
{
    func iShouldShowWelcomePage(show: Bool) {
        if show {
            // 第一次 显示欢迎引导 
            MTTTaskCenter.iDispatchTask(registerTo: self, taskType: MTTTaskCenterTaskType.welcomePageTask, info: nil)
        } else {
            // 非第一次 注册广告任务 到根控制器 
            MTTSuperiorManager.sharedSuperiorManager.applyAssitant(application: UIApplication.shared, assistantType: MTTAssistantType.interfaceAssistant)
        }
    }
}

@available(iOS 11.0, *)
// MARK: - 欢迎引导页回调 
extension AppDelegate : MTTLaunchInterface
{
    
    /// 广告页回调 
    ///
    /// - Parameter info: info 
    func iLaunchProgressPage(info: [String : Any]?) {
        // 判断 用哪个根控制器来push 
        
    }
    
    /// iPhone 欢迎引导页 回调 
    ///
    /// - Parameter info: info
    func iLaunchiPhoneDeviceWelcomePage(info: [String : Any]?) {
        print(info as Any)
        var parameter:[String:Any] = ["totalCount":3]
        parameter = parameter.merging(info!, uniquingKeysWith: { (m, n) -> Any in
            return n
        })
        
        let welcomePageVC = MTTMediator.shared().registerWelcomePageModule(withParameter: parameter) as! MTTWelcomePageController
        welcomePageVC.DDelegate = self
        self.window?.rootViewController = welcomePageVC
        self.window?.makeKeyAndVisible()
    }
    
    /// iPad 欢迎引导页 回调 
    ///
    /// - Parameter info: info
    func iLaunchiPadDeviceWelcomePage(info: [String : Any]?) {
        print(info as Any)
    }
    
}

@available(iOS 11.0, *)
// MARK: - 点击广告页上的跳过按钮回调 
extension AppDelegate: MTTWelcomePageControllerDelegate
{
    func DTappedSkipButtonCallBack(info: [String : Any]?) {
        MTTSuperiorManager.sharedSuperiorManager.applyAssitant(application: UIApplication.shared, assistantType: MTTAssistantType.interfaceAssistant)
    }
    
}



