//
//  MTTLoginTable.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/20.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation
import RealmSwift

class MTTLoginInfoTable: Object {
    @objc dynamic var id:Int = 0 //主键 
    @objc dynamic var deviceToken:String = "" //设备标识 
    @objc dynamic var isNeedAutoLogin:Bool = false //是否需要自动登录
    @objc dynamic var phone:String = "" //手机 
    @objc dynamic var password:String = "" //密码
    @objc dynamic var isNormalLogin = true
    @objc dynamic var header_photo = ""
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // 添加索引 
    override static func indexedProperties() -> [String] {
        return ["phone"]
    }
}


/// 屏蔽用户数据表
class MTTBlockAbuseUserTable: Object {
    @objc dynamic var id:String = ""  //主键
    @objc dynamic var uid:String = ""
    @objc dynamic var blockUids:String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
