//
//  MTTPersonalViewModel.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/26.
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

import Foundation
import Qiniu

// MARK: - 个人中心viewModel delegate
@objc protocol MTTPersonalViewModelDelegate:class {
    
    /// 
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dPersonalFailureCallBack(info:[String:Any]?) -> Void
    
    /// 
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dGetUploadFileTokenSuccessCallBack(info:[String:Any]?) -> Void
    
    /// 修改头像成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dUploadImageSuccessCallBack(info:[String:Any]?) -> Void
    
    /// 
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dPersonalSuccessCallBack(info:[String:Any]?) -> Void
    
    /// 修改用户名失败回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dChangeUsernameFailureCallBack(info:[String:Any]?) -> Void
    
    /// 修改用户名成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dChangeUsernameSuccessCallBack(info:[String:Any]?) -> Void 
    
    /// 推送请求成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dPushRequestSuccessCallBack(info:[String:Any]) -> Void 
    
    /// 推送请求失败回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    @objc func dPushRequestFailureCallBack(info:[String:Any]) -> Void
}

// MARK: - personal viewModel
@available(iOS 11.0, *)
class MTTPersonalViewModel: NSObject {

    // MARK: - variable 变量 属性
    var DDelegate:MTTPersonalViewModelDelegate?
    

    // MARK: - instance method 实例方法
    override init() {
        super.init()
    }
    
    /// 获取token
    ///
    /// - Parameter info: info
    public func getUploadFileToken(info:[String:Any]?) -> Void {
        
        if let inf = info {
            let phone:String = inf["phone"] as! String
            let password:String = inf["password"] as! String
            
            
            let urlString:String = kServerHost + kUploadFileToken
            
            let parameter:[String:Any] = ["phone":phone, "password":password]
            
            MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, requestHeader: nil) { (response, error) in
                
                if error != nil {
                    let inf:[String:Any] = ["msg":"更换头像失败",
                                            "errorCode":-10002
                    ]
                    self.DDelegate?.dPersonalFailureCallBack(info: inf)
                } else {
                    let result = response!["result"] as! Int
                    if result == 1 {
                        if let data = response!["data"] {
                            let dataDic = data as! [String:Any]
                            let token = dataDic["token"] as! String
                            let inf:[String:Any] = ["msg":"获取token成功",
                                                    "token":token
                            ]
                            self.DDelegate?.dGetUploadFileTokenSuccessCallBack(info: inf)
                            
                        } else {
                            let inf:[String:Any] = ["msg":"更换头像失败",
                                                    "errorCode":-10002
                            ]
                            self.DDelegate?.dPersonalFailureCallBack(info: inf)
                        }
                    } else {
                        let inf:[String:Any] = ["msg":"更换头像失败",
                                                "errorCode":-10002
                        ]
                        self.DDelegate?.dPersonalFailureCallBack(info: inf)
                    }
                }
                
            }
        } else {
            let inf:[String:Any] = ["msg":"手机或密码错误",
                                    "errorCode":-10001
            ]
            self.DDelegate?.dPersonalFailureCallBack(info: inf)
        }
    }
    
    /// 上传图片
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - token: token
    public func uploadImage(image:UIImage, token:String, currentIndex:Int) -> Void {
        let data = image.pngData()
        
        let tmpFolder = NSTemporaryDirectory()
        
        
        let fileManager = FileManager.default
        
        let imagePath = String("/theFirstImage.png")
        fileManager.createFile(atPath: tmpFolder.appending(imagePath), contents: data, attributes: nil)
        let filePath = String(format: "%@%@", tmpFolder,imagePath)
        
        let uploadManager = QNUploadManager()
        let uploadOption = QNUploadOption(mime: "image/png", progressHandler: { (key, percent) in
            MTTPrint("七牛图片上传完成:\(String(describing: key)),\(percent)")
        }, params: nil, checkCrc: false, cancellationSignal: nil)
        
        uploadManager?.putFile(filePath, key: nil, token: token, complete: { (info, key, response) in
            MTTPrint("七牛图片上传完成:\(String(describing: info)),\(String(describing: key)),\(String(describing: response))")
            if let res = response {
                if let key = res["key"]{
                    let the_key:String = key as! String
                    
                    self.DDelegate?.dUploadImageSuccessCallBack(info: ["imageURL":the_key,"currentIndex":currentIndex])
                } else {
                    let inf:[String:Any] = ["msg":"上传图片到七牛错误",
                                            "errorCode":-10003
                    ]
                    self.DDelegate?.dPersonalFailureCallBack(info: inf)
                }
            } else {
                let inf:[String:Any] = ["msg":"上传图片到七牛错误",
                                        "errorCode":-10003
                ]
                self.DDelegate?.dPersonalFailureCallBack(info: inf)
            }
            
        }, option: uploadOption)
        
    }
    
    
    /// 调用上传接口
    ///
    /// - Parameter info: info
    public func changeAvatar(info:[String:Any]?) -> Void {
        if let the_info = info {
            let urlString:String = kServerHost + kAvatarAPI
            
            MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: the_info, requestHeader: nil) { (response, error) in
                
                if error != nil {
                    let inf:[String:Any] = ["msg":"发表心情失败,请稍后再试",
                                            "errorCode":-10004
                    ]
                    self.DDelegate?.dPersonalFailureCallBack(info: inf)
                } else {
                    let result = response!["result"] as! Int
                    if result == 1 {
                        let msg = response!["msg"] as! String
                        let inf:[String:Any] = ["msg":msg]
                        self.DDelegate?.dPersonalSuccessCallBack(info: inf)
                    } else {
                        let inf:[String:Any] = ["msg":"发表心情失败,请稍后再试",
                                                "errorCode":-10004
                        ]
                        self.DDelegate?.dPersonalFailureCallBack(info: inf)
                    }
                }
                
            }
        } else {
            let inf:[String:Any] = ["msg":"发表心情失败,请稍后再试",
                                    "errorCode":-10004
            ]
            self.DDelegate?.dPersonalFailureCallBack(info: inf)
        }
    }
    
    /// 修改用户名
    ///
    /// - Parameter info: info
    public func changeUsername(info:[String:Any]?) -> Void {
        if let the_info = info {
            let urlString:String = kServerHost + kUsernameAPI
            
            MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: the_info, requestHeader: nil) { (response, error) in
                
                if error != nil {
                    let inf:[String:Any] = ["msg":"修改用户名失败",
                                            "errorCode":-10004
                    ]
                    self.DDelegate?.dChangeUsernameFailureCallBack(info: inf)
                } else {
                    let result = response!["result"] as! Int
                    if result == 1 {
                        let msg = response!["msg"] as! String
                        let inf:[String:Any] = ["msg":msg]
                        self.DDelegate?.dChangeUsernameSuccessCallBack(info: inf)
                    } else {
                        let inf:[String:Any] = ["msg":"修改用户名失败",
                                                "errorCode":-10004
                        ]
                        self.DDelegate?.dChangeUsernameFailureCallBack(info: inf)
                    }
                }
            }
        } else {
            let inf:[String:Any] = ["msg":"修改用户名失败",
                                    "errorCode":-10004
            ]
            self.DDelegate?.dChangeUsernameFailureCallBack(info: inf)
        }
    }
    
    
    /// 推送请求
    ///
    /// - Parameter parameter: 参数
    func pushRequest(info:[String:Any]?) -> Void {
        if let the_info = info {
            let urlString:String = kServerHost + kPushAPI
            
            MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: the_info, requestHeader: nil) { (response, error) in
                
                if error != nil {
                    let inf:[String:Any] = ["msg":"推送失败",
                                            "errorCode":-10005
                    ]
                    self.DDelegate?.dPushRequestFailureCallBack(info: inf)
                } else {
                    let result = response!["result"] as! Int
                    if result == 1 {
                        let msg = response!["msg"] as! String
                        let inf:[String:Any] = ["msg":msg]
                        self.DDelegate?.dPushRequestSuccessCallBack(info: inf)
                    } else {
                        let inf:[String:Any] = ["msg":"推送失败",
                                                "errorCode":-10005
                        ]
                        self.DDelegate?.dPushRequestFailureCallBack(info: inf)
                    }
                }
                
            }
        } else {
            let inf:[String:Any] = ["msg":"推送失败",
                                    "errorCode":-10005
            ]
            self.DDelegate?.dPushRequestFailureCallBack(info: inf)
        }
    }
    
    // MARK: - class method  类方法
    
    // MARK: - private method 私有方法
    
    deinit {
        
    }
    
}
