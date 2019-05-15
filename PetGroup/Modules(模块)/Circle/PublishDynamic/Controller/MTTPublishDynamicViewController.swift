//
//  MTTPublishDynamicViewController.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/7/31.
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
 发表动态控制
 
 2. 注意事项:
 
 3. 其他说明:
 a7d7f7
 
 
 *****************************/

import UIKit
import Foundation
import RxCocoa
import RxSwift

// MARK: - 发布动态控制器
@available(iOS 11.0, *)
class MTTPublishDynamicViewController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var OInfo:[String:Any]?
    let disposeBag = DisposeBag()
    
    
    private var VBottomContainerView:UIVisualEffectView!
    private var VTextView:UITextView!
    private var VCollectionView:UICollectionView!
    private var VlineView:UIView!
    private var VCameraButton:UIButton!
    private var VPhotoLibraryButton:UIButton!
    private var VPublishButton:UIButton!
    private var VPlaceLable:UILabel!
    private var VTextCountLabel:UILabel!
    
    var images:[UIImage] = []
    var MPublishDynamicModel:MTTPublishDynamicModel!
    
    var VMPublishDynamicViewModel:MTTPublishDynamicViewModel!
    var OUploadCurrentIndex:Int = 0
    
    var kBottomMargin:CGFloat = 60.0
    var kNavigationBarHeight:CGFloat = 64.0
    
    typealias BCallBack = ( _ success:Bool) -> ()
    var completion:BCallBack!
    
    
    
    
    let reusedCellId:String = "reusedCellId"
    
    
    
    
    /// 构造函数
    ///
    /// - Parameter info: info
    required init(info:[String:Any]?) {
        super.init(info: info)
        self.OInfo = info
        MPublishDynamicModel = MTTPublishDynamicModel()
        MPublishDynamicModel.uid = MTTUserInfoManager.sharedUserInfo.uid
        
        VMPublishDynamicViewModel = MTTPublishDynamicViewModel()
        VMPublishDynamicViewModel.DDelegate = self
    }
    
    /// 析构函数
    deinit {
        print("\(MTTPublishDynamicViewController.self) release")
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "写心情"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
        pLayoutSubviews()
        pSetupEvents()
        pSetupNotificationObserver()
    }
    
    // MARK: - 初始化控件 
    func pSetupSubviews() -> Void {
        
        VTextView                                          = UITextView()
        VTextView.textColor                                = UIColor.black
        VTextView.layer.cornerRadius = 10
        VTextView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VTextView.layer.borderWidth = 0.5
        VTextView.clipsToBounds = true
        VTextView.font                                     = UIFont.systemFont(ofSize: 17)
        //VTextView.delegate                                 = self
        VTextView.frame                                    = CGRect(x: 10, y: 20, width: kScreenWidth - 20, height: 180)
        MTTPrint("text count:\(VTextView.text.count)")
        self.view.addSubview(VTextView)
        
        VPlaceLable = UILabel()
        VPlaceLable.text = "此刻有什么新鲜事?"
        VPlaceLable.textAlignment = NSTextAlignment.left
        VPlaceLable.textColor = UIColor.lightGray
        VPlaceLable.font = UIFont.systemFont(ofSize: 18)
        VPlaceLable.frame = CGRect(x: 10, y: 5, width: 200, height: 30)
        VTextView.addSubview(VPlaceLable)
        
        let collectionViewLayout = UICollectionViewFlowLayout()
        
        VCollectionView = UICollectionView(frame: CGRect(x: 0, y: 220, width: kScreenWidth, height: 280), collectionViewLayout: collectionViewLayout)
        VCollectionView.backgroundColor = UIColor.white
        VCollectionView.delegate = self
        VCollectionView.dataSource = self
        VCollectionView.register(MTTPublishImageCell.self, forCellWithReuseIdentifier: reusedCellId)
        self.view.addSubview(VCollectionView)
        
        
        if MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_X || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XS_MAX  || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XS || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XR || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.Simulator_x86_64{
            kBottomMargin = 80.0
            kNavigationBarHeight = 88.0
        }
        
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        VBottomContainerView = UIVisualEffectView(effect: blurEffect)
        VBottomContainerView.frame = CGRect(x: 0.0, y: kScreenHeight - kNavigationBarHeight - kBottomMargin, width: kScreenWidth, height: 50.0)
        self.view.addSubview(VBottomContainerView)
        
        VlineView = UIView()
        VlineView.backgroundColor = UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.8)
        VBottomContainerView.contentView.addSubview(VlineView)
        
        VCameraButton = UIButton()
        VCameraButton.showsTouchWhenHighlighted = true
        VCameraButton.setImage(UIImage.image(imageString: "camera_normal"), for: UIControl.State.normal)
        VCameraButton.setImage(UIImage.image(imageString: "camera_highlighted"), for: UIControl.State.highlighted)
        VBottomContainerView.contentView.addSubview(VCameraButton)
        
        VPhotoLibraryButton = UIButton()
        VPhotoLibraryButton.showsTouchWhenHighlighted = true
        VPhotoLibraryButton.setImage(UIImage.image(imageString: "photo_library_normal"), for: UIControl.State.normal)
        VPhotoLibraryButton.setImage(UIImage.image(imageString: "photo_library_highlighted"), for: UIControl.State.highlighted)
        VBottomContainerView.contentView.addSubview(VPhotoLibraryButton)
        
        VPublishButton = UIButton()
        VPublishButton.showsTouchWhenHighlighted = true
        VPublishButton.setImage(UIImage.image(imageString: "publish_normal"), for: UIControl.State.normal)
        VPublishButton.setImage(UIImage.image(imageString: "publish_highlighted"), for: UIControl.State.highlighted)
        VBottomContainerView.contentView.addSubview(VPublishButton)
        
        VTextCountLabel = UILabel()
        VTextCountLabel.text = "200"
        VTextCountLabel.font = UIFont.systemFont(ofSize: 15)
        VTextCountLabel.textColor = UIColor.colorWithString(colorString: "#3399ff")
        VTextCountLabel.textAlignment = NSTextAlignment.left
        VBottomContainerView.contentView.addSubview(VTextCountLabel)
    }
    
    func pLayoutSubviews() -> Void {
        
        VlineView.snp.makeConstraints { (make) in
            make.left.top.right.equalTo(VBottomContainerView)
            make.height.equalTo(0.5)
        }
        
        VCameraButton.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.centerY.equalTo(VBottomContainerView)
            make.height.width.equalTo(30)
        }
        
        VPhotoLibraryButton.snp.makeConstraints { (make) in
            make.right.equalTo(VCameraButton.snp.left).offset(-30)
            make.centerY.height.width.equalTo(VCameraButton)
        }
        
        VPublishButton.snp.makeConstraints { (make) in
            make.right.equalTo(VPhotoLibraryButton.snp.left).offset(-30)
            make.centerY.height.width.equalTo(VCameraButton)
        }
        
        VTextCountLabel.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.width.equalTo(80)
            make.height.top.equalTo(VBottomContainerView)
        }
    }
    
    // MARK: - 监听事件 
    private func pSetupEvents() -> Void {
        VTextView.rx.text
            .map({($0?.count)! > 0})
            .subscribe(onNext:{ isTrue in
                if isTrue
                {
                    self.VPlaceLable.isHidden = true
                    self.VTextCountLabel.text = String.init(format: "%d", 200 - self.VTextView.text.count)
                    if self.VTextView.text.count >= 200
                    {
                        self.VTextView.text = self.VTextView.text.sliceString(0, to: 199)
                    } else if self.VTextView.text.count >= Int(170)
                    {
                        self.VTextCountLabel.textColor = UIColor.red
                        print("输入框个数:",self.VTextView.text.count as Any)
                    } else
                    {
                        self.VTextCountLabel.textColor = UIColor.colorWithString(colorString: "#3399ff")
                    }
                    
                } else
                {
                    self.VPlaceLable.isHidden = false
                    self.VTextCountLabel.text = "200"
                }})
            .disposed(by: disposeBag)
        
        // MARK: - 相机按钮的点击
        // 相机按钮的点击
        VCameraButton.rx.tap
            .subscribe(onNext: { (_) in
                if MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.Simulator_x86_64 {
                    self.view.toast(message: "模拟器暂不支持打开相机")
                } else {
                    if self.images.count < 4 {
                        let imagePickerVC = UIImagePickerController()
                        imagePickerVC.delegate = self
                        imagePickerVC.sourceType = UIImagePickerController.SourceType.camera
                        self.navigationController?.present(imagePickerVC, animated: true, completion: {
                            
                        })
                    } else {
                        self.view.toast(message: "最多只能添加4张图片")
                    }
                }
            }, onError: { (error) in
                
            }, onCompleted: { 
                
            }).disposed(by: disposeBag)
        
        // MARK: - 相册按钮的点击
        // 相册
        VPhotoLibraryButton.rx.tap.subscribe(onNext: { (_) in
            if self.images.count < 4
            {
                let photoPicker = MTTPhotoPicker(info: nil, maxCount: 4 - self.images.count)
                let nav = UINavigationController(rootViewController: photoPicker)
                self.present(nav, animated: false, completion: { 
                    
                })
                
                photoPicker.completion = { photos in 
                    let _ = photos?.map({ (image) in
                        self.images.append(image)
                    })
                    
                    DispatchQueue.main.async {
                        self.VCollectionView.reloadData()
                    }
                }
            } else {
                self.view.toast(message: "最多只能添加4张图片")
            }
            
        }, onError: { (error) in
            MTTPrint("相册按钮点击错误:\(error)")
        }, onCompleted: { 
            MTTPrint("相册按钮点击完成")
        }).disposed(by: disposeBag)
        
        // MARK: - 发动态按钮的点击
        VPublishButton.rx.tap.subscribe(onNext: { (_) in
            
            if self.VTextView.text.count < 1 && self.images.count < 1 {
                self.view.toast(message: "请写下此刻的心情或挑选一些照片")
            } else {
                self.pSetupHUD()
                if self.images.count != 0
                {
                    // 文本和图片
                    self.MPublishDynamicModel.dynamic_type = 1
                    if self.VTextView.text.count < 1{
                        //只有图片
                        self.MPublishDynamicModel.dynamic_type = 2
                    }
                    self.MPublishDynamicModel.content = self.VTextView.text
                    self.MPublishDynamicModel.time = String.getCurrentTimeStamp()
                    
                    // 获取token
                    let info:[String:Any] = ["phone":MTTUserInfoManager.sharedUserInfo.phone, "password":MTTUserInfoManager.sharedUserInfo.password]
                    
                    self.VMPublishDynamicViewModel.getUploadFileToken(info: info)
                    
                } else {
                    
                    // 只有文本
                    self.MPublishDynamicModel.dynamic_type = 0
                    self.MPublishDynamicModel.content = self.VTextView.text
                    self.MPublishDynamicModel.time = String.getCurrentTimeStamp()
                    
                    // 调用发表动态接口
                    let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                                  "username":MTTUserInfoManager.sharedUserInfo.username,
                                                  "content":self.MPublishDynamicModel.content,
                                                  "time":self.MPublishDynamicModel.time,
                                                  "attach":self.MPublishDynamicModel.attach,
                                                  "dynamic_type":self.MPublishDynamicModel.dynamic_type
                    ]
                    
                    self.VMPublishDynamicViewModel.publishDynamic(info: parameter)
                    
                }
            }
            
        }, onError: { (error) in
            
        }, onCompleted: {
            
        }).disposed(by: disposeBag)
    }
    
    // MARK: - 处理键盘监听 
    func pSetupNotificationObserver() -> Void
    {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShowAction(notify:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHideAction(notify:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShowAction(notify:Notification) -> Void
    {
        let userInfo      = notify.userInfo
        let keyboardFrame = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! CGRect
        UIView.animate(withDuration: 0.1, animations: {
            self.VBottomContainerView.y = keyboardFrame.origin.y - 50 - self.kNavigationBarHeight
        }) { (completed) in
            
        }
    }
    
    @objc func keyboardWillHideAction(notify:Notification) -> Void
    {
        UIView.animate(withDuration: 0.1, animations: {
            self.VBottomContainerView.y = kScreenHeight - 50 - self.kNavigationBarHeight
            
        }) { (completed) in
            
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
    
    // MARK: - class method  类方法
    
    // MARK: - private method 私有方法
    
}

// MARK: - 相机相册回调 
@available(iOS 11.0, *)
extension MTTPublishDynamicViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let originalImage:UIImage = info[.originalImage] as! UIImage
        
        var compressQuality:Data
        compressQuality = originalImage.jpegData(compressionQuality: 0.5)!
        
        if compressQuality.count > 1500000 {
            compressQuality = originalImage.jpegData(compressionQuality: 0.3)!
        }
        
        let compressQualityImage = UIImage(data: compressQuality)
        
        let compressImage = UIImage.compressImage(originalImage: compressQualityImage!)
        
        images.append(compressImage)
        self.VCollectionView.reloadData()
        picker.dismiss(animated: true) { 
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true) { 
            
        }
    }
    
}

// MARK: - UICollectionView 相关代理
@available(iOS 11.0, *)
extension MTTPublishDynamicViewController: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 40.0 * 3.0) / 2, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

@available(iOS 11.0, *)
extension MTTPublishDynamicViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let info:[String:Any] = ["imageSource":images, "currentIndex": indexPath.item, "type":0]
        
        let photoBrowser = MTTPhotoBrowser(info: info)
        photoBrowser.DDelegate = self
        self.present(photoBrowser, animated: true) {
            
        }
    }
}

@available(iOS 11.0, *)
extension MTTPublishDynamicViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! MTTPublishImageCell
        if images.count > 0 {
            cell.image = images[indexPath.item]
            cell.VImageView.indexPath = indexPath
            cell.VDeleteButton.tag = indexPath.item
            cell.DDelegate = self
        }
        return cell
        
    }
}

// MARK: - cell tapped delegate 回调
@available(iOS 11.0, *)
extension MTTPublishDynamicViewController: MTTPublishImageCellDelegate
{
    func dTappedDeleteButton(currentIndex: Int) {
        self.images.remove(at: currentIndex)
        self.VCollectionView.reloadData()
    }
    
    func dTappedImageView(indexPath: IndexPath) {
        let info:[String:Any] = ["imageSource":images, "currentIndex": indexPath.item, "type":0]
        images[indexPath.item] = UIImage.image(imageString: "clear_placeholder")
        self.VCollectionView.reloadItems(at: [IndexPath(item: indexPath.item, section: 0)])
        let photoBrowser = MTTPhotoBrowser(info: info)
        photoBrowser.DDelegate = self
        self.present(photoBrowser, animated: true) {
            
        }
        photoBrowser.BCompletion = { photos in
            self.images = photos
            self.VCollectionView.reloadData()
        }
        
    }
}


// MARK: - 图片浏览器 点击图片和删除图片回调 
@available(iOS 11.0, *)
extension MTTPublishDynamicViewController: MTTPhotoBrowserDelegate
{
    func dShouldReloadData(images: [UIImage]) {
        self.images = images
        self.VCollectionView.reloadData()
    }
}

@available(iOS 11.0, *)
extension MTTPublishDynamicViewController:MTTPublishDynamicViewModelDelegate{
    func dPublishDynamicFailureCallBack(info: [String : Any]?) {
        pRemoveHUD()
        self.view.toast(message: "网络异常,请稍候重试")
    }
    
    func dGetUploadFileTokenSuccessCallBack(info: [String : Any]?) {
        let token = info!["token"] as! String
        self.OUploadCurrentIndex = self.images.count
        for (index, image) in images.enumerated() {
            VMPublishDynamicViewModel.uploadImage(image: image, token: token, currentIndex: index)
        }
        
    }
    
    func dUploadImageSuccessCallBack(info: [String : Any]?) {
        let imageURL:String = info!["imageURL"] as! String
        let _:Int = info!["currentIndex"] as! Int
        
        if MPublishDynamicModel.attach.count < 1 {
            MPublishDynamicModel.attach = imageURL
        } else {
            MPublishDynamicModel.attach = MPublishDynamicModel.attach + "," + imageURL
        }
        
        let attachArray = MPublishDynamicModel.attach.components(separatedBy: ",")
        
        
        // 所有图片上传完成
        if attachArray.count == self.images.count {
            // 调用发表动态接口
            let parameter:[String:Any] = ["uid":MTTUserInfoManager.sharedUserInfo.uid,
                                          "content":MPublishDynamicModel.content,
                                          "time":MPublishDynamicModel.time,
                                          "attach":MPublishDynamicModel.attach,
                                          "dynamic_type":MPublishDynamicModel.dynamic_type
            ]
            
            VMPublishDynamicViewModel.publishDynamic(info: parameter)
        }
        
    }
    
    func dPublishDynamicSuccessCallBack(info: [String : Any]?) {
        pRemoveHUD()
        self.view.toast(message: "发表心情成功!")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
            self.completion(true)
            self.navigationController?.popViewController(animated: true)
        }
        
    }
    
    
}

