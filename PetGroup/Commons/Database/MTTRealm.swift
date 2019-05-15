//
//  MTTRealm.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/29.
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
import RealmSwift

// MARK: - ***************** class 分割线 ******************
class MTTRealm: NSObject {
    
    // MARK: - variable 变量 属性
    //let mttRealm = 
    
    static let sharedRealm = MTTRealm.realm()
    
    typealias BResult = (_ obejct:RealmSwift.Object?, _ error:Error?)->()
    
    static func realm() -> Realm {
        
        self.pSetDefaultRealmForUser(databaseName: "petGroup")
        
        if let realm = try? Realm(configuration: Realm.Configuration.defaultConfiguration) {
            return realm
        } else {
            return try! Realm()
        }
    }
    
    
    /// 插入数据    
    ///
    /// - Parameters:
    ///   - type: model 类型 
    ///   - value: 插入的数据 
    ///   - update: 是否更新 
    ///   - result: 插入结果 success/failure 
    static func addObject(type:RealmSwift.Object.Type,value:Any? = nil, update:Bool = false, result:BResult) -> Void {
        let realm = self.sharedRealm
        do {
            realm.beginWrite()
            try realm.write {
                (value == nil) ? realm.add(value as! Object) : realm.add(value as! Object, update: update)
                result(nil,nil)
            }
            try realm.commitWrite()
        } catch let error {
            print("更新数据库失败")
            result(nil,error)
        }
    }
    
    
    /// 更新数据    
    ///
    /// - Parameters:
    ///   - type: model 类型 
    ///   - value: 插入的数据 
    ///   - result: 回调 
    static func updateObject(type:RealmSwift.Object.Type, value:Any? = nil, result:BResult) -> Void {
        self.addObject(type: type, value: value, update: true, result: result)
    }
    
    /// 查询所有数据 
    ///
    /// - Parameter type: model 
    /// - Returns: 所有数据 
    static func queryObjects(type:RealmSwift.Object.Type) -> RealmSwift.Results<RealmSwift.Object>? {
        return self.sharedRealm.objects(type) 
    }
    
    
    /// 根据条件查询数据    
    ///
    /// - Parameters:
    ///   - type: model 类型 
    ///   - filter: 条件 
    /// - Returns: 查询结果 
    static func queryObject(type:RealmSwift.Object.Type, filter:String) -> RealmSwift.Results<RealmSwift.Object>? {
        return self.sharedRealm.objects(type).filter(filter)
    }
    
    static func pSetDefaultRealmForUser(databaseName:String) -> Void {
        var config = Realm.Configuration()
        config.fileURL = URL(string: NSHomeDirectory() + "/Documents/\(databaseName).realm")
        Realm.Configuration.defaultConfiguration = config
    }
    
    
    // MARK: - instance method 实例方法 
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}
