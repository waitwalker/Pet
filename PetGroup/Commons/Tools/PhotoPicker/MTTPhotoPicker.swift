//
//  MTTPhotoPicker.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/8/8.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit
import Photos

// MARK: - 照片选择器入口
class MTTPhotoPicker: UIViewController {
    
    var allAlbumModels:[MTTAlbumModel] = []
    var VTableView:UITableView!
    
    let reusedCellId:String = "reusedCellId"
    
    typealias BCallBack = (_ photos:[UIImage]?)->()
    
    var completion:BCallBack!
    var OMaxCount:Int = 4
    
    var OMaxRequestCount:Int = 0
    var OMaxRequestCount_load:Int = 0
    
    var Otimer:Timer!
    var Otimer_load:Timer!
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// 构造函数
    ///
    /// - Parameter info: info
    init(info:[String:Any]?, maxCount:Int = 4) {
        super.init(nibName: nil, bundle: nil)
        self.OMaxCount = maxCount
        
        //pSetupInitData()
    }
    
    
    /// 获取初始化数据
    func pSetupInitData() -> Void {
        
        if allAlbumModels.count > 0 {
            allAlbumModels.removeAll()
        }
        
        MTTPhotoManager.sharedManager.fetchAllAlbums(true, allowPickImage: true) { (allAlbumModels) in
            
            if let albumModels = allAlbumModels
            {
                self.allAlbumModels = albumModels
                DispatchQueue.main.async {
                    if self.VTableView != nil
                    {
                        self.VTableView.reloadData()
                    }
                }
            }
        }
    }
    
    func pSetupSubviews() -> Void {
        VTableView = UITableView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64), style: UITableView.Style.plain)
        VTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        VTableView.contentInset = UIEdgeInsets.init(top: 10, left: 0, bottom: 10, right: 0)
        VTableView.register(MTTAlbumCell.self, forCellReuseIdentifier: reusedCellId)
        VTableView.delegate = self
        VTableView.dataSource = self
        self.view.addSubview(VTableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.pSetUpNavigation(title: "相册")
        pSetupInitData()
    }
    
    // MARK: - 获取相册权限 暂时保留
    func p_handleDeniedAuthorization() -> Void {
        Otimer = Timer(timeInterval: 2.0, target: self, selector: #selector(requestAuthorizationAction), userInfo: nil, repeats: true)
        Otimer.fire()
        RunLoop.current.add(Otimer, forMode: RunLoop.Mode.default)
    }
    
    @objc func requestAuthorizationAction() -> Void {
        if OMaxRequestCount < 10 {
            OMaxRequestCount = OMaxRequestCount + 1
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case .notDetermined, .restricted:break
                    case .denied:
                        DispatchQueue.main.async {
                            self.view.toast(message: "还没有授权访问相册,您可以去系统设置页面打开相册访问权限")
                        }
                case .authorized:
                    self.pSetupInitData()
                    self.removerTimer()
                }
            }
        } else {
            self.removerTimer()
        }
    }
    
    func removerTimer() -> Void {
        if Otimer != nil {
            Otimer.invalidate()
            Otimer = nil
        }
    }
    
    // MARK: - 获取相册权限 暂时保留
    func p_handleDeniedAuthorization_load() -> Void {
        Otimer_load = Timer(timeInterval: 2.0, target: self, selector: #selector(requestAuthorizationAction_load), userInfo: nil, repeats: true)
        
        RunLoop.current.add(Otimer_load, forMode: RunLoop.Mode.default)
        Otimer_load.fire()
    }
    
    @objc func requestAuthorizationAction_load() -> Void {
        if OMaxRequestCount_load < 5 {
            OMaxRequestCount_load = OMaxRequestCount_load + 1
            PHPhotoLibrary.requestAuthorization { (status) in
                switch status{
                case .notDetermined, .restricted, .denied:
                    DispatchQueue.main.async {
                        let window = UIApplication.shared.keyWindow
                        
                        window?.toast(message: "还没有授权访问相册,您可以去系统设置页面打开相册访问权限")
                    }
                case .authorized:
                    self.removerTimer_load()
                }
            }
        } else {
            self.removerTimer_load()
        }
    }
    
    func removerTimer_load() -> Void {
        if Otimer_load != nil {
            Otimer_load.invalidate()
            Otimer_load = nil
        }
    }
    
    func pSetupInitData_load() -> Void {
        MTTPhotoManager.sharedManager.fetchAllAssets { (allAssets) in
            
            if let assets = allAssets
            {
                let albumModel = MTTAlbumModel()
                albumModel.assetModels = assets
                albumModel.name = "所有照片"
                albumModel.count = assets.count
                
                let pickerLayoutController = MTTPhotoPickerLayoutController(albumModel: albumModel, maxCount: self.OMaxCount)
                self.navigationController?.pushViewController(pickerLayoutController, animated: false)
                pickerLayoutController.completion = { photos in 
                    self.navigationController?.dismiss(animated: true, completion: { 
                        self.completion(photos)
                    })
                }
            }
        }
    }
    
    
    
    /// 设置导航栏
    ///
    /// - Parameter title: 导航栏标题
    func pSetUpNavigation(title: String) -> Void {
        self.navigationItem.title = title
        let rightCameraButton = UIButton()
        rightCameraButton.addTarget(self, action: #selector(dismissAction), for: UIControl.Event.touchUpInside)
        rightCameraButton.frame = CGRect(x: 0, y: 0, width: 52, height: 32)
        rightCameraButton.setTitle("取消", for: UIControl.State.normal)
        rightCameraButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        let fixedRightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedRightButton.width = -12.0
        navigationItem.rightBarButtonItems = [fixedRightButton, UIBarButtonItem(customView: rightCameraButton)]
    }
    
    @objc func popAction() -> Void {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissAction() -> Void {
        self.dismiss(animated: true) {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        pSetupSubviews()
        self.pSetupInitData_load()
        p_handleDeniedAuthorization_load()
        
        
    }
}

// MARK: - tableView delegate
extension MTTPhotoPicker: UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if self.allAlbumModels.count > 0 {
            let photoPickerLayoutContoller = MTTPhotoPickerLayoutController(albumModel: self.allAlbumModels[indexPath.item], maxCount:self.OMaxCount)
            self.navigationController?.pushViewController(photoPickerLayoutContoller, animated: true)
            photoPickerLayoutContoller.completion = { photos in 
                self.navigationController?.dismiss(animated: true, completion: { 
                    self.completion(photos)
                })
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
}

extension MTTPhotoPicker: UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.allAlbumModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: reusedCellId) as? MTTAlbumCell
        if cell == nil {
            cell = MTTAlbumCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: reusedCellId)
        }
        
        if self.allAlbumModels.count > 0 {
            let albumModel = self.allAlbumModels[indexPath.item]
            cell?.albumModel = albumModel
        }
        
        return cell!
    }
}

// MARK: - 相册cell
class MTTAlbumCell: UITableViewCell {
    
    var VImageView:UIImageView!
    var VTitleLabel:UILabel!
    var VRightArrowImageView:UIImageView!
    var VLineView:UIView!
    
    
    var albumModel:MTTAlbumModel?{
        didSet{
            
            VTitleLabel.attributedText = String.attributeString((albumModel?.name)!, second: String((albumModel?.count)!))
            if let name = albumModel?.name, let count = albumModel?.count {
                VTitleLabel.attributedText = String.attributeString(name, second: String(count))
            }
            
            if let assetModel = albumModel?.assetModels.first {
                MTTPhotoManager.sharedManager.fetchThumbnailImage(assetModel.asset, targetSize: CGSize(width: 70, height: 70)) { (image, info, isDegraded) in
                    if let photo  = image {
                        self.VImageView.image = photo
                    }
                }
            }
        }
    }
    
    func pSetupSubviews() -> Void {
        VImageView = UIImageView()
        VImageView.isUserInteractionEnabled = true
        self.contentView.addSubview(VImageView)
        
        VTitleLabel = UILabel()
        VTitleLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(VTitleLabel)
        
        VRightArrowImageView = UIImageView()
        VRightArrowImageView.isUserInteractionEnabled = true
        VRightArrowImageView.image = UIImage(named: "right_arrow_placeholder")
        self.contentView.addSubview(VRightArrowImageView)
        
        VLineView = UIView()
        VLineView.backgroundColor = UIColor.colorWithString(colorString: "#3399ff")
        self.contentView.addSubview(VLineView)
    }
    
    func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(5)
            make.height.equalTo(70)
            make.width.equalTo(70)
        }
        
        VTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(VImageView.snp.right).offset(10)
            make.height.equalTo(30)
            make.width.equalTo(240)
            make.centerY.equalTo(self.contentView)
        }
        
        VRightArrowImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(16)
            make.right.equalTo(-20)
            make.centerY.equalTo(self.contentView)
        }
    
        VLineView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.left.right.bottom.equalTo(self.contentView)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        pSetupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - ********************* 缩略图布局控制 *********************
// MARK: - 布局的相册中的相片
class MTTPhotoPickerLayoutController: UIViewController {

    var VCollectionView:UICollectionView!
    var OInfo:[String:Any]!
    var OAlbumModel:MTTAlbumModel?
    var OMaxCount:Int = 4
    
    let reusedCollectionViewCellId:String = "reusedCollectionViewCellId"
    
    typealias BCallBack = (_ photos:[UIImage]?)->()
    
    var completion:BCallBack!
    
    var VBottomBarView:UIView!
    var VMaxSelectedHintLabel:UILabel!
    var VFinishButton:UIButton!
    
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(albumModel:MTTAlbumModel?, maxCount:Int = 4) {
        super.init(nibName: nil, bundle: nil)
        if let aModel = albumModel {
            OAlbumModel = aModel
            self.OMaxCount = maxCount
            if VCollectionView != nil
            {
                VCollectionView.reloadData()
            }
        }
    }
    
    init(info:[String:Any]?) {
        super.init(nibName: nil, bundle: nil)
        if let para = info {
            self.OInfo = para
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let albumModel = OAlbumModel {
            self.navigationItem.title = albumModel.name
        }
        pSetUpNavigation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        pSetupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func pSetupSubviews() -> Void {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        flowLayout.sectionInset = UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6)
        
        VCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64 - 50 - 5), collectionViewLayout: flowLayout)
        VCollectionView.backgroundColor = UIColor.white
        VCollectionView.register(MTTPhotoPickerLayoutCell.self, forCellWithReuseIdentifier: reusedCollectionViewCellId)
        VCollectionView.delegate = self
        VCollectionView.dataSource = self
        self.view.addSubview(VCollectionView)
        
        var kBottomMargin:CGFloat = 64.0
        if MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_X || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XS_MAX  || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XS || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XR || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.Simulator_x86_64{
            kBottomMargin = 88.0
        }
        
        VBottomBarView = UIView(frame: CGRect(x: 0, y: kScreenHeight - 50.0 - kBottomMargin, width: kScreenWidth, height: 50.0))
        VBottomBarView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(VBottomBarView)
        
        VMaxSelectedHintLabel = UILabel()
        VMaxSelectedHintLabel.frame = CGRect(x: 20, y: 10, width: 150, height: 30)
        VMaxSelectedHintLabel.textColor = UIColor.colorWithString(colorString: "#3399ff")
        VMaxSelectedHintLabel.font = UIFont.systemFont(ofSize: 17)
        VMaxSelectedHintLabel.textAlignment = NSTextAlignment.left
        VMaxSelectedHintLabel.text = String(format: "最多能选:%d 张", self.OMaxCount)
        VBottomBarView.addSubview(VMaxSelectedHintLabel)
        
        VFinishButton = UIButton()
        VFinishButton.frame = CGRect(x: kScreenWidth - 30 - 60, y: 10, width: 60, height: 30)
        VFinishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        VFinishButton.setTitle((self.OAlbumModel?.selectedModels.count)! > 0 ? "完成 " + String(format: "( %d )", (self.OAlbumModel?.selectedModels.count)!) : "完成", for: UIControl.State.normal)
        VFinishButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff"), for: UIControl.State.normal)
        VFinishButton.addTargetTo(self, action: #selector(finishButtonAction), for: UIControl.Event.touchUpInside)
        VFinishButton.sizeToFit()
        VBottomBarView.addSubview(VFinishButton)
        
        if let count = self.OAlbumModel?.assetModels.count {
            if count > 1 {
                VCollectionView.scrollToItem(at: IndexPath(item: count > 1 ?  (count - 1) : 0, section: 0), at: UICollectionView.ScrollPosition.bottom, animated: false)
            }
        }
    }
    
    @objc func finishButtonAction() -> Void {
        if let selectedModels = self.OAlbumModel?.selectedModels {
            var photos:[UIImage] = []
            
            for (_, assetModel) in selectedModels.enumerated()
            {
                MTTPhotoManager.sharedManager.fetchRawImage(assetModel.asset) { (image, info, stop) in
                    if let photo = image {
                        let oImage = UIImage.compressImage(originalImage: photo)
                        var compressQuality:Data
                        compressQuality = oImage.jpegData(compressionQuality: 0.5)!
                        
                        if compressQuality.count > 1500000 {
                            compressQuality = oImage.jpegData(compressionQuality: 0.3)!
                        }
                        
                        let compressQualityImage = UIImage(data: compressQuality)
                        
                        let compressImage = UIImage.compressImage(originalImage: compressQualityImage!)
                        
                        photos.append(compressImage)
                        
                        if photos.count == selectedModels.count
                        {
                            DispatchQueue.main.async {
                                
                                self.completion(photos)
                                self.navigationController?.popViewController(animated: false)
                            }
                        }
                    }
                }
            }
            
        }
    }
    
    
    /// 设置导航栏
    ///
    /// - Parameter title: 导航栏标题
    func pSetUpNavigation() -> Void {
        let leftCameraButton = UIButton()
        leftCameraButton.addTarget(self, action: #selector(popAction), for: UIControl.Event.touchUpInside)
        leftCameraButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        leftCameraButton.setImage(UIImage(named: "left_back"), for: UIControl.State.normal)
        leftCameraButton.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        
        let fixedButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedButton.width = -12.0
        navigationItem.leftBarButtonItems = [fixedButton, UIBarButtonItem(customView: leftCameraButton)]
        
        let rightCameraButton = UIButton()
        rightCameraButton.addTarget(self, action: #selector(dismissAction), for: UIControl.Event.touchUpInside)
        rightCameraButton.frame = CGRect(x: 0, y: 0, width: 52, height: 32)
        rightCameraButton.setTitle("取消", for: UIControl.State.normal)
        rightCameraButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        
        
        let fixedRightButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedRightButton.width = -12.0
        navigationItem.rightBarButtonItems = [fixedRightButton, UIBarButtonItem(customView: rightCameraButton)]
    }
    
    @objc func popAction() -> Void {
        if self.navigationController != nil {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dismissAction() -> Void {
        self.dismiss(animated: true) {
            
        }
    }
}

// MARK: - 缩略图 collectionview delegaye
extension MTTPhotoPickerLayoutController:UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let albumModel = self.OAlbumModel {
            
            let info:[String:Any] = ["albumModel":albumModel,"currentIndex":indexPath.item]
            let previewController = MTTPhotoPickerPreviewController(info: info)
            self.present(previewController, animated: false) {
                
            }
            
            previewController.completion = { photos in
                self.completion(photos)
                self.navigationController?.popViewController(animated: false)
            }
        }
    }
}

extension MTTPhotoPickerLayoutController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let albumM = self.OAlbumModel{
            return albumM.assetModels.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCollectionViewCellId, for: indexPath) as! MTTPhotoPickerLayoutCell
        if let albumModel = self.OAlbumModel{
            cell.assetModel = albumModel.assetModels[indexPath.item]
            cell.assetModel?.currentIndex = indexPath.item
            cell.DDelegate = self
        }
        return cell
    }
}


extension MTTPhotoPickerLayoutController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (kScreenWidth - 6.0 * 5.0) / 4.0
        return CGSize(width: width, height: width * 1.2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6.0
    }
}

// MARK: - 缩略图cell delegate 在控制器中的回调 
extension MTTPhotoPickerLayoutController: MTTPhotoPickerLayoutCellDelegate
{
    func dTapSelectedButton(currentIndex: Int) {
        if let albumModel = self.OAlbumModel{
            
            let assetModel = albumModel.assetModels[currentIndex]
            
            if !assetModel.isSelected
            {
                if (self.OAlbumModel?.selectedModels.count)! < self.OMaxCount
                {
                    assetModel.isSelected = true
                    self.OAlbumModel?.selectedModels.append(assetModel)
                } else
                {
                    self.view.toast(message: String(format: "最多能选:%d 张", self.OMaxCount))
                }
                
            } else 
            {
                let tmpModels:[MTTAssetModel] = (self.OAlbumModel?.selectedModels)!
                var shouldRemoveIndex:Int = 0
                if tmpModels.count > 0 
                {
                    for (index, aModel) in tmpModels.enumerated() {
                        if aModel.currentIndex == assetModel.currentIndex {
                            shouldRemoveIndex = index
                        }
                    }
                    self.OAlbumModel?.selectedModels.remove(at: shouldRemoveIndex)
                }
                assetModel.isSelected = false
            }
            self.VFinishButton.setTitle((self.OAlbumModel?.selectedModels.count)! > 0 ? "完成 " + String(format: "( %d )", (self.OAlbumModel?.selectedModels.count)!) : "完成", for: UIControl.State.normal)
            self.VFinishButton.sizeToFit()
            self.OAlbumModel!.assetModels[currentIndex] = assetModel
            self.VCollectionView.reloadItems(at: [IndexPath(item: currentIndex, section: 0)])
        }
    }
}

// MARK: - 缩略图cell delegate 
protocol MTTPhotoPickerLayoutCellDelegate {
    func dTapSelectedButton(currentIndex: Int) -> Void 
}

// MARK: - 缩略图cell
class MTTPhotoPickerLayoutCell: UICollectionViewCell {
    
    var VImageView:UIImageView!
    
    var VSelectedButton:UIButton!
    
    var DDelegate:MTTPhotoPickerLayoutCellDelegate?
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var assetModel:MTTAssetModel?{
        didSet{
            
            let width = (kScreenWidth - 6.0 * 5.0) / 4.0
            let size = CGSize(width: width, height: width * 1.2)
            if let aModel = assetModel {
                MTTPhotoManager.sharedManager.fetchThumbnailImage(aModel.asset, targetSize: size) { (image, info, isDegraded) in
                    if let photo  = image {
                        self.VImageView.image = photo
                    }
                    self.VSelectedButton.tag = aModel.currentIndex
                    if aModel.isSelected
                    {
                        self.VSelectedButton.isSelected = true
                    } else
                    {
                        self.VSelectedButton.isSelected = false
                    }
                }
            }
        }
    }
    
    func pSetupSubviews() -> Void {
        VImageView = UIImageView()
        VImageView.isUserInteractionEnabled = true
        VImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.5).cgColor
        VImageView.layer.borderWidth = 0.5
        self.contentView.addSubview(VImageView)
        
        VSelectedButton = UIButton()
        VSelectedButton.setImage(UIImage.image(imageString: "thumbnail_deselected"), for: UIControl.State.normal)
        VSelectedButton.setImage(UIImage.image(imageString: "thumbnail_selected"), for: UIControl.State.selected)
        VSelectedButton.imageEdgeInsets = UIEdgeInsets.init(top: 6, left: 6, bottom: 6, right: 6)
        VSelectedButton.isSelected = false
        VSelectedButton.addTargetTo(self, action: #selector(selectedButtonAction(button:)), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(VSelectedButton)
    }
    
    func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.contentView)
        }
        
        VSelectedButton.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.height.width.equalTo(32)
        }
        
    }
    
    @objc func selectedButtonAction(button: UIButton) -> Void {
        DDelegate?.dTapSelectedButton(currentIndex: button.tag)
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameAnimation.values = [0.5, 1.0, 1.2, 1.5, 1.2, 1.0]
        keyFrameAnimation.keyTimes = [0.0, 0.2, 0.3, 0.5]
        keyFrameAnimation.calculationMode = CAAnimationCalculationMode.linear
        button.imageView?.layer.add(keyFrameAnimation, forKey: "an")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
}

// MARK: - 预览控制器
class MTTPhotoPickerPreviewController: UIViewController {
    
    var VCollectionView:UICollectionView!
    
    let reusedPreviewCellId:String = "reusedPreviewCellId"
    
    var OAlbumModel:MTTAlbumModel?
    var OCurrentIndex:Int = 0
    
    var VTopBarView:UIView!
    var VBottomBarView:UIView!
    
    // 选中
    var VSelectedHintButton:UIButton!
    
    // 选择原图
    var VSelectedRawButton:UIButton!
    
    // 完成
    var VFinishButton:UIButton!
    
    // 当前图片
    var currentImage:UIImage!
    
    // 是否选择原图
    var isSelectedRaw:Bool = false
    
    typealias BCallBack = (_ photos:[UIImage]?)->()
    
    var completion:BCallBack!
    
    
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    init(info:[String:Any]?) {
        super.init(nibName: nil, bundle: nil)
        if let inf = info {
            OAlbumModel = (inf["albumModel"] as! MTTAlbumModel)
            OCurrentIndex = inf["currentIndex"] as! Int
        }
    }
    
    func pSetupSubviews() -> Void {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        
        VCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        VCollectionView.isPagingEnabled = true
        VCollectionView.backgroundColor = UIColor.black
        VCollectionView.register(MTTPhotoPickerPreviewCell.self, forCellWithReuseIdentifier: reusedPreviewCellId)
        VCollectionView.delegate = self
        VCollectionView.dataSource = self
        self.view.addSubview(VCollectionView)
        
        VTopBarView = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 64))
        VTopBarView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(VTopBarView)
        
        var kBottomMargin:CGFloat = 0.0
        if MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_X || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XS_MAX  || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XS || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == MTTDeviceModelType.iPhone_XR{
            kBottomMargin = 40.0
        }
        
        VBottomBarView = UIView(frame: CGRect(x: 0, y: kScreenHeight - 50 - kBottomMargin, width: kScreenWidth, height: 50))
        VBottomBarView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view.addSubview(VBottomBarView)
        
        let leftCameraButton = UIButton()
        leftCameraButton.addTarget(self, action: #selector(dismissAction), for: UIControl.Event.touchUpInside)
        leftCameraButton.frame = CGRect(x: 16, y: 20, width: 32, height: 32)
        leftCameraButton.setImage(UIImage(named: "left_back"), for: UIControl.State.normal)
        leftCameraButton.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        VTopBarView.addSubview(leftCameraButton)
        
        VSelectedHintButton = UIButton()
        VSelectedHintButton.isEnabled = false
        VSelectedHintButton.setImage(UIImage(named: "thumbnail_deselected"), for: UIControl.State.normal)
        VSelectedHintButton.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        VSelectedHintButton.frame = CGRect(x: kScreenWidth - 20 - 32, y: 24, width: 32, height: 32)
        VTopBarView.addSubview(VSelectedHintButton)
        
        VSelectedRawButton = UIButton()
        VSelectedRawButton.setImage(UIImage(named: "raw_deselected"), for: UIControl.State.normal)
        VSelectedRawButton.setTitle((self.OAlbumModel?.selectedModels.count)! > 0 ? "原图 " + String((self.OAlbumModel?.selectedModels.count)!) : "原图", for: UIControl.State.normal)
        VSelectedRawButton.imageEdgeInsets = UIEdgeInsets.init(top: 8, left: 8, bottom: 8, right: 8)
        VSelectedRawButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        VSelectedRawButton.frame = CGRect(x: 20, y: 10, width: 120, height: 30)
        VSelectedRawButton.addTargetTo(self, action: #selector(selectRawImageAction), for: UIControl.Event.touchUpInside)
        VSelectedRawButton.setImageWithPosition(postion: MTTButtonImagePostion.Left, spacing: 5)
        VSelectedRawButton.sizeToFit()
        VBottomBarView.addSubview(VSelectedRawButton)
        
        VFinishButton = UIButton()
        VFinishButton.frame = CGRect(x: kScreenWidth - 30 - 60, y: 10, width: 60, height: 30)
        VFinishButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        VFinishButton.setTitle((self.OAlbumModel?.selectedModels.count)! > 0 ? "完成 " + String(format: "( %d )", (self.OAlbumModel?.selectedModels.count)!) : "完成", for: UIControl.State.normal)
        VFinishButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff"), for: UIControl.State.normal)
        VFinishButton.addTargetTo(self, action: #selector(finishButtonAction), for: UIControl.Event.touchUpInside)
        VFinishButton.sizeToFit()
        VBottomBarView.addSubview(VFinishButton)
        
        VCollectionView.scrollToItem(at: IndexPath(item: OCurrentIndex, section: 0), at: UICollectionView.ScrollPosition.right, animated: false)
    }
    
    // 控制bar的显示与隐藏
    func pHandleBarShow() -> Void {
        if VTopBarView.isHidden == true {
            UIView.animate(withDuration: 0.1, animations: {
                self.VTopBarView.isHidden = false
                self.VBottomBarView.isHidden = false
            }) { (completion) in
                
            }
        } else {
            UIView.animate(withDuration: 0.1, animations: {
                self.VTopBarView.isHidden = true
                self.VBottomBarView.isHidden = true
            }) { (completion) in
                
            }
        }
    }
    
    // 返回回调
    @objc func dismissAction() -> Void {
        self.dismiss(animated: false) {
            
        }
    }
    
    
    /// 选择原图回调
    @objc func selectRawImageAction() -> Void {
        
        self.isSelectedRaw = !self.isSelectedRaw
        if self.currentImage != nil {
            self.imageSize(image: self.currentImage)
        }
    }
    
    // 完成按钮回调
    @objc func finishButtonAction() -> Void {
        MTTPrint("完成按钮回调 ")
        if let selectedModels = self.OAlbumModel?.selectedModels {
            if selectedModels.count > 0
            {
                var photos:[UIImage] = []
                
                for (_, assetModel) in selectedModels.enumerated()
                {
                    MTTPhotoManager.sharedManager.fetchRawImage(assetModel.asset) { (image, info, stop) in
                        if let photo = image {
                            let oImage = UIImage.compressImage(originalImage: photo)
                            var compressQuality:Data
                            compressQuality = oImage.jpegData(compressionQuality: 0.5)!
                            
                            if compressQuality.count > 1500000 {
                                compressQuality = oImage.jpegData(compressionQuality: 0.3)!
                            }
                            
                            let compressQualityImage = UIImage(data: compressQuality)
                            
                            let compressImage = UIImage.compressImage(originalImage: compressQualityImage!)
                            
                            photos.append(compressImage)
                            
                            if photos.count == selectedModels.count
                            {
                                self.dismiss(animated: false) {
                                    self.completion(photos)
                                }
                            }
                        }
                    }
                }
                
                
            } else {
                self.dismiss(animated: true) { 
                    
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        pSetupSubviews()
    }
}

// MARK: - scorllView delegate
extension MTTPhotoPickerPreviewController:UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / kScreenWidth + 0.5)
        OCurrentIndex = pageIndex
        
        if let assetModel = self.OAlbumModel?.assetModels[pageIndex] {
            if assetModel.isSelected
            {
                self.VSelectedHintButton.setImage(UIImage(named: "thumbnail_selected"), for: UIControl.State.normal)
                return
            } else {
                self.VSelectedHintButton.setImage(UIImage(named: "thumbnail_deselected"), for: UIControl.State.normal)
            }
        }
        
    }
}


// MARK: - 预览 collectionview delegaye
extension MTTPhotoPickerPreviewController:UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let albumModel = self.OAlbumModel {
            MTTPrint(albumModel.name)
            self.pHandleBarShow()
        }
    }
}

extension MTTPhotoPickerPreviewController:UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let albumM = self.OAlbumModel{
            return albumM.assetModels.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedPreviewCellId, for: indexPath) as! MTTPhotoPickerPreviewCell
        
        if let albumModel = self.OAlbumModel{
            // 显示原图
            let assetModel = albumModel.assetModels[indexPath.item]
            MTTPhotoManager.sharedManager.fetchRawImage(assetModel.asset) { (image, info, isDegraded)  in
                if let photo  = image {
                    cell.image = photo
                    self.imageSize(image: photo)
                }
            }
            
        }
        return cell
    }
    
    // 计算图片尺寸
    func imageSize(image:UIImage) -> Void {
        
        let queue = DispatchQueue(label: "imageSizeQueue", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)
        queue.async {
            
            let data = image.pngData()
            
            if let da = data
            {
                self.currentImage = image
                let str = String.imageFileSize(data: da)
                let imageWidth = image.size.width
                let imageHeight = image.size.height
                let sizeStr = String(format: " W:%.0f x H:%.0f", imageWidth,imageHeight)
                
                DispatchQueue.main.async {
                    
                    if self.isSelectedRaw {
                        self.VSelectedRawButton.setImage(UIImage(named: "raw_selected"), for: UIControl.State.normal)
                        self.VSelectedRawButton.setTitle("原图 " + str + sizeStr, for: UIControl.State.normal)
                        self.VSelectedRawButton.setTitleColor(UIColor.colorWithString(colorString: "#3399ff"), for: UIControl.State.normal)
                        self.VSelectedRawButton.sizeToFit()
                    } else
                    {
                        self.VSelectedRawButton.setImage(UIImage(named: "raw_deselected"), for: UIControl.State.normal)
                        self.VSelectedRawButton.setTitle("原图", for: UIControl.State.normal)
                        self.VSelectedRawButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
                        self.VSelectedRawButton.sizeToFit()
                    }
                }
            }
        }
    }
    
}


extension MTTPhotoPickerPreviewController:UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: kScreenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}

// MARK: - 预览cell
class MTTPhotoPickerPreviewCell: UICollectionViewCell {
    
    
    var VImageView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var image:UIImage?{
        didSet{
            if let photo = image {
                self.VImageView.image = photo
            }
        }
    }
    
    func pSetupSubviews() -> Void {
        VImageView = UIImageView()
        VImageView.isUserInteractionEnabled = true
        VImageView.contentMode = UIView.ContentMode.scaleAspectFit
        self.contentView.addSubview(VImageView)
    }
    
    func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.contentView)
        }
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
}



// MARK: - ******************* manager ********************
// MARK: - 照片资源管理者
class MTTPhotoManager: NSObject {
    
    // 单例属性
    static let sharedManager = MTTPhotoManager()
    
    // 对照片按修改日期进行排序,默认true
    var sortAscendingByModifyDate:Bool = true
    
    
    private override init() {
        super.init()
    }
    
    
    /// 获取缩略图
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - targetSize: 目标size
    ///   - completion: 回调
    func fetchThumbnailImage(_ asset:PHAsset, targetSize:CGSize, completion:@escaping (_ image:UIImage?, _ info:[String:Any]?, _ isDegraded: Bool?)->()) -> Void {
        
        let option = PHImageRequestOptions()
        option.resizeMode = PHImageRequestOptionsResizeMode.fast
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: option) { (image, info) in
            completion(image,(info as! [String : Any]),false)
        }
        
    }
    
    func fetchThumbnailImage(_ asset:PHAsset, targetSize:CGSize, progressedHandler:@escaping (_ progress:Double?, _ error:Error?, _ stop:UnsafeMutablePointer<ObjCBool>?, _ info:[String:Any]?)->(), completion:@escaping (_ image:UIImage?, _ info:[String:Any]?, _ isDegraded: Bool?)->()) -> Void {
        
        var mutableImage:UIImage!
        
        let option = PHImageRequestOptions()
        option.resizeMode = PHImageRequestOptionsResizeMode.fast
        
        PHImageManager.default().requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFill, options: option) { (image, info) in
            if image != nil
            {
                mutableImage = image
            }
            let downloadFinished = ( (info![PHImageCancelledKey] != nil) &&  (info![PHImageCancelledKey] as! Bool) && ((info![PHImageErrorKey] != nil) &&  info![PHImageErrorKey] as! Bool))
            if downloadFinished && image != nil
            {
                completion(image,(info as! [String : Any]),(info![PHImageResultIsDegradedKey] as! Bool))
            }
            
            if (info![PHImageResultIsInCloudKey] != nil) && (image == nil) {
                let options = PHImageRequestOptions()
                option.progressHandler = { (progress, error, stop, info) in
                    progressedHandler(progress, error, stop, (info as! [String:Any]))
                }
                options.isNetworkAccessAllowed = true
                options.resizeMode = PHImageRequestOptionsResizeMode.fast
                PHImageManager.default().requestImageData(for: asset, options: options, resultHandler: { (data, dataUTI, orientation, info) in
                    let resultImage = UIImage(data: data!, scale: 0.1)
                    if resultImage != nil
                    {
                        mutableImage = resultImage!
                    }
                    
                    completion(mutableImage,(info as! [String : Any]),false)
                    
                })
                
            }
        }
    }
    
    
    /// 获取原图
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - completion: 回调
    func fetchRawImage(_ asset:PHAsset, completion:@escaping (_ image:UIImage?, _ info:[String:Any]?, _ isDegraded: Bool?)->()) -> Void {
        let option = PHImageRequestOptions()
        option.resizeMode = PHImageRequestOptionsResizeMode.fast
        PHImageManager.default().requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: PHImageContentMode.aspectFill, options: option) { (image, info) in
            completion(image,(info as! [String : Any]),false)
        }
        
    }
    
    /// 获取所有asset
    ///
    /// - Parameter completion: 回调 返回所有asset
    func fetchAllAssets(completion:(_ allAssetModels:[MTTAssetModel]?)->()) -> Void {
        fetchAllAssets(true, completion: completion)
    }
    
    /// 获取所有asset
    ///
    /// - Parameters:
    ///   - sortAscendingByModifyDate: 是否按日期排序
    ///   - completion: 回调
    func fetchAllAssets(_ sortAscendingByModifyDate:Bool, completion:(_ allAssetModels:[MTTAssetModel]?)->()) -> Void {
        fetchAssets(nil, sortAscendingByModifyDate: sortAscendingByModifyDate, completion: completion)
    }
    
    
    /// 获取指定相册的asset
    ///
    /// - Parameters:
    ///   - collection: 相册
    ///   - sortAscendingByModifyDate: 是否按日期排序
    ///   - completion: 回调
    func fetchAssets(_ collection:PHAssetCollection?, sortAscendingByModifyDate:Bool, completion:(_ allAssetModels:[MTTAssetModel]?)->()) -> Void {
        
        let option = PHFetchOptions()
        
        // 通过option可以过滤视频 gif等
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: sortAscendingByModifyDate)]
        
        var assetModels:[MTTAssetModel] = []
        var fetchResult:PHFetchResult<PHAsset>!
        
        if collection == nil {
            fetchResult = PHAsset.fetchAssets(with: option)
        } else {
            fetchResult = PHAsset.fetchAssets(in: collection!, options: option)
        }
        
        fetchResult.enumerateObjects { (asset, index, stop) in
            let assetModel = MTTAssetModel()
            assetModel.asset = asset
            switch asset.mediaType{
            case .video:
                assetModel.type = MTTAssetModelMediaType.video
            case .unknown:
                assetModel.type = MTTAssetModelMediaType.unknown
            case .image:
                assetModel.type = MTTAssetModelMediaType.photo
            case .audio:
                assetModel.type = MTTAssetModelMediaType.audio
            }
            assetModels.append(assetModel)
        }
        completion(assetModels)
    }
    
    /// 获取所有相册
    ///
    /// - Parameters:
    ///   - allowPickVideo: 是否允许视频
    ///   - allowPickImage: 是否允许照片
    ///   - completion: 回调
    func fetchAllAlbums(_ allowPickVideo:Bool, allowPickImage:Bool, completion:(_ allAlbumModels:[MTTAlbumModel]?)->()) -> Void {
        
        let option = PHFetchOptions()
        if !allowPickVideo {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image as! CVarArg)
        }
        
        if !allowPickImage {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.video as! CVarArg)
        }
        
        var albumModels:[MTTAlbumModel] = []
        
        // 智能相册集合
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: option)
        smartAlbum.enumerateObjects { (collection, index, stop) in
            let fetchAssetResult = PHAsset.fetchAssets(in: collection, options: option)
            let albumModel = MTTAlbumModel()
            albumModel.name = collection.localizedTitle!
            albumModel.count = fetchAssetResult.count
            
            fetchAssetResult.enumerateObjects({ (asset, indexs, stops) in
                let assetModel = MTTAssetModel()
                assetModel.asset = asset
                switch asset.mediaType{
                case .video:
                    assetModel.type = MTTAssetModelMediaType.video
                case .unknown:
                    assetModel.type = MTTAssetModelMediaType.unknown
                case .image:
                    assetModel.type = MTTAssetModelMediaType.photo
                case .audio:
                    assetModel.type = MTTAssetModelMediaType.audio
                }
                albumModel.assetModels.append(assetModel)
            })
            if albumModel.count > 0
            {
                albumModels.append(albumModel)
            }
        }
        
        // 用户创建的相册集合
        let fetchResult = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        fetchResult.enumerateObjects { (collection, index, stop) in
            let fetchAssetResult = PHAsset.fetchAssets(in: collection as! PHAssetCollection, options: option)
            let albumModel = MTTAlbumModel()
            albumModel.name = collection.localizedTitle!
            albumModel.count = fetchAssetResult.count
            
            fetchAssetResult.enumerateObjects({ (asset, indexs, stops) in
                let assetModel = MTTAssetModel()
                assetModel.asset = asset
                switch asset.mediaType{
                case .video:
                    assetModel.type = MTTAssetModelMediaType.video
                case .unknown:
                    assetModel.type = MTTAssetModelMediaType.unknown
                case .image:
                    assetModel.type = MTTAssetModelMediaType.photo
                case .audio:
                    assetModel.type = MTTAssetModelMediaType.audio
                }
                albumModel.assetModels.append(assetModel)
            })
            
            if albumModel.count > 0
            {
                albumModels.append(albumModel)
            }
        }
        completion(albumModels)
    }
    
    
    // 获取相册
    func getCameraRollAlbum(allowPickVideo:Bool, allowPickImage:Bool, needFetchAssets:Bool, completion:@escaping ( _ model: MTTAlbumModel)->()) -> Void {
        
        let option = PHFetchOptions()
        if !allowPickVideo {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image as! CVarArg)
        }
        
        if !allowPickImage {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.video as! CVarArg)
        }
        
        if !sortAscendingByModifyDate {
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: sortAscendingByModifyDate)]
        }
        
        let smartAlbums = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        smartAlbums.enumerateObjects { (collection, index, stop) in
            
            let fetchResult = PHAsset.fetchAssets(in: collection, options: option)
            let model = self.modelWithResult(result: fetchResult, name: collection.localizedTitle!, isCameraRoll: true, needFecthAssets: needFetchAssets)
            completion(model)
            
        }
        
    }
    
    func isCameraRollAlbum(metaData: PHAssetCollection) -> Bool {
        return false
    }
    
    func modelWithResult(result:PHFetchResult<PHAsset>, name:String, isCameraRoll:Bool, needFecthAssets:Bool) -> MTTAlbumModel {
        let albumModel = MTTAlbumModel()
        albumModel.setResult(result: result, needFetchAssets: needFecthAssets)
        albumModel.name = name
        albumModel.isCameraRoll = isCameraRoll
        albumModel.count = result.count
        return albumModel
    }
    
    func getCameraRollAlbum(allowPickVideo:Bool, allowPickImage:Bool, needFetchAssets:Bool, completion: @escaping (_ models: [MTTAlbumModel])->()) -> Void {
        let option = PHFetchOptions()
        if !allowPickVideo {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.image as! CVarArg)
        }
        
        if !allowPickImage {
            option.predicate = NSPredicate(format: "mediaType == %ld", PHAssetMediaType.video as! CVarArg)
        }
        
        if !sortAscendingByModifyDate {
            option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: sortAscendingByModifyDate)]
        }
        
        let myStreamAlbum = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumMyPhotoStream, options: nil)
        let smartAlbum = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.smartAlbum, subtype: PHAssetCollectionSubtype.albumRegular, options: nil)
        
        let topLevelUserCollections = PHCollectionList.fetchTopLevelUserCollections(with: nil)
        
        let syncedAlbum = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumSyncedAlbum, options: nil)
        
        let sharedAlbum = PHAssetCollection.fetchAssetCollections(with: PHAssetCollectionType.album, subtype: PHAssetCollectionSubtype.albumCloudShared, options: nil)
        
        let allAlbums:[PHFetchResult<PHAssetCollection>] = [myStreamAlbum,smartAlbum,topLevelUserCollections as! PHFetchResult<PHAssetCollection>,syncedAlbum,sharedAlbum]
        var allAlbumArr:[MTTAlbumModel] = []
        
        
        
        for fetchResult in allAlbums {
            fetchResult.enumerateObjects { (collection, index, stop) in
                let result = PHAsset.fetchAssets(in: collection, options: option)
                
                let albumModel = MTTAlbumModel()
                albumModel.name = collection.localizedTitle!
                albumModel.count = result.count
                albumModel.result = result
                result.enumerateObjects({ (asset, indexs, stops) in
                    let assetModel = MTTAssetModel()
                    assetModel.asset = asset
                    switch asset.mediaType{
                    case .video:
                        assetModel.type = MTTAssetModelMediaType.video
                    case .unknown:
                        assetModel.type = MTTAssetModelMediaType.unknown
                    case .image:
                        assetModel.type = MTTAssetModelMediaType.photo
                    case .audio:
                        assetModel.type = MTTAssetModelMediaType.audio
                    }
                    albumModel.assetModels.append(assetModel)
                })
                allAlbumArr.append(albumModel)
            }
        }
        
        completion(allAlbumArr)
        
    }
    
}

// MARK: - ******************* models ********************


/// 类型
///
/// - photo:
/// - livePhoto:
/// - gif:
/// - video:
/// - audio:
enum MTTAssetModelMediaType:UInt {
    case photo = 0
    case livePhoto = 1
    case gif = 2
    case video = 3
    case audio = 4
    case unknown = 5
}

// MARK: - asset model
class MTTAssetModel: NSObject {
    
    var asset:PHAsset!
    var isSelected:Bool = false
    var type:MTTAssetModelMediaType = MTTAssetModelMediaType.photo
    var needOscillatoryAnimation:Bool = false
    var timeLength:String = ""
    var cachedImage:UIImage!
    var currentIndex:Int = 0
    
    
    /// 用一个PHAsset实例生产一个照片模型
    ///
    /// - Parameters:
    ///   - asset: asset
    ///   - type: assetMediaType
    /// - Returns: assetModel
    static func model(_ asset: PHAsset, with type: MTTAssetModelMediaType) -> MTTAssetModel {
        let model = MTTAssetModel()
        model.asset = asset
        model.isSelected = false
        model.type = type
        return model
    }
    
    static func model(_ asset: PHAsset, with type: MTTAssetModelMediaType, timeLength:String) -> MTTAssetModel {
        let model = MTTAssetModel()
        model.timeLength = timeLength
        return model
    }
    
}

// MARK: - 相册model
class MTTAlbumModel: NSObject {
    var name:String = "" //相册名称
    var count:Int = 0 //相册中的照片数量
    var result:PHFetchResult<PHAsset>!
    var assetModels:[MTTAssetModel] = []
    var selectedModels:[MTTAssetModel] = []
    var selectedCount:UInt = 0
    var isCameraRoll:Bool = false
    
    
    func setResult(result: PHFetchResult<PHAsset>, needFetchAssets:Bool) -> Void {
        
    }
}
