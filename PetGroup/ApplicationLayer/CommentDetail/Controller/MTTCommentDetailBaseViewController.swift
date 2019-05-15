//
//  MTTCommentDetailBaseViewController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/11/26.
//  Copyright © 2018 waitWalker. All rights reserved.
//

/*****
 评论详情控制器
 *****/

import UIKit

/**
 case onlyContent     = 0  //只有文本
 case contentAndImage = 1  //文本和图片
 case onlyImage       = 2  //只有图片
 case contentAndVideo = 3  //文本和视频
 case onlyVideo       = 4  //只有视频 
 */

class MTTCommentDetailBaseViewController: MTTViewController {
    
    fileprivate var VCommentListTableView:UITableView!
    fileprivate let OCommentReusedId:String = "OCommentReusedId"
    fileprivate let OCommentListReusedId:String = "OCommentListReusedId"
    fileprivate var MCicrleModel:MTTCircleModel!
    fileprivate var VCommentInputView:MTTCommentInputView!
    var VMCircleViewModel:MTTCircleViewModel!
    var VReportView:MTTReportView!
    var ODataSource:[MTTCommentModel] = []
    var VCommentMenuView:MTTCommentMenuView!
    
    fileprivate var toUid:String = ""
    

    required init(info: [String : Any]?) {
        super.init(info: info)
        pSetupSubviews()
        pLayoutSubviews()
        pSetupViewModel()

        if let inf = info {
            self.pSetupHUD(title: "加载中...")
            self.MCicrleModel = (inf["circleModel"] as! MTTCircleModel)
            MTTCommentViewModel.sharedViewModel.getCommentList(parameter: ["uid":MTTUserInfoManager.sharedUserInfo.uid,"topic_id":self.MCicrleModel.topic_id], delegate: self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        pSetupNavigationBar()
    }
    
    func pSetupViewModel() -> Void {
        if VMCircleViewModel != nil {
            VMCircleViewModel = nil
        }
        VMCircleViewModel = MTTCircleViewModel(info: nil)
        VMCircleViewModel.DDelegate = self
    }
    
    private func pSetupSubviews() -> Void {
        VCommentListTableView = UITableView()
        VCommentListTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        VCommentListTableView.register(MTTCommentTopCell.self, forCellReuseIdentifier: OCommentReusedId)
        VCommentListTableView.register(MTTCommentListCell.self, forCellReuseIdentifier: OCommentListReusedId)
        VCommentListTableView.delegate = self
        VCommentListTableView.dataSource = self
        self.view.addSubview(VCommentListTableView)
        
        VCommentInputView = MTTCommentInputView(frame: CGRect.zero)
        VCommentInputView.DDlegate = self
        VCommentInputView.isHidden = true
        UIApplication.shared.keyWindow!.addSubview(VCommentInputView)
    }
    
    private func pLayoutSubviews() -> Void {
        VCommentListTableView.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.bottom.equalTo(-10)
            make.left.right.equalTo(self.view)
        }
        
        VCommentInputView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
    }
    
    private func pSetupNavigationBar() -> Void {
        let rightButton = UIButton()
        rightButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        rightButton.setImage(UIImage.image(imageString: "comment_menu"), for: UIControl.State.normal)
        rightButton.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        rightButton.addTargetTo(self, action: #selector(rightButtonAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
        self.navigationItem.title = "评论"
    }
    
    @objc func rightButtonAction() -> Void {
        
        if VCommentMenuView == nil {
            VCommentMenuView = MTTCommentMenuView(frame: self.view.bounds)
            VCommentMenuView.isHidden = false
            self.view.addSubview(VCommentMenuView)
        } else {
            if VCommentMenuView.isHidden {
                VCommentMenuView.isHidden = false
            } else {
                VCommentMenuView.isHidden = true
            }
        }
        VCommentMenuView.DDelegate = self
    }
    
    // MARK: - 写评论回调
    func writeCommentAction() -> Void {
        self.VCommentInputView.isHidden = false
        self.VCommentInputView.VTextView.becomeFirstResponder()
        self.toUid = self.MCicrleModel.uid
    }
    
    // MARK: - 举报回调
    func tipAction() -> Void {
        if VReportView == nil {
            VReportView = MTTReportView(frame: CGRect.zero)
            VReportView.model = self.MCicrleModel
            VReportView.DDelegate = self
            VReportView.isHidden = false
            self.view.addSubview(VReportView)
            self.view.bringSubviewToFront(VReportView)
            
            VReportView.snp.makeConstraints { (make) in
                make.left.equalTo(40)
                make.right.equalTo(-40)
                make.height.equalTo(380)
                make.centerY.equalTo(self.view)
            }
        } else {
            VReportView.isHidden = false
            VReportView.VKeywordTextField.text = ""
            VReportView.VReportContentTextView.text = ""
            self.view.bringSubviewToFront(VReportView)
        }
    }
    
    // MARK: - 屏蔽回调
    func blockAction() -> Void {
        self.view.toast(message: "屏蔽用户成功!")
        MTTRealm.sharedRealm.beginWrite()
        let blockInfo = MTTBlockAbuseUserTable()
        blockInfo.id = UUID().uuidString
        blockInfo.uid = self.MCicrleModel.uid
        MTTRealm.sharedRealm.add(blockInfo)
        try! MTTRealm.sharedRealm.commitWrite()
        MTTUserInfoManager.sharedUserInfo.blockUserUidArray.insert(self.MCicrleModel.uid)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.0) { 
            DispatchQueue.main.async {
                MTTUserInfoManager.sharedUserInfo.shouldRefreshCircleList = true
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension MTTCommentDetailBaseViewController:MTTCommentMenuViewDelegate {
    func dTappedItem(menuView: MTTCommentMenuView, currentIndex: Int) {
        menuView.isHidden = true
        if currentIndex == 0 {
            self.writeCommentAction()
        } else if currentIndex == 1 {
            self.tipAction()
        } else if currentIndex == 2 {
            self.blockAction()
        }
    }
}

extension MTTCommentDetailBaseViewController:MTTReportViewDelegate {
    func dTappedReportButton(model: MTTCircleModel, info: [String : Any]) {
        VMCircleViewModel.reportAbuse(model: model, info:info)
    }
    
    func dTappedCancelButton() {
        if VReportView != nil {
            VReportView.isHidden = true
            VReportView.VKeywordTextField.text = ""
            VReportView.VReportContentTextView.text = ""
        }
    }
}

extension MTTCommentDetailBaseViewController:MTTCircleViewModelDelegate {
    func dPraiseSuccessCallBack(info: [String : Any]) {
        
    }
    
    func dPraiseFailureCallBack(info: [String : Any]) {
        
    }
    
    func dDeviceDynamicListSuccessCallBack(_ dataSource: [MTTCircleModel]) {
        
    }
    
    func dDeviceDynamicListFailureCallBack(_ error: MTTError) {
        
    }
    
    func dDynamicListSuccessCallBack(_ info: [String : Any]?) {
        
    }
    
    func dDynamicListFailureCallBack(_ error: MTTError) {
        
    }
    
    func dLoginSuccessCallBack(info: [String : Any]?) {
        
    }
    
    func dLoginFailureCallBack(info: [String : Any]?) {
        
    }
    
    func dReportAbuseErrorCallBack(info: [String : Any]?) {
        if VReportView != nil {
            VReportView.isHidden = true
            VReportView.VKeywordTextField.text = ""
            VReportView.VReportContentTextView.text = ""
        }
        let msg = info!["msg"] as! String
        self.view.toast(message: msg)
    }
    
    func dReportAbuseSuccessCallBack(info: [String : Any]?) {
        if VReportView != nil {
            VReportView.isHidden = true
            VReportView.VKeywordTextField.text = ""
            VReportView.VReportContentTextView.text = ""
        }
        let msg = info!["msg"] as! String
        self.view.toast(message: msg)
    }
}

// MARK: - 扩展 delegate
extension MTTCommentDetailBaseViewController:UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return self.MCicrleModel.cellHeight
        default:
            if self.ODataSource.count > 0 {
                return self.ODataSource[indexPath.item].cellHeight
            }   
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}

extension MTTCommentDetailBaseViewController:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        default:
            if self.ODataSource.count > 0 {
                return self.ODataSource.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            var cell = tableView.dequeueReusableCell(withIdentifier: OCommentReusedId) as? MTTCommentTopCell
            if cell == nil {
                cell = MTTCommentTopCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: OCommentReusedId)
            }
            cell?.model = self.MCicrleModel
            cell?.DDelegate = self
            return cell!
            
        default:
            var cell = tableView.dequeueReusableCell(withIdentifier: OCommentListReusedId) as? MTTCommentListCell
            if cell == nil {
                cell = MTTCommentListCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: OCommentListReusedId)
            }
            if self.ODataSource.count > 0 && indexPath.section == 1{
                cell?.model = self.ODataSource[indexPath.item]
            }
            cell?.DDelegate = self
            return cell!
        }
    }
}

// MARK: - top cell image tap call back
extension MTTCommentDetailBaseViewController: MTTCommentTopCellDelegate {
    func dTappedImage(currentIndex: Int, model: MTTCircleModel) {
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

// MARK: - 发表评论相关回调
extension MTTCommentDetailBaseViewController:MTTCommentInputViewDelegate {
    
    // 提交按钮
    func pTappedCommitButton(info: [String : Any]?) {
        if self.VCommentInputView.VTextView.text.count == 0 {
            UIApplication.shared.keyWindow!.toast(message: "请写下评论后提交!")
            return
        }
        self.VCommentInputView.isHidden = true
        let parameter:[String:Any] = ["topic_id":self.MCicrleModel.topic_id,
                                      "username":MTTUserInfoManager.sharedUserInfo.username,
            "content":self.VCommentInputView.VTextView.text!,
            "from_uid":MTTUserInfoManager.sharedUserInfo.uid,
            "to_uid":self.toUid,
            "time":String.getCurrentTimeStamp()
        ]
        
        MTTCommentViewModel.sharedViewModel.commitComment(parameter: parameter, delegate: self)
        self.VCommentInputView.VTextView.text = ""
    }
    
    // 取消按钮
    func pTappedCancelButton(info: [String : Any]?) {
        self.VCommentInputView.isHidden = true
        self.VCommentInputView.VTextView.text = ""
    }
}

extension MTTCommentDetailBaseViewController:MTTCommentViewModelDelegate {
    func dCommentCommitSuccessCallBack(info: [String : Any]?) {
        self.view.toast(message: "评论成功!")
        self.pSetupHUD(title: "加载中...")
        MTTCommentViewModel.sharedViewModel.getCommentList(parameter: ["uid":MTTUserInfoManager.sharedUserInfo.uid,"topic_id":self.MCicrleModel.topic_id], delegate: self)
    }
    
    func dCommentCommitFailureCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
        self.view.toast(message: "遇到问题,请稍候重试")
    }
    
    func dCommentListSuccessCallBack(info: [String : Any]?) {
        if let dataSource = info!["dataSource"] {
            if self.ODataSource.count > 0  {
                self.ODataSource.removeAll()
            }
            self.ODataSource = dataSource as! [MTTCommentModel]
            self.VCommentListTableView.reloadData()
            self.pRemoveHUD()
        }
    }
    
    func dCommentListFailureCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
    }
}

// MARK: - MTTCommentListCellDelegate
extension MTTCommentDetailBaseViewController:MTTCommentListCellDelegate {
    func dTappedToUser(model: MTTCommentModel) {
        
    }
    
    func dTappedFromUser(model: MTTCommentModel) {
        
    }
    
    func dTappedCurrentItem(model: MTTCommentModel) {
        self.VCommentInputView.isHidden = false
        self.VCommentInputView.VTextView.becomeFirstResponder()
        self.toUid = model.fromUid
    }
}

// MARK: - 评论: 只有文本
class MTTCommentDetailOnlyContentViewController: MTTCommentDetailBaseViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 评论: 文本和图片
class MTTCommentDetailContentAndImageViewController: MTTCommentDetailBaseViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 评论: 只有图片
class MTTCommentDetailOnlyImageViewController: MTTCommentDetailBaseViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 评论: 文本和视频
class MTTCommentDetailContentAndVideoViewController: MTTCommentDetailBaseViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - 评论: 只有视频
class MTTCommentDetailOnlyVideoViewController: MTTCommentDetailBaseViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
