//
//  MTTCircleModel.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/23.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit


/// 动态类型 
///
/// - onlyContent: 
/// - contentAndImage: 
/// - onlyImage: 
/// - contentAndVideo: 
/// - onlyVideo: 
enum MTTDynamicType:Int {
    case onlyContent     = 0  //只有文本
    case contentAndImage = 1  //文本和图片
    case onlyImage       = 2  //只有图片
    case contentAndVideo = 3  //文本和视频
    case onlyVideo       = 4  //只有视频 
}

let kCircleCellTopMarginHeight:CGFloat = 10.0
let kCircleCellUsernameTopMarginHeight:CGFloat = 15.0
let kCircleCellUsernameHeight:CGFloat = 20.0
let kCircleCellTimeTopMarginHeight:CGFloat = 5.0
let kCircleCellTimeHeight:CGFloat = 15.0
let kCircleCellContentTopHeight:CGFloat = 10.0
let kCircleCellCommentBarTopMarginHeight:CGFloat = 10.0
let kCircleCellCommentBarBottomMarginHeight:CGFloat = 10.0
let kCircleCellCommentBarHeight:CGFloat = 25.0
let kCircleCellImageTopMarginHeight:CGFloat = 5.0
let kCircleCellVideoTopMarginHeight:CGFloat = 5.0
let kCircleCellImageHeight:CGFloat = 200.0
let kCircleCellVideoHeight:CGFloat = 200.0










/// circle 数据结构 
struct MTTCircleModel:Hashable {
    var username:String             = ""
    var header_photo:String         = ""
    var content:String              = ""
    var attach:[String]             = []
    var time:String                 = ""
    var dynamic_Type:MTTDynamicType = MTTDynamicType.onlyContent
    var topic_id:String             = ""
    var uid:String                  = ""
    var commentNum:String           = ""
    var isPraise:Bool               = false
    var praiseNum:String            = ""
    var contentTextHeight:CGFloat   = 0.0
    var contentImageHeight:CGFloat  = 0.0
    var contentVideoHeight:CGFloat  = 0.0
    var cellHeight:CGFloat          = 0.0
    var currentIndex:Int            = 0
    var modelIndex:Int              = 0
    

}

