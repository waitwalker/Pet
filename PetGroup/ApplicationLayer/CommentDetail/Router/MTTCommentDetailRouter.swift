//
//  MTTCommentDetailRouter.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/11/26.
//  Copyright © 2018 waitWalker. All rights reserved.
//

/****
 评论详情路由
 ****/

import UIKit

class MTTCommentDetailRouter: NSObject {

    
    /// 路由入口
    ///
    /// - Parameter info: 信息
    /// - Returns: 评论详情控制器
    static func matchCommentDetail(info:[String:Any]) -> MTTCommentDetailBaseViewController {
        var commentDetailVC:MTTCommentDetailBaseViewController!
        if let model = info["circleModel"] {
            let circleModel = model as! MTTCircleModel
            switch circleModel.dynamic_Type{
                case .onlyContent:
                commentDetailVC = MTTCommentDetailOnlyContentViewController(info: info)
                case .contentAndImage:
                commentDetailVC = MTTCommentDetailContentAndImageViewController(info: info)
                case .onlyImage:
                commentDetailVC = MTTCommentDetailOnlyImageViewController(info: info)
                case .onlyVideo:
                commentDetailVC = MTTCommentDetailOnlyVideoViewController(info: info)
                case .contentAndVideo:
                commentDetailVC = MTTCommentDetailContentAndVideoViewController(info: info)
            }
        } else {
            commentDetailVC = MTTCommentDetailBaseViewController(info: info)
        }
        return commentDetailVC
    }
}
