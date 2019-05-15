//
//  MTTServerAPIConst.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/18.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation


/// 服务器 
let kServerHost:String = "http://192.168.199.200:8000/"

//let kServerHost:String = "https://www.waitwalker.cn/" //remote
//let kServerHost:String = "http://192.168.10.63:8000/" //company
//let kServerHost:String = "http://192.168.199.200:8000/"  //home

// 七牛服务器
let kQiNiuServer = "http://qiniu/"

/// 接口 
// 登录
let kLoginAPI:String = "pet/login"

// 注册 
let kRegisterAPI:String = "pet/register"

// 注册设备
let kRegisterDeviceAPI:String = "pet/register_device"

// 根据设备获取动态列表 
let kDeviceDynamicListAPI:String = "pet/device_dynamic_list"

// 获取动态列表 
let kDynamicListAPI:String = "pet/dynamic_list"

// 上传文件 token
let kUploadFileToken:String = "pet/upload_token"

// 发表动态
let kPublishDynamicAPI:String = "pet/publish_dynamic"

// 发表评论
let kPublishCommentAPI:String = "pet/publish_comment"

// 获取评论列表
let kCommentListAPI:String = "pet/comment_list"


// 更换头像接口
let kAvatarAPI:String = "pet/change_avatar"

// 修改用户名 
let kUsernameAPI:String = "pet/change_username"

// 违规举报
let kReportAbuseAPI:String = "pet/report_abuse"

// 点赞取消点赞
let kPraiseAPI:String = "pet/praise"

// 推送
let kPushAPI:String = "pet/push"







