//
//  MTTDeviceTypeManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/22.
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
 视图相关:V开头 驼峰式 
 控制器相关:C开头 驼峰式 
 数据相关:M开头 驼峰式 
 代理相关:D开头 驼峰式 
 其他类似
 
 1. 类的功能:
 获取设备类型
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation
import UIKit

// MARK: - ***************** class 分割线 ******************
class MTTDeviceInfoManager: NSObject {
    
    // MARK: - variable 变量 属性
    // 类属性 
    static var currentDeviceManager:MTTDeviceInfoManager {
        get{
            return deviceInfoManager
        }
    }
    
    // 单例对象 
    static let deviceInfoManager = MTTDeviceInfoManager()
    
    // 设备信息字典 只读 对内
    private var infoDictionary:[String:Any] {
        get {
            return Bundle.main.infoDictionary!
        }
    }
    
    // bundle id CFBundleIdentifier:CFBundleIdentifier关键字指定了束的一个唯一的标识字符串。该标识符采用了类似Java包的命名方式，例如com.apple.myapp。该束标识符可以在运行时定位束。预置系统使用这个字符串来唯一地标识每个应用程序。
    var appBundleID:String {
        get{
            return self.infoDictionary["CFBundleIdentifier"] as! String
        }
    }
    
    // 应用名称 只读 
    var appDisplayName:String {
        get {
            return self.infoDictionary["CFBundleDisplayName"] as! String
        }
    }
    
    // app 版本号   
    var appVersion:String {
        get{
            return self.infoDictionary["CFBundleShortVersionString"] as! String
        }
    }
    
    // app 编译版本号 
    var appBuildVersion:String {
        get{
            return self.infoDictionary["CFBundleVersion"] as! String
        }
    }
    
    // 平台名称 区分手机还是pad iphoneos 
    var platformName:String {
        get{
            return self.infoDictionary["DTPlatformName"] as! String
        }
    }
    
    // 平台版本 
    var platformVersion:String {
        get{
            return self.infoDictionary["DTPlatformVersion"] as! String
        }
    }
    
    // 兼容的cup架构 
    var requiredDeviceCapability:String {
        get{
            return ((self.infoDictionary["UIRequiredDeviceCapabilities"] as! Array<Any>).first as! String)
        }
    }
    
    // 系统版本
    var deviceOsVersion:String {
        get{
            return UIDevice.current.systemVersion 
        }
    }
    
    // 当前系统 名称 
    var deviceSystemName:String {
        get{
            return UIDevice.current.systemName 
        }
    }
    
    // 设备名称 
    var deviceName:String {
        get{
            return UIDevice.current.model
        }
    }
    
    // 设备型号名称
    var deviceModelTypeName:MTTDeviceModelType {
        get{
            return UIDevice.current.modelName
        }
    }
    
    
    // 设备总的运行内存
    var totalMemorySize:Double {
        get{
            return Double(Double(ProcessInfo.processInfo.physicalMemory) / 1024.0 / 1024.0 / 1000.0)
        }
    }
    
    // 设备可用运行内存 
//    var availableMemorySize:Double {
//        get{
//            let host_port:mach_port_t = mach_host_self()
//            var host_size:mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.size.self / MemoryLayout<integer_t>.size.self)
//            var page_size:vm_size_t? = nil
//            var vm_stat:vm_statistics_data_t? = nil
//            var kern:kern_return_t? = nil
//            kern = host_page_size(host_port, &page_size!)
//            if kern != KERN_SUCCESS {
//                return -1.0
//            }
//            
//            kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat!, &host_size)
//            if kern != KERN_SUCCESS {
//                return -1.0  
//            }
//            
//            return Double((vm_stat?.free_count)!) * Double(page_size!)
//            
//            
//            
//        }
//    }
    
    
    // MARK: - instance method 实例方法 
    override init() {
        super.init()
    }
    
    // MARK: - class method  类方法 
    // 当前设备 实例 
    static func currentDeviceInfoManager() -> MTTDeviceInfoManager {
        return self.currentDeviceManager
    }
    
    // MARK: - private method 私有方法  
    
}

// MARK: - UIDevice 扩展 
extension UIDevice
{
    var modelName:MTTDeviceModelType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod1,1":                                 return .iPod_Touch_1
        case "iPod2,1":                                 return .iPod_Touch_2
        case "iPod3,1":                                 return .iPod_Touch_3
        case "iPod4,1":                                 return .iPod_Touch_4
        case "iPod5,1":                                 return .iPod_Touch_5
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return .iPhone_4
        case "iPhone4,1":                               return .iPhone_4s
        case "iPhone5,1", "iPhone5,2":                  return .iPhone_5
        case "iPhone5,3", "iPhone5,4":                  return .iPhone_5c
        case "iPhone6,1", "iPhone6,2":                  return .iPhone_5s
        case "iPhone7,2":                               return .iPhone_6
        case "iPhone7,1":                               return .iPhone_6_plus
        case "iPhone8,1":                               return .iPhone_6s
        case "iPhone8,2":                               return .iPhone_6s_plus
        case "iPhone8,4":                               return .iPhone_SE
        case "iPhone9,1", "iPhone9,3":                  return .iPhone_7
        case "iPhone9,2", "iPhone9,4":                  return .iPhone_7_plus
        case "iPhone10,2", "iPhone10,5":                return .iPhone_8_plus
        case "iPhone10,1", "iPhone10,4":                return .iPhone_8
        case "iPhone10,6","iPhone10,3":                 return .iPhone_X
        case "iPhone11,2":                              return .iPhone_XS
        case "iPhone11,4","iPhone11,6":                 return .iPhone_XS_MAX
        case "iPhone11,8":                              return .iPhone_XR
            
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return .iPad_2
        case "iPad3,1", "iPad3,2", "iPad3,3":           return .iPad_3
        case "iPad3,4", "iPad3,5", "iPad3,6":           return .iPad_4
        case "iPad4,1", "iPad4,2", "iPad4,3":           return .iPad_Air
        case "iPad5,3", "iPad5,4":                      return .iPad_Air_2
        case "iPad2,5", "iPad2,6", "iPad2,7":           return .iPad_Mini
        case "iPad4,4", "iPad4,5", "iPad4,6":           return .iPad_Mini_2
        case "iPad4,7", "iPad4,8", "iPad4,9":           return .iPad_Mini_3
        case "iPad5,1", "iPad5,2":                      return .iPad_Mini_4
        case "iPad6,3", "iPad6,4", "iPad7,5", "iPad7,6":return .iPad_Pro_9
        case "iPad6,7", "iPad6,8":                      return .iPad_Pro_12
        case "iPad6,11", "iPad6,12":                    return .iPad_5
        case "iPad7,1", "iPad7,2":                      return .iPad_Pro_12_2
        case "iPad7,3", "iPad7,4":                      return .iPad_Pro_10
        case "AppleTV2,1":                              return .Apple_TV_2
        case "AppleTV3,1", "AppleTV3,2":                return .Apple_TV_3
        case "AppleTV5,3":                              return .Apple_TV_4
        case "i386":                                    return .Simulator_i386
        case "x86_64":                                  return .Simulator_x86_64
        default:     
            if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
            {
                return .iPhone
            } else if UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
            {
                return .iPad
            }else {
                return .undefinedDevice
            }
        }
    }
    
}

// MARK: - 设备型号类型 
enum MTTDeviceModelType:String {

    case iPod_Touch_1     = "iPod_Touch_1"
    case iPod_Touch_2     = "iPod_Touch_2"
    case iPod_Touch_3     = "iPod_Touch_3"
    case iPod_Touch_4     = "iPod_Touch_4"
    case iPod_Touch_5     = "iPod_Touch_5"

    case iPhone           = "iPhone"
    case iPhone_4         = "iPhone_4"
    case iPhone_4s        = "iPhone_4s"
    case iPhone_5         = "iPhone_5"
    case iPhone_5s        = "iPhone_5s"
    case iPhone_5c        = "iPhone_5c"
    case iPhone_SE        = "iPhone_SE"
    case iPhone_6         = "iPhone_6"
    case iPhone_6_plus    = "iPhone_6_plus"
    case iPhone_6s        = "iPhone_6s"
    case iPhone_6s_plus   = "iPhone_6s_plus"
    case iPhone_7         = "iPhone_7"
    case iPhone_7_plus    = "iPhone_7_plus"
    case iPhone_8         = "iPhone_8"
    case iPhone_8_plus    = "iPhone_8_plus"
    case iPhone_X         = "iPhone_X"
    case iPhone_XS        = "iPhone_XS"
    case iPhone_XS_MAX    = "iPhone_XS_MAX"
    case iPhone_XR        = "iPhone_XR"

    case iPad             = "iPad"
    case iPad_2           = "iPad_2"
    case iPad_3           = "iPad_3"
    case iPad_4           = "iPad_4"
    case iPad_5           = "iPad_5"
    case iPad_Air         = "iPad_Air"
    case iPad_Air_2       = "iPad_Air_2"
    case iPad_Mini        = "iPad_Mini"
    case iPad_Mini_2      = "iPad_Mini_2"
    case iPad_Mini_3      = "iPad_Mini_3"
    case iPad_Mini_4      = "iPad_Mini_4"
    case iPad_Pro_12      = "iPad_Pro_12"
    case iPad_Pro_12_2    = "iPad_Pro_12_2"
    case iPad_Pro_10      = "iPad_Pro_10"
    case iPad_Pro_10_2    = "iPad_Pro_10_2"
    case iPad_Pro_9       = "iPad_Pro_9"
    case iPad_Pro_9_2     = "iPad_Pro_9_2"

    case Apple_TV_2       = "Apple_TV_2"
    case Apple_TV_3       = "Apple_TV_3"
    case Apple_TV_4       = "Apple_TV_4"

    case Simulator_i386   = "Simulator_i386"
    case Simulator_x86_64 = "Simulator_x86_64"
    
    case undefinedDevice  = "undefinedDevice"

}
