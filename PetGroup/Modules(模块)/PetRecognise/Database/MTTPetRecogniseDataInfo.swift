///Users/DeveloperLx/PetGroup/PetGroup/Modules(模块)/PetRecognise/Database/MTTPetRecogniseDataInfo.swift
//  MTTPetRecogniseDataInfo.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/10/31.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit
import RealmSwift

class MTTPetRecogniseDataInfo: Object {

    @objc dynamic var id:String = ""  //主键
    @objc dynamic var objectEnglishName:String = "" //英文名称
    @objc dynamic var objectChineseName:String = "" //中文名称
    @objc dynamic var isPetObject:Bool = true //是否是宠物 默认是
    
    
    override static func primaryKey() -> String? {
        return "id"
    } 
    
    override static func indexedProperties() -> [String] {
        return ["objectEnglishName"]
    }
}
