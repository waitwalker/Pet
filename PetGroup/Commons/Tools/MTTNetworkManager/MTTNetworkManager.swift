//
//  MTTNetworkManager.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/25.
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
 网络工具类 
 ping网络,延时
 当前网络状态  
 DNS解析
 请求头 
 请求体 
 编码格式 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation
import Alamofire


/// 网络状态 
///
/// - unknown: 未知
/// - notReachable: 不可用 
/// - ethernetOrWiFi: WiFi
/// - WWAN: 蜂窝 
/// - waiting: 等待 
enum MTTNetworkConnectType {
    case unknown
    case notReachable
    case ethernetOrWiFi
    case WWAN
    case waiting
}


/// 错误类型 
/// 关联值
public enum MTTError:Error {
    
    public enum MTTRequestError {
        
        case urlError(msg:String)
    }
    
    public enum MTTResponseError
    {
        case failureError(msg:String, error:Error)
    }
    
    public enum MTTNetworkError {
        case notreachable(msg:String, error:Error?) //没有网络
        case wwan(msg:String, error:Error?) //当前是蜂窝数据 
    }
    
    case NetworkError(error:MTTNetworkError)
    case URLError(error:MTTRequestError)
    case FailureError(error:MTTResponseError)
    
}

// MARK: - ***************** const 常量 分割线 ******************
let kNotreachNetwork:String = "当前网络不可用"
let kFailureResponse:String = "响应服务器错误"




// MARK: - ***************** delegate 分割线 ******************
/// 获取当前网络状态 
protocol MTTNetworkConnectTypeDelegate {
    func pCurrentNetworkStatus(connectType:MTTNetworkConnectType) -> Void 
}

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTNetworkManager: NSObject {
    
    // MARK: - variable 变量 属性
    static let sharedManager = MTTNetworkManager()
    
    
    
    /// 当前网络状态 对内可写 外部禁止写,只读 
    private(set) var ENetworkConnectType:MTTNetworkConnectType?
    
    
    /// 响应闭包回调 
    typealias BResponseCallBack = (_ response:[String:Any]?, _ error:MTTError?)->()
    
    /// 上传进度闭包回调 
    typealias BUploadProgressCallBack = (_ total: Double, _ completed:Double, _ fileURL:URL?) -> ()
    
    /// 下载进度闭包回调 
    typealias BDwonloadProgressCallBack = ()->()
    
    
    /// 是否允许访问网络 
    var isAllowReachNetwork:Bool = false
    
    
    // 设备ip 内网地址 
    var intranetIPAddress:String {
        get{
            var addresses = [String]()
            
            var ifaddr : UnsafeMutablePointer<ifaddrs>? = nil
            if getifaddrs(&ifaddr) == 0 {
                var ptr = ifaddr
                while (ptr != nil) {
                    let flags = Int32(ptr!.pointee.ifa_flags)
                    var addr = ptr!.pointee.ifa_addr.pointee 
                    if (flags & (IFF_UP|IFF_RUNNING|IFF_LOOPBACK)) == (IFF_UP|IFF_RUNNING) {
                        if addr.sa_family == UInt8(AF_INET) || addr.sa_family == UInt8(AF_INET6) {
                            var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                            if (getnameinfo(&addr, socklen_t(addr.sa_len), &hostname, socklen_t(hostname.count),nil, socklen_t(0), NI_NUMERICHOST) == 0) {
                                if let address = String(validatingUTF8:hostname) {
                                    addresses.append(address)
                                }
                            }
                        }
                    }
                    ptr = ptr!.pointee.ifa_next
                }
                freeifaddrs(ifaddr)
            }
            return addresses.first!
        }
    }
    
    // 设备ip 外网地址 
    var extranetIP:String {
        get{
            let url = URL(string: "http://ip.taobao.com/service/getIpInfo.php?ip=myip")
            let data = try! Data(contentsOf: url!)
            let ipDic = try! JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:Any]
            var ip:String? = nil
            if ipDic != nil && (ipDic!["code"] as! Int) == 0{
                let da = ipDic!["data"] as! [String:Any]
                ip = (da["ip"] as! String)
            }
            return (ip != nil ? ip! : "")
        }
    }
    
    
    
    // MARK: - instance method 实例方法 
    private override init() {
        super.init()
        setupNotification()
    }
    
    private func setupNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(networkStatusAction(notify:)), name: NSNotification.Name(rawValue: kNetworkStatusNotify), object: nil)
    }
    
    @objc func networkStatusAction(notify:Notification) -> Void {
        let obj = notify.object as! [String:Any]
        let connectType = obj["connectType"] as! MTTNetworkConnectType
        self.ENetworkConnectType = connectType
        print(obj)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - 网络请求 get 方法 
    func GETRequest(
        requestURLSting:String?, 
        parameter:[String:Any]?, 
        encoding:ParameterEncoding = URLEncoding.default, 
        requestHeader:HTTPHeaders?, 
        callBack:@escaping BResponseCallBack) -> Void 
    {
        if self.ENetworkConnectType == MTTNetworkConnectType.ethernetOrWiFi || self.ENetworkConnectType == MTTNetworkConnectType.WWAN {
            if let urlString = requestURLSting {
                var info:[String:Any] = ["time":timeStampString()]
                info = info.merging(parameter!, uniquingKeysWith: { (m, n) -> Any in
                    return n
                })
                Alamofire.request(URL(string: urlString)!, method: HTTPMethod.get, parameters: info, encoding: encoding, headers: requestHeader).responseJSON(completionHandler: { (response) in
                    switch response.result
                    {
                    case .failure(let error):
                        callBack(nil, MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: kFailureResponse, error: error)))
                    case .success(let value):
                        callBack((value as! [String : Any]), nil)
                    }
                })
            } else {
                callBack(nil, MTTError.URLError(error: MTTError.MTTRequestError.urlError(msg: "请求地址错误")))
            }
        } else {
            callBack(nil, MTTError.NetworkError(error: MTTError.MTTNetworkError.notreachable(msg: kNotreachNetwork, error: nil)))
        }
        
    }
    
    // MARK: - 网络请求 post 方法 
    func POSTRequest(
        requestURLSting:String?, 
        parameter:[String:Any]?, 
        encoding:ParameterEncoding = URLEncoding.default, 
        requestHeader:HTTPHeaders?, 
        callBack:@escaping BResponseCallBack) -> Void 
    {
        if self.ENetworkConnectType == MTTNetworkConnectType.ethernetOrWiFi || self.ENetworkConnectType == MTTNetworkConnectType.WWAN {
            if let urlString = requestURLSting {
                var info:[String:Any] = ["time":timeStampString()]
                info = info.merging(parameter!, uniquingKeysWith: { (m, n) -> Any in
                    return n
                })
                
                Alamofire.request(URL(string: urlString)!, method: HTTPMethod.post, parameters: info, encoding: encoding, headers: requestHeader).responseJSON(completionHandler: { (response) in
                    switch response.result
                    {
                    case .failure(let error):
                        callBack(nil, MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: kFailureResponse, error: error)))
                    case .success(let value):
                        callBack((value as! [String : Any]), nil)
                    }
                })
            } else {
                callBack(nil, MTTError.URLError(error: MTTError.MTTRequestError.urlError(msg: "请求地址错误")))
            }
        } else {
            callBack(nil, MTTError.NetworkError(error: MTTError.MTTNetworkError.notreachable(msg: kNotreachNetwork, error: nil)))
        }
        
    }
    
    // MARK: - 网络请求 upload file 方法 
    func UPLOADRequest(
        requestURLString:String, 
        fileData:Data, 
        file:String = "file", 
        fileName:String, 
        mimeType:String, 
        uploadProgessCallBack:@escaping BUploadProgressCallBack, 
        callBack: @escaping BResponseCallBack) -> Void 
    {
        // WiFi 
        if self.ENetworkConnectType == MTTNetworkConnectType.ethernetOrWiFi 
        {
            self.pUploadFile(requestURLString: requestURLString, fileData: fileData, file: file, fileName: fileName, mimeType: mimeType, uploadProgessCallBack: uploadProgessCallBack, callBack: callBack)
        } 
        // WwAN 蜂窝 
        else if self.ENetworkConnectType == MTTNetworkConnectType.WWAN
        {
            if self.isAllowReachNetwork == false
            {
                callBack(nil, MTTError.NetworkError(error: MTTError.MTTNetworkError.wwan(msg: "当前是蜂窝数据", error: nil)))
            } else {
                self.pUploadFile(requestURLString: requestURLString, fileData: fileData, file: file, fileName: fileName, mimeType: mimeType, uploadProgessCallBack: uploadProgessCallBack, callBack: callBack)
            }
        } else {
            callBack(nil, MTTError.NetworkError(error: MTTError.MTTNetworkError.notreachable(msg: kNotreachNetwork, error: nil)))
        }
    }
    
    // MARK: - 网络请求 download file 方法  待定 封装单独的下载器 
    func DOWNLOADRequest(requestURLString:String?, callBack:@escaping BResponseCallBack) -> Void 
    {
        // WiFi 
        if self.ENetworkConnectType == MTTNetworkConnectType.ethernetOrWiFi 
        {
            
        } 
        // WwAN 蜂窝 
        else if self.ENetworkConnectType == MTTNetworkConnectType.WWAN
        {
            if self.isAllowReachNetwork == false
            {
                
            } else {
                
            }
        } else {
            callBack(nil, MTTError.NetworkError(error: MTTError.MTTNetworkError.notreachable(msg: kNotreachNetwork, error: nil)))
        }
        
    }
    
    // MARK: - class method  类方法 
    
    
    // MARK: - private method 私有方法  
    
    /// 上传文件
    ///
    /// - Parameters:
    ///   - requestURLString: 上传地址
    ///   - fileData: 文件data
    ///   - file: file
    ///   - fileName: 文件名称 
    ///   - mimeType: 文件类型 
    ///   - uploadProgessCallBack: 上传进度回调 
    ///   - callBack: 响应回调 
    private func pUploadFile(
        requestURLString:String, 
        fileData:Data, 
        file:String = "file", 
        fileName:String, 
        mimeType:String, 
        uploadProgessCallBack:@escaping BUploadProgressCallBack, 
        callBack: @escaping BResponseCallBack) -> Void 
    {
        Alamofire.upload(multipartFormData: { (multiPartData) in
            multiPartData.append(fileData, withName: file, fileName: fileName, mimeType: mimeType)
        }, to: URL(string: requestURLString)!) { (encodingResult) in
            switch encodingResult{
                
            case .success(let request, _, _):
                request.responseJSON(completionHandler: { (response) in
                    switch response.result{
                        
                    case .success(let value):
                        callBack((value as! [String : Any]), nil)
                    case .failure(let error):
                        callBack(nil, MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: "上传文件response error", error: error)))
                    }
                })
                let upload_queue = DispatchQueue(label: "com.upload.queue", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.workItem, target: nil)
                
                request.uploadProgress(queue: upload_queue, closure: { (progress) in
                    uploadProgessCallBack(Double(progress.totalUnitCount), Double(progress.completedUnitCount), progress.fileURL)
                })
            case .failure(let error):
                callBack(nil, MTTError.FailureError(error: MTTError.MTTResponseError.failureError(msg: "上传文件encoding error", error: error)))
            }
        }
    }
    
    private func pDwonloadFile(
        requestURLSting:String?, 
        method: HTTPMethod = .get, 
        parameter:[String:Any]?, 
        encoding:ParameterEncoding = URLEncoding.default, 
        requestHeader:HTTPHeaders?, 
        downloadProgressCallBack:@escaping BDwonloadProgressCallBack, 
        callBack:@escaping BResponseCallBack) -> Void {
        
//        Alamofire.download(URL(string: requestURLSting!)!, method: method, parameters: parameter, encoding: encoding, headers: requestHeader) { (url, response) -> (destinationURL: URL, options: DownloadRequest.DownloadOptions) in
//            
//        }
    }
    
    func timeStampString() -> String {
        let timeinterval = Int(Date().timeIntervalSince1970 * 1000)
        return String(timeinterval)
    }
    
}


// MARK: - 获取网络状态回调 
@available(iOS 11.0, *)
extension MTTNetworkManager: MTTNetworkConnectTypeDelegate
{
    func pCurrentNetworkStatus(connectType: MTTNetworkConnectType) {
        self.ENetworkConnectType = connectType
    }
}
