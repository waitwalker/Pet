//
//  MTTCircleService.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/20.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - MTTCircleServiceDelegate
protocol MTTCircleServiceDelegate {
    
    
    /// 自动登录成功回调
    ///
    /// - Parameter info: info 
    /// - Returns: 
    func dLoginSuccessCallBack(info:[String:Any]?) -> Void 
    
    
    /// 自动登录失败回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    func dLoginFailureCallBack(info:[String:Any]?) -> Void 
    
    
    /// 注册设备成功回调 
    ///
    /// - Parameter response: 响应数据 
    /// - Returns: 
    func dRegisterDeviceSuccessCallBack(response:[String:Any]) -> Void
    
    
    /// 注册设备失败回调 
    ///
    /// - Parameter error: 错误 
    /// - Returns: 
    func dRegisterDevicefailureCallBack(error:MTTError) -> Void
    
    
    /// 通过设备获取动态列表成功
    ///
    /// - Parameter response: 响应数据 
    /// - Returns: 
    func dDeviceDynamicListSuccessCallBack(response:[String:Any]) -> Void 
    
    
    /// 通过设备获取动态列表失败 
    ///
    /// - Parameter error: error 
    /// - Returns: 
    func dDeviceDynamicListFailureCallBack(error:MTTError) -> Void
    
    
    /// 获取动态列表成功回调 
    ///
    /// - Parameter error: error 
    /// - Returns: 
    func dDynamicListFailureCallBack(error:MTTError) -> Void
    
    
    /// 获取动态列表失败回调
    ///
    /// - Parameter response: response
    /// - Returns: 
    func dDynamicListSuccessCallBack(response:[String:Any]) -> Void 
    
    
    /// 点赞成功请求回调
    ///
    /// - Parameter response: info 
    /// - Returns: 
    func dPraiseRequestSuccessCallBack(response:[String:Any]) -> Void 
    
    
    /// 点在失败请求回调
    ///
    /// - Parameter response: info
    /// - Returns: 
    func dPraiseRequestFailureCallBack(response:[String:Any]) -> Void 
}

// MARK: - circle service
@available(iOS 11.0, *)
class MTTCircleService: NSObject {
    
    static var DDelegate:MTTCircleServiceDelegate?
    
    // MARK: - 本地正常自动登录 
    static func commonLogin(info:[String:Any]?) -> Void {
        let parameter = ["phone":info!["phone"] as! String,
                         "password":info!["password"] as! String
                         ]
        
        let urlString:String = kServerHost + kLoginAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, encoding: URLEncoding.default, requestHeader: nil) { (response, error) in
            if error != nil 
            {
                let msg:String = "登录失败"
                self.DDelegate?.dLoginFailureCallBack(info: ["message" : msg])
            } else {
                let result = response!["result"] as! Int
                if result == 1
                {
                    let data = response!["data"] as! [String:Any]
                    MTTUserInfoManager.sharedUserInfo.uid = data["uid"] as! String
                    MTTUserInfoManager.sharedUserInfo.username = data["username"] as! String
                    MTTUserInfoManager.sharedUserInfo.phone = data["phone"] as! String
                    if MTTUserInfoManager.sharedUserInfo.isNormalLogin {
                        MTTUserInfoManager.sharedUserInfo.header_photo = data["header_photo"] as! String
                    }
                    MTTUserInfoManager.sharedUserInfo.user_type = data["user_type"] as! Int
                    MTTUserInfoManager.sharedUserInfo.password = info!["password"] as! String
                    MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin = true
                    
                    let result = MTTRealm.queryObjects(type: MTTLoginInfoTable.self)
                    
                    // 已经插入数据了 
                    if (result?.count)! > Int(0) {
                        let loginInfo = result?.first as! MTTLoginInfoTable
                        if loginInfo.isNormalLogin == false {
                            MTTUserInfoManager.sharedUserInfo.header_photo = loginInfo.header_photo
                            MTTUserInfoManager.sharedUserInfo.isNormalLogin = loginInfo.isNormalLogin
                        }
                        try! MTTRealm.sharedRealm.write {
                            loginInfo.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
                            loginInfo.deviceToken = ""
                            loginInfo.password = MTTUserInfoManager.sharedUserInfo.password
                            loginInfo.phone = MTTUserInfoManager.sharedUserInfo.phone
                            loginInfo.isNormalLogin = MTTUserInfoManager.sharedUserInfo.isNormalLogin
                            loginInfo.header_photo = MTTUserInfoManager.sharedUserInfo.header_photo
                        }
                        //try! MTTRealm.sharedRealm.commitWrite()
                        
                    } else {
                        MTTRealm.sharedRealm.beginWrite()
                        let infoTable = MTTLoginInfoTable()
                        infoTable.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
                        infoTable.deviceToken = ""
                        infoTable.password = MTTUserInfoManager.sharedUserInfo.password
                        infoTable.phone = MTTUserInfoManager.sharedUserInfo.phone
                        infoTable.isNormalLogin = MTTUserInfoManager.sharedUserInfo.isNormalLogin
                        infoTable.header_photo = MTTUserInfoManager.sharedUserInfo.header_photo
                        MTTRealm.sharedRealm.add(infoTable)
                        try! MTTRealm.sharedRealm.commitWrite()
                    }
                    
                    let the_info:[String:Any] = ["deviceToken":"",
                                                 "isNeedAutoLogin":MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin,
                                                 "phone":MTTUserInfoManager.sharedUserInfo.phone,
                                                 "password":MTTUserInfoManager.sharedUserInfo.password,
                                                 "uid":MTTUserInfoManager.sharedUserInfo.uid
                    ]
                    
                    self.DDelegate?.dLoginSuccessCallBack(info: the_info)
                } else
                {
                    self.DDelegate?.dLoginFailureCallBack(info: response)
                }
            }
        }
    }
    
    static func getDynamicListAction(info:[String:Any]?) -> Void {
        let urlString:String = kServerHost + kDynamicListAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, 
                                                    parameter: info, 
                                                    requestHeader: nil) 
        { (response, error) in
            if error != nil {
                self.DDelegate?.dDeviceDynamicListFailureCallBack(error: error!)
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    self.DDelegate?.dDynamicListSuccessCallBack(response: response!)
                } else {
                    let e = NSError(domain: "获取动态列表失败", code: -10003, userInfo: nil)
                    let err = MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: "获取动态列表失败", error: e as Error))
                    self.DDelegate?.dDynamicListFailureCallBack(error: err)
                }
            }
        }
    }
    
    /// 注册设备 
    ///
    /// - Parameter info: info 
    static func registerDevice(info:[String:Any]?) -> Void {
        let urlString = kServerHost + kRegisterDeviceAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, 
                                                    parameter: info, 
                                                    requestHeader: nil) 
        { (response, error) in
            if error != nil {
                print("error:", error as Any)
                self.DDelegate?.dRegisterDevicefailureCallBack(error: error!)
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    self.DDelegate?.dRegisterDeviceSuccessCallBack(response: response!)
                } else {
                    let e = NSError(domain: "设备注册失败", code: -10001, userInfo: nil)
                    let err = MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: "注册设备失败", error: e as Error))
                    self.DDelegate?.dRegisterDevicefailureCallBack(error: err)
                }
            }
        }
    }
    
    
    /// 根据设备获取动态列表 
    ///
    /// - Parameter info: info
    static func getDeviceDynamicList(info:[String:Any]?) -> Void {
        let urlString = kServerHost + kDeviceDynamicListAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, 
                                                    parameter: info, 
                                                    requestHeader: nil) 
        { (response, error) in
            if error != nil {
                self.DDelegate?.dDeviceDynamicListFailureCallBack(error: error!)
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    self.DDelegate?.dDeviceDynamicListSuccessCallBack(response: response!)
                } else {
                    let e = NSError(domain: "根据设备获取动态列表失败", code: -10002, userInfo: nil)
                    let err = MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: "根据设备获取动态列表失败", error: e as Error))
                    self.DDelegate?.dDeviceDynamicListFailureCallBack(error: err)
                }
            }
        }
    }
    
    
    /// 获取点赞状态
    ///
    /// - Parameter parameter: 参数
    static func praiseRequest(parameter:[String:Any]?) -> Void {
        let urlString = kServerHost + kPraiseAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, requestHeader: nil) { (response, error) in
            if error != nil {
                self.DDelegate?.dPraiseRequestFailureCallBack(response: ["msg":"点赞/取消点赞失败"])
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    self.DDelegate?.dPraiseRequestSuccessCallBack(response: ["msg":"点赞/取消点赞成功"])
                } else {
                    self.DDelegate?.dPraiseRequestFailureCallBack(response: ["msg":"点赞/取消点赞失败"])
                }
            }
        }
    }
}
