//
//  MTTSecurityManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/6.
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


import CryptoSwift

import Foundation

// MARK: - ***************** class 分割线 ******************
class MTTSecurityManager: NSObject {
    
    // MARK: - variable 变量 属性
    
    static let key:Array<UInt8> = [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    static let iv: Array<UInt8> = [123,2,3,4,5,1,1,1,1,1,1,1,1,1,1,1]
    
    
    
    
    // MARK: - instance method 实例方法 
    
    // MARK: - class method  类方法
    
    /// AES ECB 128 加密
    ///
    /// - Parameter originalString: 原始内容
    /// - Returns: 加密后内容
    static func AES_ECB_128_Encode(originalString:String) -> String {
        let data = originalString.data(using: String.Encoding.utf8)
        // byte 数组 
        var encrypted:[UInt8] = []
        do {
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: Padding.pkcs7)
            encrypted = try aes.encrypt((data?.bytes)!)
        } catch let error {
            print(error)
        }
        let encoded = Data(encrypted)
        return encoded.base64EncodedString()
    }
    
    /// AES ECB 128 解密
    ///
    /// - Parameter content: 加密内容
    /// - Returns: 解密后
    static func AES_ECB_128_Decode(content:String) -> String {
        let data = NSData(base64Encoded: content, options: NSData.Base64DecodingOptions.init(rawValue: 0))
        var encrypted:[UInt8] = []
        let count = data?.length
        for i in 0..<count! {
            var tmp:UInt8 = 0
            data?.getBytes(&tmp, range: NSRange(location: i,length:1 ))
            encrypted.append(tmp)
        }
        
        // decode AES
        var decrypted: [UInt8] = []
        do {
            let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: Padding.pkcs7)
            
            decrypted = try aes.decrypt(encrypted)
        } catch let error {
            print(error)
        }
        
        // byte 转换成NSData
        let encoded = Data(decrypted)
        //解密结果从data转成string
        let str = String(data: encoded, encoding: String.Encoding.utf8)
        
        return str!
    }
    
    // MARK: - private method 私有方法  
    
}
