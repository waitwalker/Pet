//
//  MTTCircleViewController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/13.
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
 萌圈类
 
 2. 注意事项:
 
 3. 其他说明:
 逻辑:判断有没有登录过->没有登录->登录->保存用户信息->调用登录接口->调用获取列表接口
 
 
 *****************************/




import UIKit
import MJRefresh



// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTCircleViewController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var VMCircleViewModel:MTTCircleViewModel!
    var VCircleTableView:UITableView!
    let reusedCircleId:String = "reusedCircleId"
    var ODataSource:[MTTCircleModel] = []
    var VPlaceView:MTTPlaceView!
    var OOriginalInfo:[String:Any]!
    var pageNum:Int = 1
    var isHaveMoreData:Int = 1
    var leftButton:UIButton!
    var MCurrentModel:MTTCircleModel!

    
    // 举报视图
    var VReportView:MTTReportView!
    var OBlockUidsArray:[String] = []
    var VCircleBoardView:MTTCircleBoardView!

    
    
    required init(info: [String : Any]?) {
        super.init(info: info)
        pSetupBlockUserUid()
        pSetupViewModel(info: info!)
    }
    
    // MARK: - 初始化viewModel
    func pSetupViewModel(info:[String:Any]) -> Void {
        if VMCircleViewModel != nil {
            VMCircleViewModel = nil
        }
        VMCircleViewModel = MTTCircleViewModel(info: info)
        VMCircleViewModel.DDelegate = self
        self.OOriginalInfo = info
    }
    
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - instance method 实例方法
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        setupNavigationBar()
        
        if MTTUserInfoManager.sharedUserInfo.shouldRefreshCircleList {
            if self.ODataSource.count > 0 {
                self.ODataSource.removeAll()
            }
            
            if VCircleTableView != nil {
                VCircleTableView.reloadData()
            }
            
            self.pSetupHUD(title: "加载中...")
            let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                          "pageNum":1,
                                          "pageItems":10
            ]
            self.VMCircleViewModel.getDynamicList(info: parameter)
            self.leftButton.isHidden = true
        }
    }
    
    // MARK: - 设置导航
    private func setupNavigationBar() -> Void {
        let writeButton = UIButton()
        writeButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        writeButton.setImage(UIImage.image(imageString: "write_placeholder"), for: UIControl.State.normal)
        writeButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        writeButton.addTargetTo(self, action: #selector(writeButtonAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: writeButton)
        self.navigationItem.title = "心情"
        
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin == false {
            leftButton = UIButton()
            leftButton.addTarget(self, action: #selector(leftButtonAction), for: UIControl.Event.touchUpInside)
            leftButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
            leftButton.setImage(UIImage(named: "login"), for: UIControl.State.normal)
            leftButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            
            let fixedButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
            fixedButton.width = -12.0
            navigationItem.leftBarButtonItems = [fixedButton, UIBarButtonItem(customView: leftButton)]
        } else {
            if leftButton == nil {
                leftButton = UIButton()
                leftButton.addTarget(self, action: #selector(leftButtonAction), for: UIControl.Event.touchUpInside)
                leftButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
                leftButton.setImage(UIImage(named: "login"), for: UIControl.State.normal)
                leftButton.imageEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
                
                let fixedButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
                fixedButton.width = -12.0
                navigationItem.leftBarButtonItems = [fixedButton, UIBarButtonItem(customView: leftButton)]
                leftButton.isHidden = true
            } else {
                leftButton.isHidden = true
            }
        }
    }
    
    // 左边登录按钮回调
    @objc func leftButtonAction() -> Void {
        let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
        let nav = UINavigationController(rootViewController: loginVC)
        self.present(nav, animated: true) {
            
        }
        
        // 登录成功回调
        loginVC.BCompletion = { isLoginSuccess,info  in
            if isLoginSuccess {
                self.pSetupHUD(title: "加载中...")
                self.pSetupViewModel(info: info!)
                self.leftButton.isHidden = true
            }
        }
    }
    
    @objc func writeButtonAction() -> Void {
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin == false {
            let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
            let nav = UINavigationController(rootViewController: loginVC)
            self.present(nav, animated: true) {
            }
            
            // 登录成功回调
            loginVC.BCompletion = { isLoginSuccess,info  in
                if isLoginSuccess {
                    self.pSetupViewModel(info: info!)
                    self.leftButton.isHidden = true
                }
            }
        } else {
            let isAgreed = UserDefaults.standard.object(forKey: MTTUserInfoManager.sharedUserInfo.uid)
            if isAgreed != nil {
                let agree:Bool = isAgreed as! Bool
                if agree {
                    // 重新弹出发布页面
                    let publishVC = MTTPublishDynamicViewController(info: nil)
                    publishVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(publishVC, animated: true)
                    // 刷新回调
                    publishVC.completion = { success in
                        if success {
                            self.refrshAction()
                        }
                    }
                } else {
                    p_handleReportAlert()
                }
            } else {
                p_handleReportAlert()
            }
        }
    }
    
    func p_handleReportAlert() -> Void {
        let message:String = "狗圈儿上不允许出现的内容:\n示例:1.冒用他人信息;\n2.违反当地法律法规等信息;\n3.对他人进行人身攻击等信息;\n4.广告,色情,政治言论等信息;\n5.违反用户协议中约定的用户行为(请在注册页面查看用户协议及隐私政策)信息;\n6.其他情况违规信息;\n7.针对以上的违规信息,我们有权进行必要的处理,请您知晓;\n8.违规举报联系邮箱:waitwalker@163.com;\n您是否遵循以上条款并严格要求自己:"
        
        let alertContollert = UIAlertController(title: "用户发布心情要求", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "在看看", style: UIAlertAction.Style.cancel) { (action) in
        }
        
        let confirmAction = UIAlertAction(title: "遵循", style: UIAlertAction.Style.default) { (action) in
            
            UserDefaults.standard.set(true, forKey: MTTUserInfoManager.sharedUserInfo.uid)
            // 重新弹出发布页面
            let publishVC = MTTPublishDynamicViewController(info: nil)
            publishVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(publishVC, animated: true)
            
            // 刷新回调
            publishVC.completion = { success in
                if success {
                    self.refrshAction()
                }
            }
        }
        
        alertContollert.addAction(cancelAction)
        alertContollert.addAction(confirmAction)
        self.present(alertContollert, animated: true) {
        }
    }
    
    // MARK: - 设置刷新
    func setupRefresh() -> Void {
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(refrshAction))
        self.VCircleTableView.mj_header = header
        let footer = MJRefreshAutoFooter(refreshingTarget: self, refreshingAction: #selector(loadMoreAction))
        self.VCircleTableView.mj_footer = footer
    }
    
    @objc func refrshAction() -> Void {
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
            self.pSetupHUD(title: "加载中...")
            if ODataSource.count > 0 {
                ODataSource.removeAll()
            }
            self.VCircleTableView.reloadData()
            self.isHaveMoreData = 1
            self.pageNum = 1
            let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                          "pageNum":self.pageNum,
                                          "pageItems":10
            ]
            VMCircleViewModel.getDynamicList(info: parameter)
        } else {
            self.view.toast(message: "还没有登录,请先登录!")
            if self.VCircleTableView.mj_footer != nil && self.VCircleTableView.mj_header != nil {
                self.VCircleTableView.mj_footer.endRefreshing()
                self.VCircleTableView.mj_header.endRefreshing()
            }
        }
    }
    
    @objc func loadMoreAction() -> Void {
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
            if self.isHaveMoreData == 1 {
                self.pSetupHUD(title: "加载中...")
                self.pageNum += 1
                let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                              "pageNum":self.pageNum,
                                              "pageItems":10
                ]
                VMCircleViewModel.getDynamicList(info: parameter)
            } else {
                self.view.toast(message: "没有更多数据啦")
            }
        } else {
            self.view.toast(message: "还没有登录,请先登录!")
            if self.VCircleTableView.mj_footer != nil && self.VCircleTableView.mj_header != nil {
                self.VCircleTableView.mj_footer.endRefreshing()
                self.VCircleTableView.mj_header.endRefreshing()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        MTTTaskCenter.iDispatchTask(registerTo: self, taskType: MTTTaskCenterTaskType.luanchProgressTask, info: nil)
        pSetupSubviews()
        pLayoutSubviews()
        pSetupHUD(self.view)
        pSetupNotification()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func pSetupNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(handle(notification:)), name: NSNotification.Name.init("kLoginSuccess"), object: nil)
    }
    
    @objc func handle(notification:Notification) -> Void {
        let info = notification.object as! [String:Any]
        self.pSetupHUD(title: "加载中...")
        self.pSetupViewModel(info: info)
        self.leftButton.isHidden = true
    }
    
    // MARK: - 初始化控件
    private func pSetupSubviews() -> Void {
        VCircleTableView = UITableView()
        VCircleTableView.delegate = self
        VCircleTableView.dataSource = self
        VCircleTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        VCircleTableView.register(MTTCircleCell.self, forCellReuseIdentifier: reusedCircleId)
        self.view.addSubview(VCircleTableView)
    }
    
    private func pLayoutSubviews() -> Void {
        VCircleTableView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 设置加载失败站位图
    func pSetupPlaceView() -> Void {
        
        if VPlaceView != nil {
            VPlaceView.removeFromSuperview()
            VPlaceView = nil
        }
        
        VPlaceView = MTTPlaceView(frame: self.view.bounds)
        VPlaceView.DDelegate = self
        self.view.addSubview(VPlaceView)
        
    }
    
    // MARK: - class method  类方法
    
    // MARK: - private method 私有方法
    
}

// MARK: - circle viewModel delegate 回调
@available(iOS 11.0, *)
extension MTTCircleViewController: MTTCircleViewModelDelegate
{
    func dPraiseSuccessCallBack(info: [String : Any]) {
        
    }
    
    func dPraiseFailureCallBack(info: [String : Any]) {
        
    }
    
    
    func dReportAbuseErrorCallBack(info: [String : Any]?) {
        if VReportView != nil {
            VReportView.removeFromSuperview()
            VReportView = nil
        }
        let msg = info!["msg"] as! String
        self.view.toast(message: msg)
    }
    
    func dReportAbuseSuccessCallBack(info: [String : Any]?) {
        let currentIndex:Int = info!["currentIndex"] as! Int
        let msg:String = info!["msg"] as! String
        if currentIndex < self.ODataSource.count {
            self.ODataSource.remove(at: currentIndex)
        }
        VCircleTableView.reloadData()
        if VReportView != nil {
            VReportView.removeFromSuperview()
            VReportView = nil
        }
        self.view.toast(message: msg)
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
    
    func dDeviceDynamicListFailureCallBack(_ error: MTTError) {
        
        MTTUserInfoManager.sharedUserInfo.shouldRefreshCircleList = false
        // 设置占位
        pRemoveHUD()
        self.pSetupPlaceView()
        if self.VCircleTableView.mj_header != nil {
            self.VCircleTableView.mj_footer.endRefreshing()
            self.VCircleTableView.mj_header.endRefreshing()
            self.view.toast(message: "获取动态列表失败")
        }
    }
    
    func dLoginSuccessCallBack(info: [String : Any]?) {
        
        MTTUserInfoManager.sharedUserInfo.shouldRefreshCircleList = false
        if VPlaceView != nil {
            VPlaceView.removeFromSuperview()
            VPlaceView = nil
        }
        if ODataSource.count > 0 {
            ODataSource.removeAll()
        }
        
        self.pSetupHUD(title: "加载中...")
        self.setupRefresh()
        let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                      "pageNum":self.pageNum,
                                      "pageItems":10
        ]
        VMCircleViewModel.getDynamicList(info: parameter)
    }
    
    func dLoginFailureCallBack(info: [String : Any]?) {
        // 设置占位
        pRemoveHUD()
        self.pSetupPlaceView()
    }
    
    func dDeviceDynamicListSuccessCallBack(_ dataSource: [MTTCircleModel]) {
        if ODataSource.count > 0 {
            ODataSource.removeAll()
        }
        
        ODataSource = dataSource.map{
            return $0
        }
        pRemoveHUD()
        VCircleTableView.reloadData()
    }
    
    func dDynamicListFailureCallBack(_ error: MTTError) {
        // 设置占位
        pRemoveHUD()
        self.pSetupPlaceView()
    }
    
    // MARK: - 设置举报视图
    func pSetupReportView(model:MTTCircleModel) -> Void {
        if VReportView != nil {
            VReportView.removeFromSuperview()
            VReportView = nil
        }
        
        VReportView = MTTReportView(frame: CGRect.zero)
        VReportView.model = model
        VReportView.DDelegate = self
        self.view.addSubview(VReportView)
        
        VReportView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.height.equalTo(380)
            make.centerY.equalTo(self.view)
        }
    }
}

@available(iOS 11.0, *)
extension MTTCircleViewController: MTTReportViewDelegate
{
    func dTappedReportButton(model: MTTCircleModel, info: [String : Any]) {
        VMCircleViewModel.reportAbuse(model: model, info:info)
    }
    
    func dTappedCancelButton() {
        if VReportView != nil {
            VReportView.removeFromSuperview()
            VReportView = nil
        }
    }
}

// MARK: - 加载失败占位
@available(iOS 11.0, *)
extension MTTCircleViewController: MTTPlaceViewDelegate
{
    func dTapPlaceImageViewCallBack(_ placeView: MTTPlaceView) {
        DispatchQueue.main.async {
            placeView.removeFromSuperview()
            self.pSetupHUD()
        }
        pSetupViewModel(info: self.OOriginalInfo)
    }
}

@available(iOS 11.0, *)
extension MTTCircleViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ODataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCircleId) as? MTTCircleCell
        if cell == nil {
            cell = MTTCircleCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedCircleId)
        }
        if ODataSource.count > 0 {
            var currentModel = ODataSource[indexPath.item]
            currentModel.currentIndex = indexPath.item
            cell?.model = currentModel
        }
        cell?.DDelegate = self
        return cell!
    }
}

@available(iOS 11.0, *)
extension MTTCircleViewController: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if ODataSource.count > 0 {
            return ODataSource[indexPath.item].cellHeight
        }
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
            let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
            let nav = UINavigationController(rootViewController: loginVC)
            self.present(nav, animated: true) {
            }
            
            // 登录成功回调
            loginVC.BCompletion = { isLoginSuccess,info  in
                if isLoginSuccess {
                    self.pSetupViewModel(info: info!)
                    self.leftButton.isHidden = true
                }
            }
        } else {
            let commentDetailViewController = MTTCommentDetailRouter.matchCommentDetail(info: ["circleModel " : ODataSource[indexPath.item]])
            self.navigationController?.pushViewController(commentDetailViewController, animated: true)
        }
    }
}


// MARK: - ********** MTTLoginRegisterModuleController extension **********
@available(iOS 11.0, *)
extension MTTCircleViewController: MTTLaunchInterface
{
    func iLaunchProgressPage(info: [String : Any]?) {
        let progressVC = MTTLauchProgressController()
        self.pushViewController(progressVC)
    }
    
    // 忽略下面方法 swift 接口必须把所有方法都实现了
    func iLaunchiPhoneDeviceWelcomePage(info: [String : Any]?) {
    }
    
    func iLaunchiPadDeviceWelcomePage(info: [String : Any]?) {
    }
}

// MARK: - cell 上按钮点击回调
@available(iOS 11.0, *)
extension MTTCircleViewController: MTTCircleCellDelegate
{
    func dTappedFirstButton(button: UIButton, model: MTTCircleModel) {
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
            let commentDetailViewController = MTTCommentDetailRouter.matchCommentDetail(info: ["circleModel" : model])
            self.navigationController?.pushViewController(commentDetailViewController, animated: true)
        } else {
            let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
            let nav = UINavigationController(rootViewController: loginVC)
            self.present(nav, animated: true) {
            }
            
            // 登录成功回调
            loginVC.BCompletion = { isLoginSuccess,info  in
                if isLoginSuccess {
                    self.pSetupViewModel(info: info!)
                    self.leftButton.isHidden = true
                }
            }
        }
    }
    
    func dTappedSecondButton(button: UIButton, model: MTTCircleModel) {
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
            let currentIndex = model.currentIndex
            
            self.MCurrentModel = model
            self.MCurrentModel.isPraise = !self.MCurrentModel.isPraise
            var praiseNum:Int = 0
            if self.MCurrentModel.praiseNum.count > 0 {
                praiseNum = Int(self.MCurrentModel.praiseNum)!
            }
            
            if self.MCurrentModel.isPraise {
                praiseNum += 1
                self.MCurrentModel.praiseNum = String(praiseNum)
            } else {
                if self.MCurrentModel.praiseNum.count > 0 {
                    praiseNum = Int(self.MCurrentModel.praiseNum)! - 1
                    self.MCurrentModel.praiseNum = String(praiseNum)
                } else {
                    self.MCurrentModel.praiseNum = ""
                }
            }
            
            self.ODataSource[currentIndex] = self.MCurrentModel
            self.VCircleTableView.reloadRow(at: IndexPath(item: currentIndex, section: 0), with: UITableView.RowAnimation.none)
            VMCircleViewModel.getPraiseState(parameter: ["from_uid":MTTUserInfoManager.sharedUserInfo.uid,"topic_id":model.topic_id,"praise_state":self.MCurrentModel.isPraise,"time":String.getCurrentTimeStamp()])
            
        } else {
            let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
            let nav = UINavigationController(rootViewController: loginVC)
            self.present(nav, animated: true) {
            }
            
            // 登录成功回调
            loginVC.BCompletion = { isLoginSuccess,info  in
                if isLoginSuccess {
                    self.pSetupViewModel(info: info!)
                    self.leftButton.isHidden = true
                }
            }
        }
    }
    
    func dTappedThirdButton(button: UIButton, model: MTTCircleModel) {
        self.MCurrentModel = model
        if VCircleBoardView == nil {
            VCircleBoardView = MTTCircleBoardView(frame: UIScreen.main.bounds)
            UIApplication.shared.keyWindow?.addSubview(VCircleBoardView)
        }
        VCircleBoardView.DDelegate = self
        VCircleBoardView.isHidden = false
    }
    
    func dTappedImage(currentIndex: Int, model: MTTCircleModel) {
        if !MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
            let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
            let nav = UINavigationController(rootViewController: loginVC)
            self.present(nav, animated: true) {
            }
            
            // 登录成功回调
            loginVC.BCompletion = { isLoginSuccess,info  in
                if isLoginSuccess {
                    self.pSetupViewModel(info: info!)
                }
            }
        } else {
            self.tabBarController?.tabBar.isHidden = true
            let info:[String:Any] = ["imageURLStrings":model.attach, "currentIndex": currentIndex, "type":1]
            let photoBrowser = MTTPhotoBrowser(info: info)
            self.navigationController?.present(photoBrowser, animated: false, completion: {
            })
            photoBrowser.completion = { show in
                if show {
                    self.tabBarController?.tabBar.isHidden = false
                }
            }
        }
    }
    
    // MARK: - 分享事件回调
    func shareAction() -> Void {
        let textToShare = "狗圈儿是一个宠物社交软件,目的是广纳狗友,深入交流,分享快乐."
        let imageToShare = UIImage.image(imageString: "icon_placeholder")
        let appID = String(1395622129)
        let appString = String(format: "https://itunes.apple.com/app/id%@?mt=8", appID )
        let urlToShare = NSURL(string: appString)
        let items = [textToShare,imageToShare,urlToShare as Any] as [Any]
        let activityVC = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil)
        activityVC.completionWithItemsHandler =  { activity, success, items, error in
            
            if success {
                self.view.toast(message: "分享成功")
            } else {
                self.view.toast(message: "分享失败")
            }
        }
        
        if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone {
            self.present(activityVC, animated: true, completion: nil)
        }
    }
}

// MARK: - 面板点击事件回调
extension MTTCircleViewController:MTTCircleBoardViewDelegate {

    func shareToPlatform(platformType:UMSocialPlatformType) -> Void {
        let messageObject = UMSocialMessageObject()
        let thumbImage = UIImage.image(imageString: "icon_placeholder")

        let shareObject = UMShareWebpageObject.shareObject(withTitle: "狗圈儿", descr: "狗圈儿是一个宠物社交软件,目的是广纳狗友,深入交流,分享快乐.", thumImage: thumbImage)
        let appID = String(1395622129)
        let appString = String(format: "https://itunes.apple.com/app/id%@?mt=8", appID )
        shareObject?.webpageUrl = appString
        messageObject.shareObject = shareObject
        UMSocialManager.default().share(to: platformType, messageObject: messageObject, currentViewController: self) { (response, error) in
            if error != nil {
                self.view.toast(message: "分享失败,稍后重试")
            } else {
                //MTTPrint("response:\(response)")
            }
        }
    }

    func pSetupBlockAction(model:MTTCircleModel) -> Void {
        MTTRealm.sharedRealm.beginWrite()
        let blockInfo = MTTBlockAbuseUserTable()
        blockInfo.id = UUID().uuidString
        blockInfo.uid = MTTUserInfoManager.sharedUserInfo.uid
        MTTRealm.sharedRealm.add(blockInfo)
        try! MTTRealm.sharedRealm.commitWrite()
        MTTUserInfoManager.sharedUserInfo.blockUserUidArray.insert(model.uid)

        if self.VPlaceView != nil {
            self.VPlaceView.removeFromSuperview()
            self.VPlaceView = nil
        }
        if self.ODataSource.count > 0 {
            self.ODataSource.removeAll()
        }

        self.pSetupHUD(title: "加载中...")
        self.setupRefresh()
        let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                      "pageNum":1,
                                      "pageItems":10
        ]
        self.VMCircleViewModel.getDynamicList(info: parameter)
        self.leftButton.isHidden = true
    }

    func dTappedCloseButton(button: UIButton, boardView: MTTCircleBoardView) {
        if boardView.isHidden == false {
            boardView.isHidden = true
        }
    }

    func dTappedCurrentItem(currentIndex: Int, currentItemDataSource: [String : Any]) {

        if self.VCircleBoardView != nil {
            self.VCircleBoardView.isHidden = true
        }
        var platformType:UMSocialPlatformType!
        switch currentIndex {
        case 0:
            
            platformType = UMSocialPlatformType.wechatSession
            if !WXApi.isWXAppInstalled() {
                self.shareAction()
            } else {
                self.shareToPlatform(platformType: platformType)
            }

            break
        case 1:
            platformType = UMSocialPlatformType.wechatTimeLine
            if !WXApi.isWXAppInstalled() {
                self.shareAction()
            } else {
                self.shareToPlatform(platformType: platformType)
            }
            break
        case 2:
            platformType = UMSocialPlatformType.sina
            self.shareToPlatform(platformType: platformType)
            break
        case 3:
            platformType = UMSocialPlatformType.QQ
            if !QQApiInterface.isQQInstalled() {
                self.shareAction()
            } else {
                self.shareToPlatform(platformType: platformType)
            }
            break
        case 4:
            if !MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
                let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
                let nav = UINavigationController(rootViewController: loginVC)
                self.present(nav, animated: true) {
                }

                // 登录成功回调
                loginVC.BCompletion = { isLoginSuccess,info  in
                    if isLoginSuccess {
                        self.pSetupViewModel(info: info!)
                        self.leftButton.isHidden = true
                    }
                }
            } else {
                self.pSetupReportView(model: self.MCurrentModel)
            }

            break
        case 5:
            if !MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
                let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
                let nav = UINavigationController(rootViewController: loginVC)
                self.present(nav, animated: true) {
                }

                // 登录成功回调
                loginVC.BCompletion = { isLoginSuccess,info  in
                    if isLoginSuccess {
                        self.pSetupViewModel(info: info!)
                        self.leftButton.isHidden = true
                    }
                }
            } else {
                self.pSetupBlockAction(model: self.MCurrentModel)
            }

            break
        default:
            break
        }
    }
}
