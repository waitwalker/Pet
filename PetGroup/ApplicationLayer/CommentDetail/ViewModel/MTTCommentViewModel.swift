//
//  MTTCommentViewModel.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/11/27.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTCommentViewModelDelegate {
    
    /// 发表评论成功回调
    ///
    /// - Parameter info: info
    /// - Returns: void
    func dCommentCommitSuccessCallBack(info:[String:Any]?) -> Void
    
    /// 发表评论失败回调
    ///
    /// - Parameter info: info
    /// - Returns: void
    func dCommentCommitFailureCallBack(info:[String:Any]?) -> Void 
    
    /// 获取评论列表成功回调
    ///
    /// - Parameter info: info
    /// - Returns: void
    func dCommentListSuccessCallBack(info:[String:Any]?) -> Void 
    
    /// 获取评论列表失败回调
    ///
    /// - Parameter info: info
    /// - Returns: void
    func dCommentListFailureCallBack(info:[String:Any]?) -> Void 
}

class MTTCommentViewModel: NSObject {
    
    var DDelegate:MTTCommentViewModelDelegate?
    
    static let sharedViewModel = MTTCommentViewModel()
    
    private override init() {
        
    }
    
    ///   获取评论列表    
    ///
    /// - Parameters:
    ///   - parameter: parameter
    ///   - delegate: MTTCommentViewModelDelegate
    func getCommentList(parameter:[String:Any], delegate:MTTCommentViewModelDelegate) -> Void {
        self.DDelegate = delegate
        let urlString = kServerHost + kCommentListAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, requestHeader: nil) { (response, error) in
            if error != nil {
                self.DDelegate?.dCommentListFailureCallBack(info: nil)
            } else {
                if let responseDict = response {
                    
                    let result = responseDict["result"] as! Int
                    if result == 1 {
                        var dataSource:[MTTCommentModel] = []
                        
                        let data = responseDict["data"] as! [[String:Any]]
                        if data.count > 0 {
                            for(_,dict) in data.enumerated() {
                                var model = MTTCommentModel()
                                model.commentId = dict["comment_id"] as! String
                                model.fromUid = dict["from_uid"] as! String
                                model.fromUsername = dict["from_username"] as! String
                                model.content = dict["content"] as! String
                                model.toUsername = dict["to_username"] as! String
                                model.toUid = dict["to_uid"] as! String
                                model.time = dict["time"] as! String
                                model.contentTextHeight = MTTCommentModel.contentHeight(model.content)
                                model.cellHeight = MTTCommentModel.contentHeight(model.content + model.fromUsername + "  回复  " + ":  " + model.toUsername + model.fromUsername) + 5
                                dataSource.append(model)
                            } 
                        } else {
                            
                        }
                        self.DDelegate?.dCommentListSuccessCallBack(info: ["dataSource":dataSource])
                    } else {
                        self.DDelegate?.dCommentListFailureCallBack(info: nil)
                    }
                } else {
                    self.DDelegate?.dCommentListFailureCallBack(info: nil)
                }
            }
        }
    }
    
    
    /// 提交评论    
    ///
    /// - Parameters:
    ///   - parameter: parameter
    ///   - delegate: MTTCommentViewModelDelegate
    func commitComment(parameter:[String:Any], delegate:MTTCommentViewModelDelegate) -> Void {
        self.DDelegate = delegate
        let urlString = kServerHost + kPublishCommentAPI
        MTTNetworkManager.sharedManager.POSTRequest(requestURLSting: urlString, parameter: parameter, requestHeader: nil) { (response, error) in
            if error == nil {
                if let resDict = response {
                    let result = resDict["result"] as! Int 
                    if result == 1 {
                        self.DDelegate?.dCommentCommitSuccessCallBack(info: nil)
                    } else {
                        self.DDelegate?.dCommentCommitFailureCallBack(info: nil)
                    }
                } else {
                    self.DDelegate?.dCommentCommitFailureCallBack(info: nil)
                }
            } else {
                self.DDelegate?.dCommentCommitFailureCallBack(info: nil)
            }
        }
    }
}
