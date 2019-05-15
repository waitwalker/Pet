//
//  MTTLaunchProgressViewModel.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/9/22.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit
import RealmSwift

class MTTLaunchProgressViewModel: Object {
    @objc dynamic var id:Int = 0 //主键
    @objc dynamic var isFirstLaunch:Bool = true//是否首次启动
    @objc dynamic var lastLaunchTimeInterval:Int = 0//上次启动时间戳
    @objc dynamic var lastZeroTimeInterval:Int = 0//上次零点时间
    
    
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
