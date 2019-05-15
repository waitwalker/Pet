//
//  MTTLoginRegisterService.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/16.
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
 登录注册网络请求回调类 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation
import RxCocoa
import RxSwift
import Alamofire

enum MTTResult {
    case success(message:String)
    case empty
    case failure(message:String)
}

extension MTTResult: Equatable
{
    static func ==(lhs: MTTResult, rhs: MTTResult) -> Bool {
        switch (lhs, rhs) {
        case (MTTResult.success( _), MTTResult.success( _)):
            return true
        default:
            return false
        }
    }
}


protocol MTTLoginRegisterServiceDelegate {
    
    
    /// 登录成功回调
    ///
    /// - Parameter info: info 
    /// - Returns: 
    func dLoginActionSuccess(info:[String:Any]?) -> Void
    
    
    /// 登录失败回调 
    ///
    /// - Parameter info: info 
    /// - Returns: 
    func dLoginActionFailure(info:[String:Any]?) -> Void 
    
    
    /// 注册成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    func dRegisterActionSuccess(info:[String:Any]?) -> Void
    
    /// 注册失败回调
    ///
    /// - Parameter info: info 
    /// - Returns: 
    func dRegisterActionFailure(info:[String:Any]?) -> Void
}

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTLoginRegisterService: NSObject {
    
    // MARK: - variable 变量 属性
    static let sharedLoginRegisterService = MTTLoginRegisterService()
    var DDelegate:MTTLoginRegisterServiceDelegate?
    
    
    
    // MARK: - instance method 实例方法
    override init() {
        super.init()
    }
    
    
    /// 验证账号的有效性 
    ///
    /// - Parameter account: 账号 
    /// - Returns: 账号验证结果 
    func loginAccountValid(account: String) ->  Observable <MTTResult> {
        if account.count == 0 {
            return Observable.just(MTTResult.empty)
        }
        if !MTTRegularMatchManager.validateMobile(phone: account) {
            return Observable.just(MTTResult.failure(message: kAccountMatchFailure))
        } 
        return Observable.just(MTTResult.success(message: kAccountMatchSuccess))
    }
    
    
    /// 验证登录密码的有效性 
    ///
    /// - Parameter password: 密码 
    /// - Returns: 验证结果 
    func loginPasswordValid(password: String) -> Observable<MTTResult> {
        if password.count == 0 {
            return Observable.just(MTTResult.empty)
        }
        
        if !MTTRegularMatchManager.validatePasswordEpectedLength(password: password) {
            return Observable.just(MTTResult.failure(message: kPasswordMatchFailure))
        } 
        return Observable.just(MTTResult.success(message: kPasswordMatchSuccess))
    }
    
    
    /// 登录按钮事件回调    
    ///
    /// - Parameters:
    ///   - account: 账号 
    ///   - password: 密码 
    ///   - delegate: 代理 
    func loginAction(account:String, password:String, otherInfo:[String:Any]?, delegate:MTTLoginRegisterServiceDelegate) -> Void {
        
        DDelegate = delegate
        let urlString:String = kServerHost + kLoginAPI
        let pas = MTTSecurityManager.AES_ECB_128_Encode(originalString: password)
        let parameter:[String:Any] = ["phone":account, "password":pas]
        let isNormalLogin = otherInfo!["isNormalLogin"] as! Bool
        
        
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, encoding: URLEncoding.default, requestHeader: nil) { (response, error) in
            if error != nil {
                let msg:String = "登录失败"
                self.DDelegate?.dLoginActionFailure(info: ["message" : msg, "isNormalLogin": isNormalLogin])
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    let data = response!["data"] as! [String:Any]
                    MTTUserInfoManager.sharedUserInfo.uid = data["uid"] as! String
                    MTTUserInfoManager.sharedUserInfo.username = data["username"] as! String
                    MTTUserInfoManager.sharedUserInfo.phone = data["phone"] as! String
                    if isNormalLogin {
                        MTTUserInfoManager.sharedUserInfo.header_photo = data["header_photo"] as! String
                    }
                    MTTUserInfoManager.sharedUserInfo.user_type = data["user_type"] as! Int
                    MTTUserInfoManager.sharedUserInfo.password = pas
                    MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin = true
                    MTTUserInfoManager.sharedUserInfo.isNormalLogin = isNormalLogin
                    let realm = MTTRealm.realm()
                    let infoTable = MTTLoginInfoTable()
                    realm.beginWrite()
                    infoTable.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
                    infoTable.deviceToken = ""
                    infoTable.password = MTTUserInfoManager.sharedUserInfo.password
                    infoTable.phone = MTTUserInfoManager.sharedUserInfo.phone
                    infoTable.isNormalLogin = isNormalLogin
                    infoTable.header_photo = MTTUserInfoManager.sharedUserInfo.header_photo
                    try! realm.commitWrite()
                    
                    let the_info:[String:Any] = ["deviceToken":"",
                                                 "isNeedAutoLogin":MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin,"phone":MTTUserInfoManager.sharedUserInfo.phone,
                                                 "password":MTTUserInfoManager.sharedUserInfo.password,
                                                 "isNormalLogin":isNormalLogin
                    ]
                    
                    self.DDelegate?.dLoginActionSuccess(info: the_info)
                } else {
                    var tpmResponse = response
                    tpmResponse?.updateValue(isNormalLogin, forKey: "isNormalLogin")
                    self.DDelegate?.dLoginActionFailure(info: tpmResponse)
                }
            }
        }
    }
    
    
    /// 验证注册账号有效性 
    ///
    /// - Parameter account: 账号
    /// - Returns: 验证结果     
    func registerAccountValid(account: String) -> Observable<MTTResult> {
        if account.count == 0 {
            return Observable.just(MTTResult.empty)
        }
        if !MTTRegularMatchManager.validateMobile(phone: account) {
            return Observable.just(MTTResult.failure(message: kAccountMatchFailure))
        }
        return Observable.just(MTTResult.success(message: kAccountMatchSuccess))
    }
    
    
    /// 验证注册用户名的有效性 
    ///
    /// - Parameter username: 用户名 
    /// - Returns: 验证结果     
    func registerUsernameValid(username: String) -> Observable<MTTResult> {
        if username.count == 0 {
            return Observable.just(MTTResult.empty)
        }
        
        if !MTTRegularMatchManager.validateRegisterUserNameString(username: username) {
            return Observable.just(MTTResult.failure(message: kUsernameMatchFailure))
        }
        return Observable.just(MTTResult.success(message: kUsernameMatchSuccess))
    }
    
    
    /// 验证注册密码有效性 
    ///
    /// - Parameter password: 密码
    /// - Returns: 验证结果 
    func registerPasswordValid(password: String) -> Observable<MTTResult> {
        if password.count == 0 {
            return Observable.just(MTTResult.empty)
        }
        
        if !MTTRegularMatchManager.validatePasswordEpectedLength(password: password) {
            return Observable.just(MTTResult.failure(message: kPasswordMatchFailure))
        }
        return Observable.just(MTTResult.success(message: kUsernameMatchSuccess))
    }
    
    /// 注册按钮事件回调    
    ///
    /// - Parameters:
    ///   - account: 账号 
    ///   - password: 密码 
    ///   - delegate: 代理 
    func registerAction(account:String, username:String, password:String, delegate:MTTLoginRegisterServiceDelegate) -> Void {
        
        DDelegate = delegate
        let urlString:String = kServerHost + kRegisterAPI
        let pas = MTTSecurityManager.AES_ECB_128_Encode(originalString: password)
        
        let parameter:[String:Any] = ["phone":account,"username":username, "password":pas]
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, encoding: URLEncoding.default, requestHeader: nil) { (response, error) in
            if error != nil {
                let msg:String = "注册失败"
                self.DDelegate?.dRegisterActionFailure(info: ["message" : msg])
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    self.DDelegate?.dRegisterActionSuccess(info: ["response":response as Any])
                } else {
                    let msg:String = "注册失败"
                    self.DDelegate?.dRegisterActionFailure(info: ["message" : msg])
                }
            }
        }
    }
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}
