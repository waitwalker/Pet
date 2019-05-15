<p align="center">
<img src="https://upload-images.jianshu.io/upload_images/1715253-c27077ff77062e8a.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240" alt="Pet" title="Pet" width="200"/>
</p>

### 简介

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;狗圈儿是一个宠物社交软件,目的是广纳狗友,深入交流,分享快乐.狗圈儿是一个包含前台和后台的完整项目,从代码编写,图形图标设计,再到部署,调试,上架发布都由本人完成,稀稀拉拉历经几个月完成.前台开发采用的是Swift编写,现在已经适配到最新的SDK版本,如果你的Xcode不是最新的请先升级到最新版本.项目已经打包发布到[**App Store**](https://itunes.apple.com/US/app/id1395622129?mt=8),App主要适配了iPhone端,iPad接口预留了,没有适配.目前[**App Store**](https://itunes.apple.com/US/app/id1395622129?mt=8)中版本是1.4.后台Web服务接口用Python语言开发,采用的是Tornado web server.数据库用的MySql和Redis缓存,server和数据库都部署在一台vps上了,资源文件托管在七牛上.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;现在前台和后台源码全部开源到GitHub上,如果有需要,可以clone下来看一下.由于个人的服务器再朝外,涉及到流量等问题,服务器地址,七牛托管上传文件的token等暂不对外公布,如果想部署服务,在下文中会详细讲一下具体改哪些地方或者私信给我也行.

前台代码:[https://github.com/waitwalker/Pet](https://github.com/waitwalker/Pet)

后台代码:[https://github.com/waitwalker/PetAPI](https://github.com/waitwalker/PetAPI)

**如果对你有帮助,请给我一个赞或星,感谢!**

贴几张图:
![狗圈儿](https://upload-images.jianshu.io/upload_images/1715253-9a0046e4dc959330.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 前台
### 整体结构
项目结构基本按照模块来划分.

```

.

└── PetGroup

├── ApplicationLayer

│   └── CommentDetail

├── CommonConfig

│   └── MTTCommonConfig.swift

├── Commons # 一些封装组件&扩展等

│   ├── BaseClass

│   ├── Bridge

│   ├── Const

│   ├── Core

│   ├── Database

│   ├── Extension

│   ├── Router

│   ├── Security

│   ├── Sequence

│   ├── ThirdFramework

│   └── Tools

├── Main #入口函数&资源文件

│   ├── AppDelegate.swift

│   ├── Assets.xcassets

│   ├── Base.lproj

│   ├── Info.plist

│   ├── zh-Hans.lproj

│   └── zh-Hant.lproj

├── Modules #主要模块

│   ├── Circle #首页

│   ├── LaunchProgress #启动广告页

│   ├── Login&Register #登录注册

│   ├── Personal #个人中心

│   ├── PetRecognise #鉴宠

│   ├── PopularScience

│   └── WelcomePage #欢迎引导页

├── PetGroup.entitlements

└── README.md

```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;程序在启动的时候封装了一个超级管理类MTTSuperiorManager,其主要作用是接收不同的任务类型,然后将任务任务下发给助手实施.MTTAssistantManager是一个基类,其只负责转接超级管理者下发的任务,具体的任务由其子类去实现.MTTAssistantManager就像人体的大脑一样,指挥着MTTArmManager手臂,MTTLegManager等去完成具体的任务.然后将执行的结果回调给命令的发出者.

下面是一个简单的示例:

1)程序启动->给MTTSuperiorManager发一个launchAssistant任务

```

MTTSuperiorManager.sharedSuperiorManager.applyAssitant(application: application, assistantType: MTTAssistantType.launchAssistant)

```

2)MTTSuperiorManager收到任务后,将任务交给MTTAssistantManager基类

```

func applyAssitant(application: UIApplication, assistantType:MTTAssistantType) -> Void {

MTTAssistantManager.assistantHandler(["application": application], assistantType: assistantType)

}

```

3)MTTAssistantManager基类判断具体任务类型,将任务交给去实施

```

static func assistantHandler(_ info: [String:Any]?, assistantType: MTTAssistantType) -> Void {

switch assistantType {

case .interfaceAssistant:

let interfaceAssistant = MTTInterfaceAssistantManager()

let application = info!["application"] as! UIApplication

//具体实施&回调

interfaceAssistant.handlerInterface(application: application)

case .launchAssistant:

handlerLaunch()

case .initializePetRecogniseData:

MTTPetRecogniseDataAssistant.initializePetRecogniseData()

}

}

```

4)MTTInterfaceAssistantManager子类实施启动任务

```

override func handlerInterface(application: UIApplication) {

pSetupStatistic()

_ = UMConfigure.deviceIDForIntegration()

//MTTPrint("deviceID:\(deviceID)")

self.setupMainUI()

let appDelegate = application.delegate as! AppDelegate

let tabBarController = UITabBarController()

tabBarController.viewControllers = makeChildControllers()

appDelegate.window?.rootViewController = tabBarController

appDelegate.window?.makeKeyAndVisible()

}

```
![狗圈儿任务时序图](https://upload-images.jianshu.io/upload_images/1715253-79ff6b9e385da533.jpg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

其它任务类型具体请看源码.

### 主要模块

项目整体大概分为:广告页,欢迎引导,登录注册等模块

#### 广告页

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;广告页MTTLauchProgressController,其弹出的方法定义在MTTLaunchInterface接口文件中,然后有首页MTTCircleViewController实现了这个方法,然后弹出广告页,广告页的内容暂时定的为一张静态图片,如果有需要你可以在这里面拓展你自己的广告图片链接.

```

extension MTTCircleViewController: MTTLaunchInterface

{

func iLaunchProgressPage(info: [String : Any]?) {

let progressVC = MTTLauchProgressController()

self.pushViewController(progressVC)

}

}

```

![广告页](https://upload-images.jianshu.io/upload_images/1715253-eaa6e0393d5f933a.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 欢迎引导

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;欢迎引导出现在第一次安装启动应用或者版本有变化时.应用启动完毕后,判断是否应该弹出欢迎引导页并通过回调方式告诉调用者是否需要显示欢迎引导页:

```

// 注册欢迎引导页,判断是否弹出欢迎引导页

MTTWelcomePageManager.handlerWelcomePage(handler: self, appVersion: MTTDeviceInfoManager.currentDeviceManager.appVersion)

/// 处理启动页 :是否需要出现启动页

///

/// - Parameters:

/// - handler: 处理者

/// - appVersion: 版本

static func handlerWelcomePage(handler:MTTWelcomePageInterface, appVersion:String) -> Void {

let filterStr = "name = 'petGroup'"

let result = MTTRealm.queryObject(type: MTTPetGroupInfoModel.self, filter: filterStr)

// 已经插入数据了

if (result?.count)! > Int(0) {

let petGroup = result?.first as! MTTPetGroupInfoModel

var isShow:Bool = false

if petGroup.version == appVersion

{

isShow = false

handler.iShouldShowWelcomePage(show: isShow)

}else {

isShow = true

MTTRealm.sharedRealm.beginWrite()

petGroup.version = appVersion

try! MTTRealm.sharedRealm.commitWrite()

handler.iShouldShowWelcomePage(show: isShow)

}

} else {

MTTRealm.sharedRealm.beginWrite()

let petGroupInfo = MTTPetGroupInfoModel()

petGroupInfo.name = "petGroup"

petGroupInfo.version = appVersion

MTTRealm.sharedRealm.add(petGroupInfo)

try! MTTRealm.sharedRealm.commitWrite()

handler.iShouldShowWelcomePage(show: true)

}

}

```

回调处理:

```

extension AppDelegate: MTTWelcomePageInterface

{

func iShouldShowWelcomePage(show: Bool) {

if show {

// 第一次 显示欢迎引导

MTTTaskCenter.iDispatchTask(registerTo: self, taskType: MTTTaskCenterTaskType.welcomePageTask, info: nil)

} else {

// 非第一次 注册广告任务 到根控制器

MTTSuperiorManager.sharedSuperiorManager.applyAssitant(application: UIApplication.shared, assistantType: MTTAssistantType.interfaceAssistant)

}

}

}

```

#### 登录注册

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;登录和注册均采用的是手机号注册,方式简单,由于需要一些投入前期没有添加验证码验证.第三方登录目前支持QQ,微博和钉钉.

![登录注册](https://upload-images.jianshu.io/upload_images/1715253-eb993feca589d4ed.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 首页心情

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;首页心情列表实现逻辑,如果用户是第一次启动APP,将根据设备UUID获取心情列表,最多获取10条数据.如果已经注册登录过,可以分页加载列表,每页10条. 之前在上传到App Store中遇到一个问题:需要举报屏蔽功能,因此首页某条心情被举报了,应该屏蔽掉,其实现算法如下:

```

// MARK: - 查询被屏蔽的用户

private func pSetupBlockUserUid() -> Void {

let result = MTTRealm.queryObjects(type: MTTBlockAbuseUserTable.self)

if (result?.count)! > 0 {

for (_,abuseUser) in (result?.enumerated())! {

let abuse = abuseUser as! MTTBlockAbuseUserTable

MTTUserInfoManager.sharedUserInfo.blockUserUidArray.insert(abuse.uid)

}

}

}

func dDynamicListSuccessCallBack(_ info: [String : Any]?) {

let dataSource = info!["dataSource"] as! [MTTCircleModel]

let isHaveMoreData = info!["isHaveMoreData"] as! Int

if MTTUserInfoManager.sharedUserInfo.blockUserUidArray.count <= 0 {

for (_,circelModel) in dataSource.enumerated() {

ODataSource.append(circelModel)

}

} else {

var tmpD = dataSource

var tmpIndexArray:[Int] = []

for (index, model) in dataSource.enumerated() {

if MTTUserInfoManager.sharedUserInfo.blockUserUidArray.contains(model.uid) {

tmpIndexArray.append(index)

}

}

for (i, index) in tmpIndexArray.enumerated() {

tmpD.remove(at: index - i)

}

let tmpDataSource:[MTTCircleModel] = tmpD

let newDataSource = tmpDataSource.sorted { (model_one, model_two) -> Bool in

return model_one.modelIndex < model_two.modelIndex

}

for (_,circelModel) in newDataSource.enumerated() {

ODataSource.append(circelModel)

}

}

pRemoveHUD()

VCircleTableView.reloadData()

self.VCircleTableView.mj_footer.endRefreshing()

self.VCircleTableView.mj_header.endRefreshing()

self.isHaveMoreData = isHaveMoreData

if isHaveMoreData == 0 {

self.view.toast(message: "没有更多数据啦")

}

}

```
![首页](https://upload-images.jianshu.io/upload_images/1715253-2f27e7d632ca4633.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 撰写评论&点赞
![撰写评论](https://upload-images.jianshu.io/upload_images/1715253-c8a11004c6f12291.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 举报&屏蔽
![举报屏蔽](https://upload-images.jianshu.io/upload_images/1715253-f9aba3038818752c.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 鉴宠
![鉴宠](https://upload-images.jianshu.io/upload_images/1715253-c9f5ca3b15ed4177.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 个人中心
![个人中心](https://upload-images.jianshu.io/upload_images/1715253-a0c21d2350c68bf8.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 推送
![推送](https://upload-images.jianshu.io/upload_images/1715253-92a33893379b444f.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

#### 分享
![分享](https://upload-images.jianshu.io/upload_images/1715253-f9eeeaa579941429.PNG?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

### 主要技术
#### 自动布局

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;自动布局是给控件添加约束,最终转换成计算控件frame,从而实现布局的过程.苹果的SDK可以通过代码实现,也可以通过Interface Builder直接给控件添加约束.也有一些第三方的封装组件,像Masonry,SnapKit等.本项目中一些页面大多采用SnapKit来布局.SnapKit为每个view拓展了一个snp计算属性,继承自ConstraintViewDSL,通过如下构造函数,将待约束的view传给ConstraintViewDSL

```

internal init(view: ConstraintView) {

self.view = view

}

```

ConstraintViewDSL内部持有个待约束的存储属性view:

```

internal let view: ConstraintView

```

然后snp调用其内部的实例方法,给控件添加约束,通过closure回调:

```

public func makeConstraints(_ closure: (_ make: ConstraintMaker) -> Void) {

ConstraintMaker.makeConstraints(item: self.view, closure: closure)

}

```

如果需要,可以继续深入继续研究.

#### 响应式

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;RxSwift把程序中的每一个操作都看成一个事件,而事件是从事件源中不断发出的,事件源可以是一个button,一个textField等.每一个事件都涉及到输入和输出,比如当你把点击一个事件输入给一个button时,这个button会给你输出一个touch事件,你只需要监听这个touch事件,对这个事件作出需要的响应就可以了.项目中部分模块采用MVVM架构,将相关事件的输入和输出封装到viewModel里面,view持有viewModel,将事件源输入给viewModel,viewModel依据业务逻辑处理后将事件输出给view去响应.

#### 加密

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;加密有对称加密和非对称加密,加密可以理解为将明文经过某种转换或计算使之成为你看不懂的过程.常见的非对称加密方法:RSA,有一把公钥,一把私钥;公钥加密的内容只有私钥能解开,私钥加密的内容只有公钥能解开.对称加密加密方法有:AES,DES等,其使用同一把秘钥key.其加密强度主要取决于key的复杂度.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目在密码那块采用了AES加密,然后将密文传输到服务器,同时持久化在本地用于下次自动登录.第二用到的地方是在上传图片获取七牛token时,用密码密文当做一个验证.这里封装了加解密方法:

```

// MARK: - instance method 实例方法

// MARK: - class method 类方法

/// AES ECB 128 加密

///

/// - Parameter originalString: 原始内容

/// - Returns: 加密后内容

static func AES_ECB_128_Encode(originalString:String) -> String {

let data = originalString.data(using: String.Encoding.utf8)

// byte 数组

var encrypted:[UInt8] = []

do {

let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: Padding.pkcs7)

encrypted = try aes.encrypt((data?.bytes)!)

} catch let error {

print(error)

}

let encoded = Data(encrypted)

return encoded.base64EncodedString()

}

/// AES ECB 128 解密

///

/// - Parameter content: 加密内容

/// - Returns: 解密后

static func AES_ECB_128_Decode(content:String) -> String {

let data = NSData(base64Encoded: content, options: NSData.Base64DecodingOptions.init(rawValue: 0))

var encrypted:[UInt8] = []

let count = data?.length

for i in 0..<count! {

var tmp:UInt8 = 0

data?.getBytes(&tmp, range: NSRange(location: i,length:1 ))

encrypted.append(tmp)

}

// decode AES

var decrypted: [UInt8] = []

do {

let aes = try AES(key: key, blockMode: CBC(iv: iv), padding: Padding.pkcs7)

decrypted = try aes.decrypt(encrypted)

} catch let error {

print(error)

}

// byte 转换成NSData

let encoded = Data(decrypted)

//解密结果从data转成string

let str = String(data: encoded, encoding: String.Encoding.utf8)

return str!

}

```

#### 持久化

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;iOS上的持久化方案有多种:plist,用户偏好,sqlite,Core Data,还有目前比较流行的Realm.除了Core Data,大都使用过,使用方法都相对简单.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;狗圈儿中在存储设备信息,登录后用户信息,屏蔽用户,鉴宠中的宠物名称等地方建立了对应的表在本地保存相应的信息.

```

class MTTLoginInfoTable: Object {

@objc dynamic var id:Int = 0 //主键

@objc dynamic var deviceToken:String = "" //设备标识

@objc dynamic var isNeedAutoLogin:Bool = false //是否需要自动登录

@objc dynamic var phone:String = "" //手机

@objc dynamic var password:String = "" //密码

@objc dynamic var isNormalLogin = true

@objc dynamic var header_photo = ""

override static func primaryKey() -> String? {

return "id"

}

// 添加索引

override static func indexedProperties() -> [String] {

return ["phone"]

}

}

/// 屏蔽用户数据表

class MTTBlockAbuseUserTable: Object {

@objc dynamic var id:String = "" //主键

@objc dynamic var uid:String = ""

@objc dynamic var blockUids:String = ""

override static func primaryKey() -> String? {

return "id"

}

}

```

#### 网络

程序中网络利用Alamofire来请求服务.

基本用法:

HTTP - [HTTP 方法](#HTTP 方法), 请求参数编码, HTTP Headers, 认证

大量数据 - 下载数据到文件, 上传数据到服务器

工具 - 指标统计, [cURL 命令输出](#cURL 命令输出)

高级用法:

URL 会话 - 会话管理, 会话代理, 请求

请求路由 - 请求路由, Adapting and Retrying Requests

模型对象 - 自定义响应序列化器

网络连接 - 安全性, 网络可用性

#### 图片缓存

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;图片缓存采用的是Kingfisher. Kingfisher是基于NSURLSession的异步图片下载和缓存框架.其实现原理和SDWebImage有些类似.可以通过源码了解其过程原理.

#### 远程推送

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;iOS远程推送主要是APNs(Apple Push Ontification service),主要利用的是苹果server和每个device建立连接,ANPs收到推送provider的推送任务,然后将推送任务下发到目标device,device将推送消息下发给具体的APP.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;项目中推送后台主要利用友盟提供的API,用Python实现了一个推送接口,管理员用户(也就是我的手机),会有推送页面,添加完推送参数后直接,调用这个接口,实现推送服务.当然也可以直接在后台封装苹果的推送API,在需要的时候直接调用,不过deviceToken等你需要自己维护.

### 资源托管

七牛

### 第三方依赖库

## 后台

### 服务器

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;狗圈儿后台web服务接口用的是Tornado.Tornado 是一个Python web框架和异步网络库，起初由 FriendFeed 开发. 通过使用非阻塞网络I/O， Tornado可以支撑上万级的连接，处理 长连接, WebSockets ，和其他需要与每个用户保持长久连接的应用.后来被Facebook收纳开源.

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;目前部署在购买的Google vps上(之前试过多家的vps,个人觉得谷歌的很稳定,不过价钱也高),这个vps除了跑了一个Tornado服务,之前还用Nginx搭了一个个人站点(https://waitwalker.cn),后来撤了,迁移到别的地方了.一些资源图片保存在七牛上,七牛给每个人用户提供10G对象存储空间,每月固定万次请求,超过收费了.

后台项目结构:

```

.

├── Configs

│   └── __init__.py

├── Handlers

│   ├── MTTAESHandler.py

│   ├── MTTBaseHandler.py

│   ├── MTTChangeAvatarHandler.py

│   ├── MTTChangePasswordHandler.py

│   ├── MTTChangeUsernameHandler.py

│   ├── MTTCommentListHandler.py

│   ├── MTTCommentReplyListHandler.py

│   ├── MTTDeviceDynamicListHandler.py

│   ├── MTTDynamicListHandler.py

│   ├── MTTFileUploadHandler.py

│   ├── MTTFilterKeywordManager.py

│   ├── MTTLoginHandler.py

│   ├── MTTPublishCommentHandler.py

│   ├── MTTPublishDynamicHandler.py

│   ├── MTTPublishReplyHandler.py

│   ├── MTTRegisterDeviceHandler.py

│   ├── MTTRegisterHandler.py

│   ├── MTTReplyListHandler.py

│   ├── MTTReportAbuseHandler.py

│   ├── MTTUploadTokenHandler.py

│   ├── __init__.py

│   ├── __pycache__

│   └── files

├── Libs

│   └── __init__.py

├── MainServer.py

├── Models

│   ├── MTTDataBase.py

│   ├── __init__.py

│   └── __pycache__

├── Security

│   ├── MTTSecurityManager.py

│   ├── __init__.py

│   └── __pycache__

├── loggers

│   ├── pet_error.log

│   ├── pet_info.log

│   └── tornado_main.log

└── urls

├── __init__.py

├── __pycache__

└── urls.py

```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;入口函数在MainServer.py文件. urls是路由层,匹配请求的接口名称,转发到Handlers处理具体的接口业务.算了一下,大概写了20个左右接口,其中MTTUploadTokenHandler.py模块是处理七牛上传token的接口,这个接口加了redis缓存,10个小时内七牛token不会过期.如果你需要,可以把下面的三个替换成你自己的:

```

access_key = '七牛access_key'

secret_key = '七牛secret_key'

bucket_name = '文件桶名称'

```

### 安装依赖

项目中用的第三方依赖安装文件放在/Configs/requirements.txt中:

```

tornado==4.5.1

qiniu==7.2.2 #七牛token模块

redis==3.0.1

PyMySOL==0.7.11

bcrypy==3.1.3

pycrypto==2.6.1

```

如果想部署安装直接执行:pip install -r requirements.txt

### 数据库

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;后台项目的数据存储主要是MySql和Redis,共创建了6张表.MySql server也安装在自己vps上了.Redis主要用于做缓存处理了.这里我导出创建相关表的sql脚本,放到项目的Configs下,需要的可以跑一下.

### 部署

部署分为要不要调用上传图片接口:

1)不涉及资源图片上传:

后台:

直接将项目clone下来,安装requirements.txt里面想的相关依赖,运行MainServer.py里面的入口函数.

前台:

将/Commons/Const/MTTServerAPIConst.swift文件中的kServerHost改成你自己的server地址,例如:

```

let kServerHost:String = "http://192.168.10.63:8000/

```

2)涉及到资源图片上传:

后台:

在MTTUploadTokenHandler.py模块中,添加自己的相关key,用于获取上传资源token.然后安装requirements.txt里面想的相关依赖,运行MainServer.py里面的入口函数.

前台:

将/Commons/Const/MTTServerAPIConst.swift文件中的kServerHost和kQiNiuServer改成你自己的server地址,例如:

```

let kServerHost:String = "[http://192.168.10.63:8000/](http://192.168.10.63:8000/)

let kQiNiuServer = "http://xx.xxxx.xx/"

```

### 博客地址&相关文章

**博客地址:** https://waitwalker.cn/
