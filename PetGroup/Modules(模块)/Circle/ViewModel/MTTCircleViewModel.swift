//
//  MTTCircleViewModel.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/20.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation
import Alamofire

// MARK: - MTTCircleViewModelDelegate
protocol MTTCircleViewModelDelegate {
    
    /// 根据设备获取动态列表成功回调
    ///
    /// - Parameter dataSource: 数据
    /// - Returns: 
    func dDeviceDynamicListSuccessCallBack(_ dataSource: [MTTCircleModel]) -> Void
    
    /// 根据设备获取动态列表失败回调 
    ///
    /// - Parameter error: 错误
    /// - Returns: 
    func dDeviceDynamicListFailureCallBack(_ error: MTTError) -> Void
    
    
    /// 获取动态列表成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    func dDynamicListSuccessCallBack(_ info: [String:Any]?) -> Void
    
    
    /// 获取动态列表失败回调 
    ///
    /// - Parameter error: error 
    /// - Returns: 
    func dDynamicListFailureCallBack(_ error: MTTError) -> Void
    
    
    /// 自动登录成功回调
    ///
    /// - Parameter info: info 
    /// - Returns: 
    func dLoginSuccessCallBack(info: [String:Any]?) -> Void 
    
    /// 自动登录失败回调 
    ///
    /// - Parameter info: error
    /// - Returns: 
    func dLoginFailureCallBack(info: [String:Any]?) -> Void 
    
    
    /// 违规举报失败回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    func dReportAbuseErrorCallBack(info:[String:Any]?) -> Void 
    
    /// 违规举报成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    func dReportAbuseSuccessCallBack(info:[String:Any]?) -> Void 
    
    
    /// 点赞成功回调
    ///
    /// - Parameter info: info
    /// - Returns: 
    func dPraiseSuccessCallBack(info:[String:Any]) -> Void
    
    
    /// 点在失败回调
    ///
    /// - Parameter info: info 
    /// - Returns: 
    func dPraiseFailureCallBack(info:[String:Any]) -> Void 
    
}

@available(iOS 11.0, *)
class MTTCircleViewModel {
    
    var DDelegate:MTTCircleViewModelDelegate?
    
    
    var MCircleModels:[MTTCircleModel] = []
    
    
    /// 构造函数 
    ///
    /// - Parameter info: info 
    init(info:[String:Any]?) {
        if info != nil {
            MTTCircleService.DDelegate = self
            let timeinterval:TimeInterval = 1.0
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeinterval) { 
                self.handler(info: info!)
            }
        }
    }
    
    // MARK: - 处理自动登录逻辑 
    func handler(info:[String:Any]) -> Void {
        
        let deviceToken = info["deviceToken"] as! String
        let isNeedAutoLogin = info["isNeedAutoLogin"] as! Bool
        let phone = info["phone"] as! String
        let password = info["password"] as! String
        
        // 验证是否需要自动登录 : 需要自动登录说明已经通过账号密码登录过 
        if isNeedAutoLogin == true {
            let parameter = ["phone":phone, "password":password]
            MTTCircleService.commonLogin(info: parameter)
        } else {
            var parameter = ["deviceToken":deviceToken]
            if deviceToken.count > 0 {
                MTTCircleService.getDeviceDynamicList(info: parameter)
            } else {
                parameter.updateValue(self.getDeviceToken(), forKey: "deviceToken")
                MTTCircleService.registerDevice(info: parameter)
            }
        }
    }
    
    // MARK: - 获取动态列表 
    func getDynamicList(info:[String:Any]?) -> Void {
        MTTCircleService.getDynamicListAction(info: info)
    }
    
    // MARK: - 获取设备token 
    private func getDeviceToken() -> String {
        let deviceToken = UIDevice.current.identifierForVendor?.uuidString
        
        let result = MTTRealm.queryObjects(type: MTTLoginInfoTable.self)
        
        // 已经插入数据了
        if (result?.count)! > Int(0) {
            let loginInfo = result?.first as! MTTLoginInfoTable
            try! MTTRealm.sharedRealm.write {
                loginInfo.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
                loginInfo.password = MTTUserInfoManager.sharedUserInfo.password
                loginInfo.phone = MTTUserInfoManager.sharedUserInfo.phone
            }
            //try! MTTRealm.sharedRealm.commitWrite()
            
        } else {
            MTTRealm.sharedRealm.beginWrite()
            let infoTable = MTTLoginInfoTable()
            infoTable.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
            infoTable.deviceToken = deviceToken!
            infoTable.password = MTTUserInfoManager.sharedUserInfo.password
            infoTable.phone = MTTUserInfoManager.sharedUserInfo.phone
            MTTRealm.sharedRealm.add(infoTable)
            try! MTTRealm.sharedRealm.commitWrite()
        }
        return deviceToken!
    }
    
    // MARK: - 上报违规内容
    func reportAbuse(model:MTTCircleModel, info:[String:Any]) -> Void {
        
        let r_keyword = info["report_keyword"]
        let r_content = info["report_content"]
        var report_keyword:String = ""
        var report_content:String = ""
        if r_keyword != nil && r_content != nil {
            report_keyword = r_keyword as! String
            report_content = r_content as! String
        }
        
        let parameter = ["report_keyword":report_keyword,
                         "report_content":report_content,
                         "content":model.content,
                         "topic_id":model.topic_id
            ] as [String : Any]
        
        let urlString:String = kServerHost + kReportAbuseAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, encoding: URLEncoding.default, requestHeader: nil) { (response, error) in
            if error != nil {
                let inf:[String:Any] = ["msg":kReportFailureString
                ]
                self.DDelegate?.dReportAbuseErrorCallBack(info: inf)
            } else {
                let result = response!["result"] as! Int
                if result == 1 {
                    self.DDelegate?.dReportAbuseSuccessCallBack(info: ["msg":"举报成功","currentIndex":model.currentIndex])
                } else {
                    let inf:[String:Any] = ["msg":kReportFailureString
                    ]
                    self.DDelegate?.dReportAbuseErrorCallBack(info: inf)
                }
            }
        }
    }
    
    func getPraiseState(parameter:[String:Any]?) -> Void {
        MTTCircleService.praiseRequest(parameter: parameter)
    }
}

// MARK: - MTTCircleServiceDelegate 回调 
@available(iOS 11.0, *)
extension MTTCircleViewModel: MTTCircleServiceDelegate
{
    func dPraiseRequestSuccessCallBack(response: [String : Any]) {
        self.DDelegate?.dPraiseSuccessCallBack(info: response)
    }
    
    func dPraiseRequestFailureCallBack(response: [String : Any]) {
        self.DDelegate?.dPraiseFailureCallBack(info: response)
    }
    
    
    /// 动态列表获取失败回调 
    ///
    /// - Parameter error: error 
    func dDynamicListFailureCallBack(error: MTTError) {
        self.DDelegate?.dDynamicListFailureCallBack(error)
    }
    
    
    /// 动态列表获取成功回调 
    ///
    /// - Parameter response: response
    func dDynamicListSuccessCallBack(response: [String : Any]) {
        
        if MCircleModels.count > 0 {
            MCircleModels.removeAll()
        }
        let result = response["result"] as! Int
        let data = response["data"] as! [String:Any]
        let dynamic_list = data["dynamic_list"] as! [[String:Any]]
        let isHaveMoreData:Int = data["isHaveMoreData"] as! Int
        
        if result == 1 && dynamic_list.count > 0 {
            for (index, dict) in dynamic_list.enumerated()
            {
                var circleModel = MTTCircleModel()
                circleModel.modelIndex = index
                circleModel.username = dict["username"] as! String
                circleModel.content = dict["content"] as! String
                circleModel.topic_id = dict["topic_id"] as! String
                circleModel.uid = dict["uid"] as! String
                circleModel.time = String.generateExpectedTime(timeStamp: dict["time"] as! String)
                
                let attach = dict["attach"] as! String
                circleModel.header_photo = dict["header_photo"] as! String
                circleModel.dynamic_Type = MTTDynamicType(rawValue: dict["dynamicType"] as! Int)!
                if dict["comment_num"] != nil {
                    circleModel.commentNum = String(dict["comment_num"] as! Int)
                } else {
                    circleModel.commentNum = ""
                }
                
                if dict["praise_num"] != nil {
                    circleModel.praiseNum = String(dict["praise_num"] as! Int)
                } else {
                    circleModel.praiseNum = ""
                }
                
                if dict["isPraise"] != nil {
                    circleModel.isPraise = (dict["isPraise"] as! Bool)
                }
                
                switch circleModel.dynamic_Type
                {
                // 只有文本 
                case .onlyContent:
                    circleModel.contentTextHeight = String.calculateTextHeight(circleModel.content, fontSize: 17)
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentTextHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                    kCircleCellCommentBarBottomMarginHeight
                    circleModel.attach = []
                // 文本和图片
                case .contentAndImage:
                    circleModel.contentTextHeight = String.calculateTextHeight(circleModel.content, fontSize: 17)
                    if attach.contains(",") {
                        let attachArr = attach.components(separatedBy: ",")
                        circleModel.attach = attachArr.map { element in
                            return element
                        }
                    } else {
                        circleModel.attach.append(attach)
                    }
                    
                    circleModel.contentImageHeight = kCircleCellImageHeight
                    if circleModel.attach.count == 2 {
                        circleModel.contentImageHeight = circleModel.contentImageHeight / 2.0 + 30.0
                    }
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentTextHeight +
                        kCircleCellImageTopMarginHeight +
                        circleModel.contentImageHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                    kCircleCellCommentBarBottomMarginHeight
                    
                // 只有图片 
                case .onlyImage:
                    if attach.contains(",") {
                        let attachArr = attach.components(separatedBy: ",")
                        circleModel.attach = attachArr.map { element in
                            return element
                        }
                    } else {
                        circleModel.attach.append(attach)
                    }
                    
                    circleModel.contentImageHeight = kCircleCellImageHeight
                    if circleModel.attach.count == 2 {
                        circleModel.contentImageHeight = circleModel.contentImageHeight / 2.0 + 30.0
                    }
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentImageHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                    kCircleCellCommentBarBottomMarginHeight
                    
                // 文本和视频 
                case .contentAndVideo:
                    circleModel.contentTextHeight = String.calculateTextHeight(circleModel.content, fontSize: 17)
                    circleModel.attach.append(attach)
                    circleModel.contentVideoHeight = kCircleCellVideoHeight
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentTextHeight +
                        kCircleCellVideoTopMarginHeight +
                        circleModel.contentVideoHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                    kCircleCellCommentBarBottomMarginHeight
                    
                // 只有视频 
                case .onlyVideo:
                    circleModel.contentVideoHeight = kCircleCellVideoHeight
                    circleModel.attach.append(attach)
                    circleModel.contentImageHeight = kCircleCellImageHeight
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentVideoHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                    kCircleCellCommentBarBottomMarginHeight
                }
                MCircleModels.append(circleModel)
            }
        }
        let the_info:[String:Any] = ["dataSource":MCircleModels,
                        "isHaveMoreData":isHaveMoreData
                        ]
        
        self.DDelegate?.dDynamicListSuccessCallBack(the_info)
    }
    
    
    /// 自动登录成功回调 
    ///
    /// - Parameter info: info 
    func dLoginSuccessCallBack(info: [String : Any]?) {
        self.DDelegate?.dLoginSuccessCallBack(info: info)
    }
    
    /// 自动登录失败回调 
    ///
    /// - Parameter info: info 
    func dLoginFailureCallBack(info: [String : Any]?) {
        self.DDelegate?.dLoginFailureCallBack(info: info)
    }
    
    
    /// 根据设备获取动态列表成功回调 
    ///
    /// - Parameter response: response
    func dDeviceDynamicListSuccessCallBack(response: [String : Any]) {
        print("response:", response)
        let result = response["result"] as! Int
        let data = response["data"] as! [String:Any]
        let dynamic_list = data["dynamic_list"] as! [[String:Any]]
        
        if result == 1 && dynamic_list.count > 0 {
            for (index, dict) in dynamic_list.enumerated()
            {
                print(dict, index)
                var circleModel = MTTCircleModel()
                circleModel.username = dict["username"] as! String
                circleModel.content = dict["content"] as! String
                circleModel.time = String.generateExpectedTime(timeStamp: dict["time"] as! String)
                let attach = dict["attach"] as! String
                circleModel.header_photo = dict["header_photo"] as! String
                circleModel.dynamic_Type = MTTDynamicType(rawValue: dict["dynamicType"] as! Int)!
                switch circleModel.dynamic_Type
                {
                    // 只有文本 
                    case .onlyContent:
                    circleModel.contentTextHeight = String.calculateTextHeight(circleModel.content, fontSize: 17)
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentTextHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                        kCircleCellCommentBarBottomMarginHeight
                    
                    // 文本和图片
                    case .contentAndImage:
                    circleModel.contentTextHeight = String.calculateTextHeight(circleModel.content, fontSize: 17)
                    
                    if attach.contains(",") {
                        let attachArr = attach.components(separatedBy: ",")
                        circleModel.attach = attachArr.map { element in
                            return element
                        }
                    } else {
                        circleModel.attach.append(attach)
                    }
                    circleModel.contentImageHeight = kCircleCellImageHeight
                    
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentTextHeight +
                        kCircleCellImageTopMarginHeight +
                        circleModel.contentImageHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                        kCircleCellCommentBarBottomMarginHeight
                    
                    // 只有图片 
                    case .onlyImage:
                        if attach.contains(",") {
                            let attachArr = attach.components(separatedBy: ",")
                            circleModel.attach = attachArr.map { element in
                                return element
                            }
                        } else {
                            circleModel.attach.append(attach)
                        }
                    circleModel.contentImageHeight = kCircleCellImageHeight
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentImageHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                        kCircleCellCommentBarBottomMarginHeight
                    
                    // 文本和视频 
                    case .contentAndVideo:
                    circleModel.contentTextHeight = String.calculateTextHeight(circleModel.content, fontSize: 17)
                    circleModel.attach.append(attach)
                    circleModel.contentVideoHeight = kCircleCellVideoHeight
                    
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentTextHeight +
                        kCircleCellVideoTopMarginHeight +
                        circleModel.contentVideoHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                        kCircleCellCommentBarBottomMarginHeight
                    
                    
                    // 只有视频 
                    case .onlyVideo:
                    circleModel.contentVideoHeight = kCircleCellVideoHeight
                    circleModel.attach.append(attach)
                    circleModel.contentImageHeight = kCircleCellImageHeight
                    circleModel.cellHeight =
                        kCircleCellTopMarginHeight +
                        kCircleCellUsernameTopMarginHeight +
                        kCircleCellUsernameHeight +
                        kCircleCellTimeTopMarginHeight +
                        kCircleCellTimeHeight +
                        kCircleCellContentTopHeight +
                        circleModel.contentVideoHeight +
                        kCircleCellCommentBarTopMarginHeight +
                        kCircleCellCommentBarHeight +
                    kCircleCellCommentBarBottomMarginHeight
                    
                }
                
                MCircleModels.append(circleModel)
            }
        }
        self.DDelegate?.dDeviceDynamicListSuccessCallBack(MCircleModels)
    }
    
    
    /// 根据设备获取动态列表失败回调
    ///
    /// - Parameter error: error 
    func dDeviceDynamicListFailureCallBack(error: MTTError) {
        print("根据设备获取动态列表失败 error: ", error)
        self.DDelegate?.dDeviceDynamicListFailureCallBack(error)
    }
    
    
    /// 注册设备成功回调
    ///
    /// - Parameter response: response 
    func dRegisterDeviceSuccessCallBack(response: [String : Any]) {
        let data = response["data"]! as! [String:Any]
        MTTCircleService.getDeviceDynamicList(info: data)
    }
    
    
    /// 注册设备失败回调
    ///
    /// - Parameter error: error
    func dRegisterDevicefailureCallBack(error: MTTError) {
        self.DDelegate?.dDynamicListFailureCallBack(error)
    }
    
    
    
}
