//
//  MTTLoginViewModel.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/17.
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
import RxCocoa
import RxSwift



/// loginView delegate
protocol MTTLoginViewModelDelegate {
    
    /// 登录按钮事件 成功回调 
    ///
    /// - Returns: 
    func dLoginActionSuccessCallBack(info:[String:Any]?) -> Void
    
    /// 登录按钮事件 失败回调 
    ///
    /// - Returns: 
    func dLoginActionFailureCallBack(info:[String:Any]?) -> Void 
}

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTLoginViewModel: NSObject {
    
    // MARK: - variable 变量 属性
    
    let OAccountDriverSequence: Driver<MTTResult>
    let OPasswordDriverSequence: Driver<MTTResult>
    let OLoginButtonDriverSequence: Driver<MTTResult>
    
    var DDelegate:MTTLoginViewModelDelegate?
    
    
    // MARK: - instance method 实例方法 
    
    init(input:(account:Driver<String>, password:Driver<String>, loginTap:Driver<Void>)) {
        OAccountDriverSequence = input.account.flatMapLatest{ accountStr in
            return MTTLoginRegisterService.sharedLoginRegisterService.loginAccountValid(account: accountStr).asDriver(onErrorJustReturn: MTTResult.failure(message: "account failure"))
        }
        
        OPasswordDriverSequence = input.password.flatMapLatest{ passwordStr in
            return MTTLoginRegisterService.sharedLoginRegisterService.loginPasswordValid(password: passwordStr).asDriver(onErrorJustReturn: MTTResult.failure(message: "password failure"))
        }
        
        OLoginButtonDriverSequence = Driver.combineLatest(OAccountDriverSequence, OPasswordDriverSequence){ elementOne, elementTwo in
            if elementOne == elementTwo
            {
                return MTTResult.success(message: kButtonEnableMatchSuccess)
            } else {
                return MTTResult.failure(message: kButtonEnableMatchFailure)
            }
        }
        
    }
    
    func loginAction(account:String, password:String, otherInfo:[String:Any]?,  delegate:MTTLoginViewModelDelegate) -> Void {
        DDelegate = delegate
        MTTLoginRegisterService.sharedLoginRegisterService.loginAction(account: account, password: password, otherInfo: otherInfo, delegate: self)
    }
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}

@available(iOS 11.0, *)
extension MTTLoginViewModel: MTTLoginRegisterServiceDelegate
{
    func dRegisterActionSuccess(info: [String : Any]?) {
        
    }
    
    func dRegisterActionFailure(info: [String : Any]?) {
        
    }
    
    func dLoginActionSuccess(info: [String : Any]?) {
        self.DDelegate?.dLoginActionSuccessCallBack(info: info)
    }
    
    func dLoginActionFailure(info: [String : Any]?) {
        self.DDelegate?.dLoginActionFailureCallBack(info: info)
    }
}

// MARK: - 注册viewModel delegate 
protocol MTTRegisterViewModelDelegate {
    
    
    /// 注册成功回调 
    ///
    /// - Parameter info: 回调info 
    /// - Returns: 
    func dRegisterSuccessCallBack(info:[String:Any]?) -> Void
    
    
    /// 注册失败回调 
    ///
    /// - Parameter info: 回调info 
    /// - Returns: 
    func dRegisterFailureCallBack(info:[String:Any]?) -> Void
}

// MARK: - register viewModel 
@available(iOS 11.0, *)
class MTTRegisterViewModel: NSObject {
    
    let OAccountDriverSequence: Driver<MTTResult>
    let OUsernameDriverSequence: Driver<MTTResult>
    let OPasswordDriverSequence: Driver<MTTResult>
    let ORegisterButtonDriverSequence: Driver<MTTResult>
    var DDelegate:MTTRegisterViewModelDelegate!
    
    
    /// 构造方法 
    ///
    /// - Parameter input: 输出元祖 
    init(input:(account:Driver<String>, username:Driver<String>, password:Driver<String>)) {
        OAccountDriverSequence = input.account.flatMap{ accountStr in
            return MTTLoginRegisterService.sharedLoginRegisterService.registerAccountValid(account: accountStr).asDriver(onErrorJustReturn: MTTResult.failure(message: "register account failure"))
        }
        
        OUsernameDriverSequence = input.username.flatMap{ usernameStr in
            return MTTLoginRegisterService.sharedLoginRegisterService.registerUsernameValid(username: usernameStr).asDriver(onErrorJustReturn: MTTResult.failure(message: "register username failure"))
        }
        
        OPasswordDriverSequence = input.password.flatMap{ passwordStr in
            return MTTLoginRegisterService.sharedLoginRegisterService.registerPasswordValid(password: passwordStr).asDriver(onErrorJustReturn: MTTResult.failure(message: "register password failure"))
        }
        
        ORegisterButtonDriverSequence = Driver.combineLatest(OAccountDriverSequence, OUsernameDriverSequence, OPasswordDriverSequence) { one, two, three in
            
            if one == two && two == three {
                return MTTResult.success(message: kButtonEnableMatchSuccess)
            } else {
                return MTTResult.failure(message: kButtonEnableMatchFailure)
            }
        }
    }
    
    
    /// 注册时间回调  
    ///
    /// - Parameters:
    ///   - account: 账号
    ///   - username: 用户名
    ///   - password: 密码 
    func registerButtonAction(_ account: String, username: String, password: String) -> Void {
        MTTLoginRegisterService.sharedLoginRegisterService.registerAction(account: account, username: username, password: password, delegate: self)
    }
    
}

@available(iOS 11.0, *)
extension MTTRegisterViewModel: MTTLoginRegisterServiceDelegate
{
    func dLoginActionSuccess(info: [String : Any]?) {
        
    }
    
    func dLoginActionFailure(info: [String : Any]?) {
        
    }
    
    func dRegisterActionSuccess(info: [String : Any]?) {
        self.DDelegate.dRegisterSuccessCallBack(info: info)
    }
    
    func dRegisterActionFailure(info: [String : Any]?) {
        self.DDelegate.dRegisterSuccessCallBack(info: info)
    }
}
