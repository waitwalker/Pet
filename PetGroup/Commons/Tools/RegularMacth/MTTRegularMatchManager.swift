//
//  MTTRegularMatchManager.swift
//  ettNextGen
//
//  Created by LiuChuanan on 2017/11/6.
//  Copyright © 2017年 Etiantian. All rights reserved.
//

/**
     正则匹配账号密码邮箱等
 */

import UIKit

class MTTRegularMatchManager: NSObject 
{
    // MARK: - 匹配邮箱
    class func validateEmail(email:String) -> Bool
    {
        let emailRegex: String = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest: NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
    
    // MARK: - 匹配手机号
    class func validateMobile(phone:String) -> Bool
    {
        let phoneRegex: String = "^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0,0-9]))\\d{8}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    class func validateNum(text:String) -> Bool 
    {
        let phoneRegex: String = "^[0-9]*$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//        let value = phoneTest.evaluate(with:text)
//        if value 
//        {
//            return text
//        } else
//        {
//            let theString = text as NSString
//            let subStr = theString.substring(with: NSMakeRange(0, theString.length - 1))
//            
//            return subStr
//        }
        return phoneTest.evaluate(with:text)
    }
    
    // MARK: - 匹配密码
    class func validatePassword(password:String) -> Bool
    {
        let  passWordRegex = "^(?![0-9]+$)(?![a-zA-Z]+$)(?![_]+$)[0-9A-Za-z_]{6,16}$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: password)
    }
    
    // MARK: - 孩子姓名匹配 
    class func validChildName(childName:String) -> Bool 
    {
        let childNameRegex = "^[a-zA-Z\\u4e00-\\u9fa5]{4,12}+$"
        let childNamePredicate = NSPredicate(format: "SELF MATCHES%@", childNameRegex)
        return childNamePredicate.evaluate(with:childName)
    }
    
    class func validChildNameString(childName:String) -> Bool 
    {
        let childNameRegex = "^[a-zA-Z\\u4e00-\\u9fa5]*$"
        let childNamePredicate = NSPredicate(format: "SELF MATCHES%@", childNameRegex)
        return childNamePredicate.evaluate(with:childName)
    }
    
    // MARK: - 匹配注册用户名
    class func validateRegisterUserName(username:String) -> Bool
    {
        let userNameRegex = "^[_0-9a-zA-Z\\u4e00-\\u9fa5]{4,32}+$"
        let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
        let peopleName = userNamePredicate.evaluate(with: username)
        return peopleName
    }
    
    class func validateRegisterUserNameString(username:String) -> Bool
    {
        let userNameRegex = "^[_0-9a-zA-Z\\u4e00-\\u9fa5]*$"
        let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
        let peopleName = userNamePredicate.evaluate(with: username)
        return peopleName
    }
    
    class func validatePasswordText(password:String) -> Bool
    {
        let  passWordRegex = "^[0-9A-Za-z_]*$"
        let passWordPredicate = NSPredicate(format: "SELF MATCHES%@", passWordRegex)
        return passWordPredicate.evaluate(with: password)
    }
    
    // MARK: - 匹配用户名
    class func validateUserName(username:String) -> Bool
    {
        let userNameRegex = "^[A-Za-z0-9]{6,20}+$"
        let userNamePredicate = NSPredicate(format: "SELF MATCHES %@", userNameRegex)
        let peopleName = userNamePredicate.evaluate(with: username)
        return peopleName
    }
    
    
    /// 验证6位以上密码
    ///
    /// - Parameter password: 密码
    /// - Returns: 验证结果 
    static func validatePasswordEpectedLength(password: String) -> Bool {
        let passwordReges = "^.{6,}$"
        let passwordPredicate = NSPredicate(format: "SELF MATCHES %@", passwordReges)
        return passwordPredicate.evaluate(with: password)
        
        
    }
}
