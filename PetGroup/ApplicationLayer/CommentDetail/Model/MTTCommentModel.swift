//
//  MTTCommentModel.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/11/27.
//  Copyright © 2018 waitWalker. All rights reserved.
//

/****
 "from_username": "爱学习",
 "content": "时刻准备",
 "comment_id": "3025188092",
 "to_username": "珍爱",
 "to_uid": "1533063004211",
 "time": "3"
 ***/

import Foundation

struct MTTCommentModel {
    var fromUid:String = ""
    var toUid:String = ""
    var content:String = ""
    var commentId:String = ""
    var fromUsername:String = ""
    var toUsername:String = ""
    var time:String = ""
    
    var contentTextHeight:CGFloat   = 0.0
    var cellHeight:CGFloat          = 0.0
    var currentIndex:Int            = 0
    
    static func contentHeight(_ content:String) -> CGFloat {
        return String.calculateTextHeightWithText(content, textWidth: kScreenWidth - 60, fontSize: 16)
    }
    
    
    
}
