//
//  MTTPersonalViewController.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/7/19.
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
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/

import UIKit
import Foundation
import MessageUI
import StoreKit
import RxCocoa
import RxSwift
import Kingfisher

class MTTPetViewController: MTTViewController {
    
    var VMViewModel:MTTPersonalViewModel!
    var VTableView:UITableView!
    let reusedCellId = "reusedCellId"
    var dataSources:[MTTAboutCellModel] = []
    var VBackgroundView:UIView!
    
    var aboutContainerView:UIView!
    var iconImageView:UIImageView!
    var versionLabel:UILabel!
    var aboutLabel:UILabel!
    var VPushView:MTTPushView!
    
    
    
    required init(info: [String : Any]?) {
        super.init(info: info)
        VMViewModel = MTTPersonalViewModel()
        VMViewModel.DDelegate = self
    }
    
    let originalData:[[String:Any]] = [["title":"个人中心","imageString":"personal_placeholder"],["title":"我要举报","imageString":"report"],["title":"我要评价","imageString":"comment"],["title":"我要分享","imageString":"share"]]
    
    let originalData_push:[[String:Any]] = [["title":"个人中心","imageString":"personal_placeholder"],["title":"我要举报","imageString":"report"],["title":"我要评价","imageString":"comment"],["title":"我要分享","imageString":"share"],["title":"我要推送","imageString":"push_notification"]]
    
    private func loadAboutData() -> Void {
        let tpmDataSource = (MTTUserInfoManager.sharedUserInfo.uid == "1538190814065" && MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin) ? originalData_push : originalData
        if dataSources.count > 0 {
            dataSources.removeAll()
        }
        for (_,dict) in tpmDataSource.enumerated() {
            var model = MTTAboutCellModel()
            model.title = dict["title"] as! String
            model.imageString = dict["imageString"] as! String
            dataSources.append(model)
        }
        
        if VTableView != nil {
            VTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
        pLayoutSubviews()
        pSetupNotification()
    }
    
    func pSetupNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(handleLogoutAction), name: NSNotification.Name.init(kLogoutSuccess), object: nil)
    }
    
    @objc func handleLogoutAction() -> Void {
        self.loadAboutData()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func pSetupSubviews() -> Void {
        let waterWaveView = MTTWaterWaveView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight * 0.33))
        waterWaveView.dDelegate = self
        self.view.addSubview(waterWaveView)
        
        VTableView = UITableView()
        VTableView.frame = CGRect(x: 0, y: waterWaveView.frame.maxY + 100, width: kScreenWidth, height: kScreenHeight - (waterWaveView.frame.maxY + 60))
        VTableView.delegate = self
        VTableView.dataSource = self
        VTableView.backgroundColor = UIColor.white
        VTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        VTableView.register(MTTAboutCell.self, forCellReuseIdentifier: reusedCellId)
        self.view.addSubview(VTableView)
        
        VBackgroundView = UIView()
        VBackgroundView.isHidden = true
        VBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(VBackgroundView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        VBackgroundView.addGestureRecognizer(tapGes)
        
        aboutContainerView = UIView()
        aboutContainerView.backgroundColor = UIColor.white
        aboutContainerView.layer.cornerRadius = 20
        aboutContainerView.clipsToBounds = true
        VBackgroundView.addSubview(aboutContainerView)
        
        iconImageView = UIImageView()
        iconImageView.image = UIImage.image(imageString: "icon_placeholder")
        iconImageView.layer.cornerRadius = 5.0
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 0.3
        iconImageView.layer.borderColor = kMainBlueColor().cgColor
        aboutContainerView.addSubview(iconImageView)
        
        let infoDict = Bundle.main.infoDictionary
        let appVersion = infoDict!["CFBundleShortVersionString"]
        versionLabel = UILabel()
        versionLabel.text = String(format: "狗圈儿 V %@", appVersion as! CVarArg)
        versionLabel.font = UIFont.systemFont(ofSize: 16)
        versionLabel.textColor = kLightBlueColor()
        versionLabel.textAlignment = NSTextAlignment.center
        aboutContainerView.addSubview(versionLabel)
        
        aboutLabel = UILabel()
        aboutLabel.textAlignment = NSTextAlignment.center
        aboutLabel.text = "狗圈儿是一个宠物社交软件,目的是广纳狗友,深入交流,分享快乐."
        aboutLabel.font = UIFont.boldSystemFont(ofSize: 17)
        aboutLabel.numberOfLines = 0
        aboutLabel.textColor = kLightBlueColor()
        aboutContainerView.addSubview(aboutLabel)
    }
    
    func pLayoutSubviews() -> Void {
        
        VBackgroundView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self.view)
            make.bottom.equalTo(100)
        }
        
        aboutContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.centerY.equalTo(self.view)
            make.height.equalTo(350)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(aboutContainerView).offset(40)
            make.height.width.equalTo(136)
            make.centerX.equalTo(aboutContainerView)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(20)
            make.width.equalTo(180)
            make.height.equalTo(30)
            make.centerX.equalTo(aboutContainerView)
        }
        
        aboutLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(-30)
        }
    }
    
    @objc func tapGestureAction() -> Void {
        if VBackgroundView != nil {
            VBackgroundView.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        loadAboutData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
    
    // MARK: - 评价事件回调
    func commentAction() -> Void {
        let storeVC = SKStoreProductViewController()
        storeVC.delegate = self
        let appID = String(1395622129)
        let parameter:[String:Any] = [SKStoreProductParameterITunesItemIdentifier:appID]
        
        storeVC.loadProduct(withParameters: parameter) { (result, error) in
            if error != nil
            {
                let appString = String(format: "https://itunes.apple.com/app/id%@?mt=8", appID )
                let appURL = URL(string: appString)
                if UIApplication.shared.canOpenURL(appURL!) {
                    UIApplication.shared.open(appURL!, options: [:], completionHandler: { (result) in
                    })
                } else {
                    self.view.toast(message: "遇到错误,请重试")
                }
            } else {
                self.present(storeVC, animated: true, completion: {
                })
            }
        }
    }
    
    // MARK: - 举报事件回调
    func reportTapGesAction() -> Void {
        UINavigationBar.appearance().tintColor = UIColor.white
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = self.configuredMailComposeViewController_report()
            mailComposeViewController.navigationBar.tintColor = UIColor.white
            
            self.present(mailComposeViewController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "提示", message: "您还没设置邮箱信息,先去设置,或者通过系统邮件举报", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "暂不举报", style: UIAlertAction.Style.cancel, handler: { action in
            })
            
            let other = UIAlertAction(title: "系统邮件举报", style: UIAlertAction.Style.default, handler: { (otherAction) in
                if UIApplication.shared.canOpenURL(URL(string: "mailto://waitwalker@163.com")!)
                {
                    UIApplication.shared.open(URL(string: "mailto://waitwalker@163.com")!, options: [UIApplication.OpenExternalURLOptionsKey(rawValue: "String") : "Any"], completionHandler: { (completed) in
                        
                    })
                }
            })
            
            alertController.addAction(other)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: {
            })
        }
    }
    
    // MARK: - 反馈事件回调
    func feedbackTapGesAction() -> Void {
        UINavigationBar.appearance().tintColor = UIColor.white
        if MFMailComposeViewController.canSendMail() {
            let mailComposeViewController = self.configuredMailComposeViewController()
            mailComposeViewController.navigationBar.tintColor = UIColor.white
            self.present(mailComposeViewController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "提示", message: "您还没设置邮箱信息,先去设置,或者通过系统邮件反馈", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "暂不反馈", style: UIAlertAction.Style.cancel, handler: { action in
            })
            
            let other = UIAlertAction(title: "系统邮件反馈", style: UIAlertAction.Style.default, handler: { (otherAction) in
                if UIApplication.shared.canOpenURL(URL(string: "mailto://waitwalker@163.com")!) {
                    UIApplication.shared.open(URL(string: "mailto://waitwalker@163.com")!, options: [UIApplication.OpenExternalURLOptionsKey(rawValue: "String") : "Any"], completionHandler: { (completed) in
                    })
                }
            })
            
            alertController.addAction(other)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: {
            })
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["waitwalker@163.com"])
        mailComposeVC.setSubject("问题反馈")
        let model = UIDevice.current.model
        let modelName = UIDevice.current.modelName.rawValue
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        
        let deviceInfo = String(format: "\n\n\n\n\n\n\n您的设备信息:\n类型:%@\n型号:%@\n系统:%@\n版本:%@", model,modelName,systemName,systemVersion)
        mailComposeVC.setMessageBody(deviceInfo, isHTML: false)
        return mailComposeVC
    }
    
    func configuredMailComposeViewController_report() -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["waitwalker@163.com"])
        mailComposeVC.setSubject("违规")
        let model = UIDevice.current.model
        let modelName = UIDevice.current.modelName.rawValue
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        
        let deviceInfo = String(format: "请您认真填写要举报的信息,我们会及时处理:\n\n\n\n\n\n\n\n\n\n\n\n您的设备信息:\n类型:%@\n型号:%@\n系统:%@\n版本:%@", model,modelName,systemName,systemVersion)
        mailComposeVC.setMessageBody(deviceInfo, isHTML: false)
        return mailComposeVC
    }
}

extension MTTPetViewController: MTTWaterWaveViewDelegate {
    func dTappedImageViewCallBack() {
        if VBackgroundView != nil {
            VBackgroundView.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
        }
    }
}

extension MTTPetViewController:MTTPersonalViewModelDelegate {
    func dPersonalFailureCallBack(info: [String : Any]?) {
        
    }
    
    func dGetUploadFileTokenSuccessCallBack(info: [String : Any]?) {
        
    }
    
    func dUploadImageSuccessCallBack(info: [String : Any]?) {
        
    }
    
    func dPersonalSuccessCallBack(info: [String : Any]?) {
        
    }
    
    func dChangeUsernameFailureCallBack(info: [String : Any]?) {
        
    }
    
    func dChangeUsernameSuccessCallBack(info: [String : Any]?) {
        
    }
    
    func dPushRequestSuccessCallBack(info: [String : Any]) {
        self.view.toast(message: "推送成功!")
    }
    
    func dPushRequestFailureCallBack(info: [String : Any]) {
        self.view.toast(message: "推送已发出")
    }
    
    
}


// MARK: - 跳转到app store 回调
@available(iOS 11.0, *)
extension MTTPetViewController:SKStoreProductViewControllerDelegate
{
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true) {
        }
    }
}

// MARK: - petGroup 模糊控制器 delegate
@available(iOS 11.0, *)
extension MTTPetViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCellId) as? MTTAboutCell
        if cell == nil {
            cell = MTTAboutCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedCellId)
        }
        if dataSources.count > 0 {
            cell?.model = dataSources[indexPath.item]
        }
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中")
    }
}

// MARK: - petGroup 模糊控制器 下面cell被点击回调
@available(iOS 11.0, *)
extension MTTPetViewController: MTTAboutCellDelegate
{
    func dTapCurrentCell(with model: MTTAboutCellModel) {
        if model.title == "个人中心" {
            if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin == false {
                self.view.toast(message: "您还没有登录,请先去首页登录!")
                return
            }
            let blurVC = MTTBlurViewPersonalController(info: nil)
            self.present(blurVC, animated: false) {
            }
        } else if model.title == "我要举报" {
            p_handleReportAlert()
        } else if model.title == "我要写信" {
            self.feedbackTapGesAction()
        } else if model.title == "我要评价" {
            self.commentAction()
        } else if model.title == "我要分享"{
            self.shareAction()
        } else if model.title == "我要推送" {
            if MTTUserInfoManager.sharedUserInfo.uid == "1538190814065" && MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin {
                if VPushView == nil {
                    VPushView = MTTPushView(frame: CGRect.zero)
                    VPushView.DDelegate = self
                    VPushView.isHidden = false
                    self.view.addSubview(VPushView)
                    self.view.bringSubviewToFront(VPushView)
                    
                    VPushView.snp.makeConstraints { (make) in
                        make.left.equalTo(40)
                        make.right.equalTo(-40)
                        make.height.equalTo(380)
                        make.centerY.equalTo(self.view)
                    }
                } else {
                    VPushView.isHidden = false
                    self.view.bringSubviewToFront(VPushView)
                }
            } else {
                self.view.toast(message: "请先登录,然后再尝试!")
            }
        }
    }
    
    func p_handleReportAlert() -> Void {
        let message:String = "针对狗圈儿上任何违规情况请您进行违规举报:\n示例:1.冒用他人姓名等信息的;\n2.违反法律法规的;\n3.进行人身攻击等的;\n4.违反用户协议中约定的用户行为的;\n5.其他违规情况举报;\n6.违规举报联系邮箱:waitwalker@163.com"
        
        let alertContollert = UIAlertController(title: "违规内容举报", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "算了,在认真看看", style: UIAlertAction.Style.cancel) { (action) in
        }
        
        let confirmAction = UIAlertAction(title: "举报", style: UIAlertAction.Style.default) { (action) in
            self.reportTapGesAction()
        }
        
        alertContollert.addAction(cancelAction)
        alertContollert.addAction(confirmAction)
        self.present(alertContollert, animated: true) {
            
        }
    }
}

extension MTTPetViewController: MTTPushViewDelegate {
    func dTappedCancelButton() {
        pHandlePushView()
    }
    
    func dTappedPushButton(info: [String : Any]) {
        pHandlePushView()
        VMViewModel.pushRequest(info: info)
    }
    
    private func pHandlePushView() -> Void {
        if VPushView != nil {
            VPushView.isHidden = true
            VPushView.clearInstanceCache()
        }
    }
}

@available(iOS 11.0, *)
extension MTTPetViewController: MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("发送成功")
        case .cancelled:
            print("取消发送")
        default:
            print("取消发送")
            break
        }
        controller.dismiss(animated: true) {
            
        }
    }
}



// MARK: - 个人中心
@available(iOS 11.0, *)
class MTTPersonalViewController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var OInfo:[String:Any]?
    
    
    /// 构造函数
    ///
    /// - Parameter info: info
    required init(info:[String:Any]?) {
        super.init(info: info)
        self.OInfo = info
    }
    
    /// 析构函数
    deinit {
        print("welcome release")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var aboutTableView:UITableView!
    
    let reusedBedrockId:String = "reusedBedrockId"
    let reusedNormalId:String = "reusedNormalId"
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "狗圈儿"
        
        if aboutTableView != nil {
            aboutTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setupSubview()
        layoutSubview()
    }
    
    // MARK: - 初始化列表
    func setupSubview() {
        aboutTableView = UITableView()
        aboutTableView.delegate = self
        aboutTableView.dataSource = self
        aboutTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        aboutTableView.register(MTTPetGroupCardCell.self, forCellReuseIdentifier: reusedBedrockId)
        aboutTableView.register(MTTNormalCardCell.self, forCellReuseIdentifier: reusedNormalId)
        self.view.addSubview(aboutTableView)
    }
    
    func layoutSubview() {
        aboutTableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
        aboutTableView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

@available(iOS 11.0, *)
extension MTTPersonalViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.item {
        case 0:
            var heightValue:CGFloat = kScreenHeight - 150
            if UIScreen.main.bounds.size.height == 812
            {
                heightValue = kScreenHeight - 250
            }
            return heightValue
        default:
            
            var heightValue:CGFloat = kScreenHeight - 220
            if UIScreen.main.bounds.size.height == 812
            {
                heightValue = kScreenHeight - 320
            }
            return heightValue
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.item {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: reusedBedrockId) as? MTTPetGroupCardCell
            if cell == nil
            {
                cell = MTTPetGroupCardCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedBedrockId)
            }
            if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin == true {
                if MTTUserInfoManager.sharedUserInfo.headerImage != nil {
                    cell?.personalImageView.image = MTTUserInfoManager.sharedUserInfo.headerImage
                } else {

                    cell?.backImageView.kf.setImage(with: URL(string: kQiNiuServer + MTTUserInfoManager.sharedUserInfo.header_photo), placeholder: UIImage.image(imageString: "avatar_placeholder"), options: [.preloadAllAnimationData], progressBlock: { (rec, total) in

                    }, completionHandler: { (_) in

                    })
                }
            } else {
                cell?.personalImageView.image = UIImage.image(imageString: "avatar_placeholder")
            }
            let imageString = "https://source.unsplash.com/daily"
            
            let placeImage = UIImage.image(imageString: "placeholder_one")

            cell?.backImageView.kf.setImage(with: URL(string: imageString)!, placeholder: placeImage, options: [.preloadAllAnimationData], progressBlock: { (rec, total) in

            }, completionHandler: { (_) in

            })
            
            cell?.delegate = self
            return cell!
        case 1:
            var cell = tableView.dequeueReusableCell(withIdentifier: reusedNormalId) as? MTTNormalCardCell
            if cell == nil
            {
                cell = MTTNormalCardCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedNormalId)
            }
            let imageString = String("https://picsum.photos/900/1200/?random")
            let placeImage = UIImage.image(imageString: "placeholder_one")
            
            cell?.backImageView.kf.setImage(with: URL(string: imageString)!, placeholder: placeImage, options: [.preloadAllAnimationData], progressBlock: { (rec, total) in

            }, completionHandler: { (_) in

            })
            return cell!
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: reusedNormalId) as? MTTNormalCardCell
            if cell == nil
            {
                cell = MTTNormalCardCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedNormalId)
            }
            let imageString = String("https://img.xjh.me/random_img.php?type=bg&ctype=nature&return=302&device=mobile")
            let placeImage = UIImage.image(imageString: "placeholder_one")
            
            cell?.backImageView.kf.setImage(with: URL(string: imageString)!, placeholder: placeImage, options: [.preloadAllAnimationData], progressBlock: { (rec, total) in

            }, completionHandler: { (_) in

            })
            return cell!
        }
    }
}

// MARK: - 监听视图滚动
@available(iOS 11.0, *)
extension MTTPersonalViewController: UIScrollViewDelegate
{
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        MTTPrint("scrollView scroll offset:\(scrollView.contentOffset.y)")
//        
//        let subview = self.navigationController?.navigationBar.subviews[0]
//        if scrollView.contentOffset.y > 0.0 {
//            MTTPrint("scroll scale:\(scrollView.contentOffset.y/64.0)")
//            
//            let alpha = 1.0 - (scrollView.contentOffset.y / 64.0)
//            subview?.alpha = alpha
//            
//        } else
//        {
//            subview?.alpha = 1.0
//        }
//    }
}

// MARK: - 图标的点击delegate回调
@available(iOS 11.0, *)
extension MTTPersonalViewController: MTTIconImageViewDelegate
{
    func tappedIconImageView() {
        
        let blurVC = MTTBlurViewPetGroupController(info: nil)
        self.present(blurVC, animated: false) {
        }
    }
    
    func tappedPersonalIconImageView() {
        if MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin == false {
            
            self.view.toast(message: "您还没有登录,请先去首页登录!")
            
//            let loginVC = MTTMediator.shared().registerLoginModule(withParameter: nil) as! MTTLoginRegisterModuleController
//            let nav = UINavigationController(rootViewController: loginVC)
//            self.present(nav, animated: true) {
//
//            }
//
//            // 登录成功回调
//            loginVC.BCompletion = { isLoginSuccess,info  in
//                print("isLoginSuccess: \(isLoginSuccess)")
//
//                self.aboutTableView.reloadData()
//            }
            
        } else {
            
            let blurVC = MTTBlurViewPersonalController(info: nil)
            self.present(blurVC, animated: false) {
            }
        }
        
    }
}

// MARK: - 模糊控制器 基类
@available(iOS 11.0, *)
class MTTBlurViewController: MTTViewController {
    var blurImageView:UIImageView!
    var aboutContainerView:UIView!
    var iconImageView:UIImageView!
    var versionLabel:UILabel!
    var aboutLabel:UILabel!
    
    var VTableView:UITableView!
    let reusedCellId:String = "reusedCellId"
    
    var aboutTableView:UITableView!
    
    var dataSources:[MTTAboutCellModel] = []
    
    
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
    }
    
    func pSetupSubviews() -> Void
    {
        blurImageView = UIImageView()
        blurImageView.frame = UIScreen.main.bounds
        blurImageView.image = UIImage.image(imageString: "sense_placeholder")
        blurImageView.isUserInteractionEnabled = true
        self.view.addSubview(blurImageView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = blurImageView.bounds
        blurImageView.addSubview(visualEffectView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesAction))
        blurImageView.addGestureRecognizer(tapGes)
        
        aboutContainerView = UIView()
        aboutContainerView.backgroundColor = UIColor.white
        aboutContainerView.layer.cornerRadius = 20
        aboutContainerView.clipsToBounds = true
        blurImageView.addSubview(aboutContainerView)
        
        iconImageView = UIImageView()
        iconImageView.image = UIImage.image(imageString: "icon_placeholder")
        iconImageView.layer.cornerRadius = 5.0
        iconImageView.clipsToBounds = true
        iconImageView.layer.borderWidth = 0.3
        iconImageView.layer.borderColor = kMainBlueColor().cgColor
        aboutContainerView.addSubview(iconImageView)
        
        let infoDict = Bundle.main.infoDictionary
        let appVersion = infoDict!["CFBundleShortVersionString"]
        versionLabel = UILabel()
        versionLabel.text = String(format: "狗圈儿 V %@", appVersion as! CVarArg)
        versionLabel.font = UIFont.systemFont(ofSize: 16)
        versionLabel.textColor = kMainBlueColor()
        versionLabel.textAlignment = NSTextAlignment.center
        aboutContainerView.addSubview(versionLabel)
        
        aboutLabel = UILabel()
        aboutLabel.textAlignment = NSTextAlignment.center
        aboutLabel.text = "狗圈儿是一个宠物社交软件,目的是广纳狗友,深入交流,分享快乐."
        aboutLabel.font = UIFont.systemFont(ofSize: 16)
        aboutLabel.numberOfLines = 0
        aboutLabel.textColor = kG6
        aboutContainerView.addSubview(aboutLabel)
    }
    
    
    @objc func tapGesAction() -> Void
    {
        if blurImageView != nil
        {
            self.dismiss(animated: false, completion: {
                
                self.blurImageView.removeFromSuperview()
                self.blurImageView = nil
            })
        }
    }
    
}

// MARK: - 模糊控制器 显示简介 反馈等
@available(iOS 11.0, *)
class MTTBlurViewPetGroupController: MTTBlurViewController
{
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    let originalData:[[String:Any]] = [["title":"我要举报","imageString":"report"],["title":"我要写信","imageString":"feedback"],["title":"我要评价","imageString":"comment"],["title":"我要分享","imageString":"share"]]
    
    
    
    private func loadAboutData() -> Void
    {
        for (_,dict) in originalData.enumerated() {
            
            var model = MTTAboutCellModel()
            model.title = dict["title"] as! String
            model.imageString = dict["imageString"] as! String
            dataSources.append(model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadAboutData()
        
        pLayoutSubviews()
    }
    
    // MARK: - 初始化模糊图像上的控件
    
    override func pSetupSubviews() {
        super.pSetupSubviews()
        
        aboutLabel.sizeToFit()
        
        VTableView = UITableView()
        VTableView.delegate = self
        VTableView.dataSource = self
        VTableView.backgroundColor = UIColor.clear
        VTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        VTableView.register(MTTAboutCell.self, forCellReuseIdentifier: reusedCellId)
        blurImageView.addSubview(VTableView)
    }
    
    func pLayoutSubviews() {
        
        var heightValue:CGFloat = 290
        if UIScreen.main.bounds.size.height == 812
        {
            heightValue = 330
        }
        
        var yValue:CGFloat = 120
        if UIScreen.main.bounds.size.height == 812
        {
            yValue = 160
        }
        
        aboutContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(yValue)
            make.height.equalTo(heightValue)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.top.equalTo(aboutContainerView).offset(20)
            make.height.width.equalTo(136)
            make.centerX.equalTo(aboutContainerView)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(iconImageView.snp.bottom).offset(10)
            make.width.equalTo(180)
            make.height.equalTo(30)
            make.centerX.equalTo(aboutContainerView)
        }
        
        aboutLabel.snp.makeConstraints { make in
            make.top.equalTo(versionLabel.snp.bottom).offset(10)
            make.left.equalTo(20)
            make.right.equalTo(-20)
        }
        
        VTableView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutContainerView.snp.bottom).offset(30)
            make.left.right.equalTo(aboutContainerView)
            make.bottom.equalTo(blurImageView.snp.bottom).offset(-60)
        }
    }
    
    // MARK: - 分享事件回调
    func shareAction() -> Void
    {
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
    
    // MARK: - 评价事件回调
    func commentAction() -> Void
    {
        let storeVC = SKStoreProductViewController()
        storeVC.delegate = self
        let appID = String(1395622129)
        let parameter:[String:Any] = [SKStoreProductParameterITunesItemIdentifier:appID]
        
        storeVC.loadProduct(withParameters: parameter) { (result, error) in
            
            if error != nil
            {
                let appString = String(format: "https://itunes.apple.com/app/id%@?mt=8", appID )
                
                let appURL = URL(string: appString)
                
                if UIApplication.shared.canOpenURL(appURL!)
                {
                    UIApplication.shared.open(appURL!, options: [:], completionHandler: { (result) in
                        
                    })
                } else
                {
                    self.view.toast(message: "遇到错误,请重试")
                }
            } else {
                self.present(storeVC, animated: true, completion: {
                    
                })
            }
        }
    }
    
    // MARK: - 举报事件回调
    func reportTapGesAction() -> Void
    {
        UINavigationBar.appearance().tintColor = UIColor.white
        
        if MFMailComposeViewController.canSendMail()
        {
            let mailComposeViewController = self.configuredMailComposeViewController_report()
            mailComposeViewController.navigationBar.tintColor = UIColor.white
            
            self.present(mailComposeViewController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "提示", message: "您还没设置邮箱信息,先去设置,或者通过系统邮件举报", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "暂不举报", style: UIAlertAction.Style.cancel, handler: { action in
                
            })
            
            let other = UIAlertAction(title: "系统邮件举报", style: UIAlertAction.Style.default, handler: { (otherAction) in
                if UIApplication.shared.canOpenURL(URL(string: "mailto://waitwalker@163.com")!)
                {
                    UIApplication.shared.open(URL(string: "mailto://waitwalker@163.com")!, options: [UIApplication.OpenExternalURLOptionsKey(rawValue: "String") : "Any"], completionHandler: { (completed) in
                        
                    })
                }
            })
            
            alertController.addAction(other)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: {
            })
        }
    }
    
    // MARK: - 反馈事件回调
    func feedbackTapGesAction() -> Void
    {
        UINavigationBar.appearance().tintColor = UIColor.white
        
        if MFMailComposeViewController.canSendMail()
        {
            let mailComposeViewController = self.configuredMailComposeViewController()
            mailComposeViewController.navigationBar.tintColor = UIColor.white
            
            self.present(mailComposeViewController, animated: true) {
            }
        } else {
            let alertController = UIAlertController(title: "提示", message: "您还没设置邮箱信息,先去设置,或者通过系统邮件反馈", preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "暂不反馈", style: UIAlertAction.Style.cancel, handler: { action in
                
            })
            
            let other = UIAlertAction(title: "系统邮件反馈", style: UIAlertAction.Style.default, handler: { (otherAction) in
                if UIApplication.shared.canOpenURL(URL(string: "mailto://waitwalker@163.com")!)
                {
                    UIApplication.shared.open(URL(string: "mailto://waitwalker@163.com")!, options: [UIApplication.OpenExternalURLOptionsKey(rawValue: "String") : "Any"], completionHandler: { (completed) in
                        
                    })
                }
            })
            
            alertController.addAction(other)
            alertController.addAction(cancel)
            self.present(alertController, animated: true, completion: {
            })
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["waitwalker@163.com"])
        mailComposeVC.setSubject("问题反馈")
        let model = UIDevice.current.model
        let modelName = UIDevice.current.modelName.rawValue
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        
        let deviceInfo = String(format: "\n\n\n\n\n\n\n您的设备信息:\n类型:%@\n型号:%@\n系统:%@\n版本:%@", model,modelName,systemName,systemVersion)
        mailComposeVC.setMessageBody(deviceInfo, isHTML: false)
        return mailComposeVC
    }
    
    func configuredMailComposeViewController_report() -> MFMailComposeViewController {
        
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        
        //设置邮件地址、主题及正文
        mailComposeVC.setToRecipients(["waitwalker@163.com"])
        mailComposeVC.setSubject("违规")
        let model = UIDevice.current.model
        let modelName = UIDevice.current.modelName.rawValue
        let systemName = UIDevice.current.systemName
        let systemVersion = UIDevice.current.systemVersion
        
        let deviceInfo = String(format: "请您认真填写要举报的信息,我们会及时处理:\n\n\n\n\n\n\n\n\n\n\n\n您的设备信息:\n类型:%@\n型号:%@\n系统:%@\n版本:%@", model,modelName,systemName,systemVersion)
        mailComposeVC.setMessageBody(deviceInfo, isHTML: false)
        return mailComposeVC
    }
}

// MARK: - 跳转到app store 回调
@available(iOS 11.0, *)
extension MTTBlurViewPetGroupController:SKStoreProductViewControllerDelegate
{
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true) {
            
        }
    }
}

// MARK: - petGroup 模糊控制器 delegate
@available(iOS 11.0, *)
extension MTTBlurViewPetGroupController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCellId) as? MTTAboutCell
        if cell == nil {
            cell = MTTAboutCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedCellId)
        }
        
        if dataSources.count > 0 {
            cell?.model = dataSources[indexPath.item]
        }
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        print("选中")
    }
}

// MARK: - petGroup 模糊控制器 下面cell被点击回调
@available(iOS 11.0, *)
extension MTTBlurViewPetGroupController: MTTAboutCellDelegate
{
    func dTapCurrentCell(with model: MTTAboutCellModel) {
        if model.title == "我要举报" {
            p_handleReportAlert() 
        } else if model.title == "我要写信" {
            self.feedbackTapGesAction()
        } else if model.title == "我要评价" {
            self.commentAction()
        } else {
            self.shareAction()
        }
    }
    
    func p_handleReportAlert() -> Void {
        let message:String = "针对狗圈儿上任何违规情况请您进行违规举报:\n示例:1.冒用他人姓名等信息的;\n2.违反法律法规的;\n3.进行人身攻击等的;\n4.违反用户协议中约定的用户行为的;\n5.其他违规情况举报;\n6.违规举报联系邮箱:waitwalker@163.com"
        
        let alertContollert = UIAlertController(title: "违规内容举报", message: message, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "算了,在认真看看", style: UIAlertAction.Style.cancel) { (action) in
            
        }
        
        let confirmAction = UIAlertAction(title: "举报", style: UIAlertAction.Style.default) { (action) in
            self.reportTapGesAction()
        }
        
        alertContollert.addAction(cancelAction)
        alertContollert.addAction(confirmAction)
        self.present(alertContollert, animated: true) { 
            
        }
    }
}

// MARK: -  关于页面cell 点击 回调
@available(iOS 11.0, *)
protocol MTTAboutCellDelegate {
    func dTapCurrentCell(with model:MTTAboutCellModel) -> Void
}

// MARK: - 关于页面cell
@available(iOS 11.0, *)
class MTTAboutCell: UITableViewCell {
    
    var containerView:UIView!
    
    var iconImageView:UIImageView!
    var titleLabel:UILabel!
    var VLineView:UIView!
    var delegate:MTTAboutCellDelegate!
    var model:MTTAboutCellModel? {
        didSet{
            titleLabel.text = model?.title
            iconImageView.image = UIImage.image(imageString: (model?.imageString)!)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        pSetupSubviews()
    }
    
    private func pSetupSubviews() -> Void {
        containerView = UIView()
        containerView.layer.cornerRadius = 5
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor.white
        self.contentView.addSubview(containerView)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(containerTapAction))
        containerView.addGestureRecognizer(tap)
        
        iconImageView = UIImageView()
        iconImageView.isUserInteractionEnabled = true
        containerView.addSubview(iconImageView)
        
        titleLabel = UILabel()
        titleLabel.text = "我要写信"
        titleLabel.textColor = kLightBlueColor()
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = NSTextAlignment.left
        containerView.addSubview(titleLabel)
        
        VLineView = UIView()
        VLineView.backgroundColor = kMainBlueColor().withAlphaComponent(0.8)
        containerView.addSubview(VLineView)
    }
    
    @objc func containerTapAction() -> Void {
        self.delegate.dTapCurrentCell(with: self.model!)
    }
    
    private func pLayoutSubviews() -> Void {
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(16)
            make.left.right.bottom.equalTo(contentView)
        }
        
        iconImageView.snp.makeConstraints { (make) in
            make.left.equalTo(35)
            make.height.width.equalTo(24)
            make.top.equalTo(10)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(iconImageView.snp.right).offset(20)
            make.height.equalTo(47)
            make.top.equalTo(0)
            make.width.equalTo(200)
        }
        
        VLineView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.bottom.equalTo(0)
            make.height.equalTo(0.3)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - 关于页面cell model
@available(iOS 11.0, *)
struct MTTAboutCellModel {
    var title:String = ""
    var imageString:String = ""
    var index:Int = 0
    
}

@available(iOS 11.0, *)
extension MTTBlurViewPetGroupController: MFMailComposeViewControllerDelegate
{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case .sent:
            print("发送成功")
        case .cancelled:
            print("取消发送")
        default:
            print("取消发送")
            break
        }
        controller.dismiss(animated: true) {
            
        }
    }
}

// MARK: - 个人中心页面
@available(iOS 11.0, *)
class MTTBlurViewPersonalController: MTTBlurViewController {
    
    var VHeaderButton:UIButton!
    var VContainerView:UIView!
    var VCameraButton:UIButton!
    var VPhotoLibraryButton:UIButton!
    
    var OPickedImage:UIImage!
    var VMViewModel:MTTPersonalViewModel!
    var VLogoutButton:UIButton!
    var VUsernameContainerView:UIView!
    var VSecondConatinerView:UIView!
    var VNewUsernameTextField:UITextField!
    var VConfirmButton:UIButton!
    let disposeBag = DisposeBag()
    
    
    
    
    
    
    
    required init(info: [String : Any]?) {
        super.init(info: info)
        VMViewModel = MTTPersonalViewModel()
        VMViewModel.DDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let originalData:[[String:Any]] = [["title":MTTUserInfoManager.sharedUserInfo.phone,"imageString":"telephone"],["title":". . . . . .","imageString":"lock"],["title":MTTUserInfoManager.sharedUserInfo.username,"imageString":"username"]]
    
    
    private func loadAboutData() -> Void {
        if dataSources.count > 0 {
            dataSources.removeAll()
        }
        for (i, dict) in originalData.enumerated() {
            var model = MTTAboutCellModel()
            model.title = dict["title"] as! String
            model.imageString = dict["imageString"] as! String
            model.index = i
            dataSources.append(model)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadAboutData()
        pLayoutSubviews()
        setupEvents()
    }
    
    // MARK: - 初始化模糊图像上的控件
    override func pSetupSubviews() {
        super.pSetupSubviews()
        
        VHeaderButton = UIButton()
        VHeaderButton.layer.cornerRadius = 88.0
        VHeaderButton.clipsToBounds = true
        VHeaderButton.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VHeaderButton.layer.borderWidth = 0.5
        VHeaderButton.addTargetTo(self, action: #selector(headerImageTapAction), for: UIControl.Event.touchUpInside)
        aboutContainerView.addSubview(VHeaderButton)
        
        if MTTUserInfoManager.sharedUserInfo.header_photo.count < 1 {
            VHeaderButton.setBackgroundImage(UIImage.image(imageString: "avatar_placeholder"), for: UIControl.State.normal)
        } else {
            let imageString = MTTUserInfoManager.sharedUserInfo.isNormalLogin ? kQiNiuServer + MTTUserInfoManager.sharedUserInfo.header_photo : MTTUserInfoManager.sharedUserInfo.header_photo
            
            VHeaderButton.kf.setImage(with: URL(string: imageString), for: UIControl.State.normal, placeholder: UIImage.image(imageString: "avatar_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (total, receive) in
                
            }) { (image, error, type, url) in
                
            }
        }
        
        let randomNum = Int(arc4random_uniform(64))
        versionLabel.text = kTitles[randomNum]
        versionLabel.numberOfLines = 0
        
        if (versionLabel.text?.count)! >= 50 {
            versionLabel.font = UIFont.systemFont(ofSize: 13)
        }
        
        blurImageView.image = UIImage.image(imageString: "scene_personal")
        
        let headerImageGes = UITapGestureRecognizer(target: self, action: #selector(headerImageTapAction))
        iconImageView.addGestureRecognizer(headerImageGes)
        
        VTableView = UITableView()
        VTableView.delegate = self
        VTableView.dataSource = self
        VTableView.backgroundColor = UIColor.clear
        VTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        VTableView.register(MTTAboutCell.self, forCellReuseIdentifier: reusedCellId)
        blurImageView.addSubview(VTableView)
        
        VContainerView = UIView()
        VContainerView.isHidden = true
        VContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        self.view.addSubview(VContainerView)
        
        let containerGes = UITapGestureRecognizer(target: self, action: #selector(containerTapAction(gesture:)))
        VContainerView.addGestureRecognizer(containerGes)
        
        VCameraButton = UIButton()
        VCameraButton.backgroundColor = UIColor.white
        VCameraButton.setImage(UIImage.image(imageString: "personal_camera"), for: UIControl.State.normal)
        VCameraButton.layer.cornerRadius = 5
        VCameraButton.clipsToBounds = true
        VCameraButton.layer.borderWidth = 0.5
        VCameraButton.layer.borderColor = kMainBlueColor().cgColor
        VCameraButton.addTargetTo(self, action: #selector(cameraButtonAction(button:)), for: UIControl.Event.touchUpInside)
        VCameraButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        VContainerView.addSubview(VCameraButton)
        
        VPhotoLibraryButton = UIButton()
        VPhotoLibraryButton.backgroundColor = UIColor.white
        VPhotoLibraryButton.setImage(UIImage.image(imageString: "personal_photo_library"), for: UIControl.State.normal)
        VPhotoLibraryButton.layer.cornerRadius = 5
        VPhotoLibraryButton.clipsToBounds = true
        VPhotoLibraryButton.layer.borderWidth = 0.5
        VPhotoLibraryButton.layer.borderColor = kMainBlueColor().cgColor
        VPhotoLibraryButton.addTargetTo(self, action: #selector(photoLibraryButtonAction(button:)), for: UIControl.Event.touchUpInside)
        VPhotoLibraryButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        VContainerView.addSubview(VPhotoLibraryButton)
        
        VLogoutButton = UIButton()
        VLogoutButton.backgroundColor = UIColor.white
        VLogoutButton.setTitle("退出", for: UIControl.State.normal)
        VLogoutButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff"), for: UIControl.State.normal)
        VLogoutButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.5), for: UIControl.State.highlighted)
        VLogoutButton.layer.borderWidth = 0.5
        VLogoutButton.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VLogoutButton.layer.cornerRadius = 5.0
        VLogoutButton.clipsToBounds = true
        VLogoutButton.addTargetTo(self, action: #selector(logoutButtonAction(button:)), for: UIControl.Event.touchUpInside)
        blurImageView.addSubview(VLogoutButton)
        
        VUsernameContainerView = UIView()
        VUsernameContainerView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        VUsernameContainerView.isHidden = true
        self.view.addSubview(VUsernameContainerView)
        
        let usernameContainerGes = UITapGestureRecognizer(target: self, action: #selector(usernameContainerViewTapAction))
        VUsernameContainerView.addGestureRecognizer(usernameContainerGes)
        
        VSecondConatinerView = UIView()
        VSecondConatinerView.backgroundColor = UIColor.white
        VSecondConatinerView.layer.cornerRadius = 10.0
        VSecondConatinerView.clipsToBounds = true
        VUsernameContainerView.addSubview(VSecondConatinerView)
        
        VNewUsernameTextField = UITextField()
        VNewUsernameTextField.layer.cornerRadius = 5.0
        VNewUsernameTextField.clipsToBounds = true
        VNewUsernameTextField.backgroundColor = UIColor.white
        VNewUsernameTextField.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VNewUsernameTextField.layer.borderWidth = 0.5
        VNewUsernameTextField.textColor = UIColor.black.withAlphaComponent(0.8)
        VNewUsernameTextField.placeholder = "请输入新的用户名(16位以下)"
        VNewUsernameTextField.font = UIFont.systemFont(ofSize: 18)
        VNewUsernameTextField.textAlignment = NSTextAlignment.center
        VSecondConatinerView.addSubview(VNewUsernameTextField)
        
        VConfirmButton = UIButton()
        VConfirmButton.backgroundColor = UIColor.white
        VConfirmButton.setTitle("确认", for: UIControl.State.normal)
        VConfirmButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff"), for: UIControl.State.normal)
        VConfirmButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.5), for: UIControl.State.highlighted)
        VConfirmButton.layer.borderWidth = 0.5
        VConfirmButton.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VConfirmButton.layer.cornerRadius = 5.0
        VConfirmButton.clipsToBounds = true
        VConfirmButton.addTargetTo(self, action: #selector(confirmButtonAction), for: UIControl.Event.touchUpInside)
        VSecondConatinerView.addSubview(VConfirmButton)
        
    }
    
    @objc func containerTapAction(gesture:UITapGestureRecognizer) -> Void {
        VContainerView.isHidden = true
    }
    
    @objc func cameraButtonAction(button:UIButton) -> Void {
        if MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.Simulator_x86_64 {
            self.view.toast(message: "模拟器暂不支持打开相机")
            return
        }
        
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = UIImagePickerController.SourceType.camera
        self.present(imagePickerVC, animated: true, completion: {
            
        })
    }
    
    @objc func photoLibraryButtonAction(button:UIButton) -> Void {
        let imagePickerVC = UIImagePickerController()
        imagePickerVC.delegate = self
        imagePickerVC.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(imagePickerVC, animated: true, completion: {
            
        })
    }
    
    // 头像按钮点击回调
    @objc func headerImageTapAction() -> Void {
        self.VContainerView.isHidden = false
    }
    
    // MARK: - 退出按钮点击回调
    @objc func logoutButtonAction(button:UIButton) -> Void {
        MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin = false
        MTTUserInfoManager.sharedUserInfo.isNormalLogin = true
        let result = MTTRealm.queryObjects(type: MTTLoginInfoTable.self)
        
        // 已经插入数据了
        if (result?.count)! > Int(0) {
            let loginInfo = result?.first as! MTTLoginInfoTable
            try! MTTRealm.sharedRealm.write {
                loginInfo.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
                loginInfo.password = MTTUserInfoManager.sharedUserInfo.password
                loginInfo.phone = MTTUserInfoManager.sharedUserInfo.phone
                loginInfo.isNormalLogin = MTTUserInfoManager.sharedUserInfo.isNormalLogin
            }
            //try! MTTRealm.sharedRealm.commitWrite()
            
        } else {
            MTTRealm.sharedRealm.beginWrite()
            let infoTable = MTTLoginInfoTable()
            infoTable.isNeedAutoLogin = MTTUserInfoManager.sharedUserInfo.isNeedAutoLogin
            infoTable.deviceToken = ""
            infoTable.password = MTTUserInfoManager.sharedUserInfo.password
            infoTable.phone = MTTUserInfoManager.sharedUserInfo.phone
            infoTable.isNormalLogin = MTTUserInfoManager.sharedUserInfo.isNormalLogin
            MTTRealm.sharedRealm.add(infoTable)
            try! MTTRealm.sharedRealm.commitWrite()
        }
        MTTUserInfoManager.sharedUserInfo.header_photo = ""
        MTTUserInfoManager.sharedUserInfo.headerImage = nil
        self.dismiss(animated: false) {
        }
        
        NotificationCenter.default.post(name: NSNotification.Name.init(kLogoutSuccess), object: nil)
    }
    
    // 用户名按钮被点击回调
    @objc func usernameContainerViewTapAction() -> Void {
        self.VUsernameContainerView.isHidden = true
        self.view.endEditing(true)
    }
    
    // MARK: - 确认按钮点击回调
    @objc func confirmButtonAction() -> Void {
        // 1.调用修改用户名接口
        if (self.VNewUsernameTextField.text?.count)! < 1 {
            self.view.toast(message: "请输入用户名")
        } else {
            pSetupHUD()
            VMViewModel.changeUsername(info: ["username":(VNewUsernameTextField.text)!,"uid":MTTUserInfoManager.sharedUserInfo.uid,"password":MTTUserInfoManager.sharedUserInfo.password])
        }
    }
    
    // MARK: - 布局控件
    func pLayoutSubviews() {
        
        var heightValue:CGFloat = 290
        if UIScreen.main.bounds.size.height >= 812 {
            heightValue = 330
        }
        
        let yValue:CGFloat = 80 * (kScreenHeight / 667.0)
        
        aboutContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.top.equalTo(yValue)
            make.height.equalTo(heightValue)
        }
        
        VHeaderButton.snp.makeConstraints { make in
            make.top.equalTo(aboutContainerView).offset(20)
            make.height.width.equalTo(176)
            make.centerX.equalTo(aboutContainerView)
        }
        
        versionLabel.snp.makeConstraints { make in
            make.top.equalTo(VHeaderButton.snp.bottom).offset(20)
            make.width.equalTo(280)
            make.height.equalTo(60)
            make.centerX.equalTo(aboutContainerView)
        }
        
        VTableView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutContainerView.snp.bottom).offset(25)
            make.left.right.equalTo(aboutContainerView)
            make.bottom.equalTo(blurImageView.snp.bottom).offset(-60)
        }
        
        VContainerView.frame = self.view.bounds
        
        VCameraButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(64)
            make.centerY.equalTo(VContainerView)
            make.centerX.equalTo(VContainerView).offset(-50)
        }
        
        VPhotoLibraryButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(64)
            make.centerY.equalTo(VContainerView)
            make.centerX.equalTo(VContainerView).offset(50)
        }
        
        VLogoutButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(aboutContainerView)
            make.bottom.equalTo(-35)
            make.height.equalTo(44)
        }
        
        VUsernameContainerView.frame = self.view.bounds
        VSecondConatinerView.snp.makeConstraints { (make) in
            make.left.equalTo(40)
            make.right.equalTo(-40)
            make.centerY.equalTo(VUsernameContainerView).offset(-90)
            make.height.equalTo(210)
        }
        
        VNewUsernameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(30)
            make.height.equalTo(50)
        }
        
        VConfirmButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(VNewUsernameTextField)
            make.height.equalTo(44)
            make.top.equalTo(VNewUsernameTextField.snp.bottom).offset(50)
        }
    }
    
    // MARK: - 监听事件
    fileprivate func setupEvents() -> Void {
        VNewUsernameTextField.rx.text.subscribe(onNext: { (text) in
            if (text?.count)! > 16 {
                self.VNewUsernameTextField.textColor = UIColor.red
                self.VConfirmButton.setTitle("用户名长度超过限制", for: UIControl.State.normal)
                self.VConfirmButton.isEnabled = false
            } else {
                self.VNewUsernameTextField.textColor = UIColor.black.withAlphaComponent(0.8)
                self.VConfirmButton.setTitle("确认", for: UIControl.State.normal)
                self.VConfirmButton.isEnabled = true
            }
        }, onError: { (error) in
            MTTPrint("监听用户名输入框事件错误:\(error)")
        }, onCompleted: { 
            MTTPrint("监听用户名输入框事件完成")
        }).disposed(by: disposeBag)
    }
}

// MARK: - 模糊 个人中心页面 tableView delegate DataSource
@available(iOS 11.0, *)
extension MTTBlurViewPersonalController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSources.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCellId) as? MTTAboutCell
        
        if cell == nil {
            cell = MTTAboutCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedCellId)
        }
        
        if dataSources.count > 0 {
            cell?.model = dataSources[indexPath.item]
        }
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("选中")
    }
}

// MARK: - 模糊 个人中心页面 下面cell被点击回调
@available(iOS 11.0, *)
extension MTTBlurViewPersonalController: MTTAboutCellDelegate
{
    func dTapCurrentCell(with model: MTTAboutCellModel) {
        if model.index == 2 {
            self.VUsernameContainerView.isHidden = false
            self.VNewUsernameTextField.text = ""
        }
    }
}

@available(iOS 11.0, *)
extension MTTBlurViewPersonalController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage:UIImage = info[.originalImage] as! UIImage
        
        var compressQuality:Data
        compressQuality = originalImage.jpegData(compressionQuality: 0.5)!
        
        if compressQuality.count > 1500000 {
            compressQuality = originalImage.jpegData(compressionQuality: 0.3)!
        }
        
        let compressQualityImage = UIImage(data: compressQuality)
        let compressImage = UIImage.compressImage(originalImage: compressQualityImage!)
        self.OPickedImage = compressImage
        picker.dismiss(animated: true) {
            
        }
        pSetupHUD()
        VMViewModel.getUploadFileToken(info: ["phone":MTTUserInfoManager.sharedUserInfo.phone,"password":MTTUserInfoManager.sharedUserInfo.password])
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) {
            
        }
    }
}

@available(iOS 11.0, *)
extension MTTBlurViewPersonalController: MTTPersonalViewModelDelegate {
    
    func dPushRequestSuccessCallBack(info: [String : Any]) {
        self.view.toast(message: "推送成功")
    }
    
    func dPushRequestFailureCallBack(info: [String : Any]) {
        self.view.toast(message: "推送已发出")
    }
    
    func dChangeUsernameFailureCallBack(info: [String : Any]?) {
        self.view.toast(message: "修改用户名失败!")
        pRemoveHUD()
    }
    
    func dChangeUsernameSuccessCallBack(info: [String : Any]?) {
        pRemoveHUD()
        MTTUserInfoManager.sharedUserInfo.username = VNewUsernameTextField.text!
        dataSources[2].title = MTTUserInfoManager.sharedUserInfo.username
        VTableView.reloadData()
        VUsernameContainerView.isHidden = true
        self.view.endEditing(true)
        self.view.toast(message: "修改用户名成功!")
    }
    
    
    
    func dGetUploadFileTokenSuccessCallBack(info: [String : Any]?) {
        let token:String = info!["token"] as! String
        VMViewModel.uploadImage(image: self.OPickedImage, token: token, currentIndex: 0)
    }
    
    func dUploadImageSuccessCallBack(info: [String : Any]?) {
        let imageURL:String = info!["imageURL"] as! String
        VMViewModel.changeAvatar(info: ["attach":imageURL,"uid":MTTUserInfoManager.sharedUserInfo.uid])
        MTTUserInfoManager.sharedUserInfo.header_photo = imageURL
        MTTUserInfoManager.sharedUserInfo.headerImage = self.OPickedImage
    }
    
    func dPersonalFailureCallBack(info: [String : Any]?) {
        pRemoveHUD()
    }
    
    func dPersonalSuccessCallBack(info: [String : Any]?) {
        pRemoveHUD()
        self.view.toast(message: "更换头像成功")
        self.VContainerView.isHidden = true
        self.VHeaderButton.setImage(self.OPickedImage, for: UIControl.State.normal)
    }
    
    
    
}
