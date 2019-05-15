//
//  MTTUserInfoManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/20.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

class MTTUserInfoManager: NSObject {
    
    // 单例 
    static let sharedUserInfo = MTTUserInfoManager()
    var uid:String = ""
    var phone:String = ""
    var username:String = ""
    var header_photo:String = ""
    var user_type:Int = 0
    var deviceToken:String = ""
    var isNeedAutoLogin:Bool = false
    var password:String = ""
    var headerImage:UIImage!
    var shouldLoadNewAd:Bool = false
    var shouldRefreshCircleList:Bool = false
    var blockUserUidArray:Set<String> = Set()
    var isNormalLogin:Bool = false
    
    
    
    
    
    
    private override init() {
        super.init()
    }
    
    
    
}
