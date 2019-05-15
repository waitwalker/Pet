//
//  MTTWelcomePageView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/3.
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
 欢迎引导控件 
 
 2. 注意事项:
 
 3. 其他说明:
 layoutSubviews调用时机 
 1)init初始化不会触发layoutSubviews
 但是是用initWithFrame 进行初始化时，当rect的值不为CGRectZero时,也会触发
 2)addSubview会触发layoutSubviews 
 3)设置view的frame会触发layoutSubviews,当然前提是frame的值设置前后发生了变化 
 4)滚动一个UIScrollView会触发layoutSubviews
 5)旋转Screen会触发父UIView上的layoutSubviews 
 6)改变一个UIView的大小会触发父UIView上的layoutSubviews 
 
 
 *****************************/




import UIKit
import SnapKit
import RxCocoa
import RxSwift


/// 欢迎引导页回调 
protocol MTTWelcomePageViewDelegate {
    func DTappedSkipButton(welcomePageView: MTTWelcomePageView?, info:[String:Any]?) -> Void 
}

// MARK: - ***************** class 分割线 ******************
class MTTWelcomePageView: UIView {
    
    // MARK: - variable 变量 属性
    private var VCollectionView:UICollectionView!
    private var VPageControl:UIPageControl!
    
    private let OReusedCellId:String = "reusedCellId"
    
    private var VMWelcomeViewModel:MTTWelcomePageViewModel!
    private var MDataSource:[MTTWelcomePageModel] = Array<MTTWelcomePageModel>()
    private var OInfo:[String:Any]!
    var DDelegate:MTTWelcomePageViewDelegate?
    
    
    
    
    
    // MARK: - instance method 实例方法 
    
    /// 构造方法    
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - info: info
    init(frame:CGRect, info:[String:Any]?) {
        super.init(frame: frame)
        self.OInfo = info
        //self.init(frame: frame)
        pSetupSubviews(info: info)
        self.pSetupEvent(info: info)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("调用layoutSubviews")
        pLayoutSubviews()
    }
    
    private func pSetupEvent(info:[String:Any]?) -> Void {
        self.VMWelcomeViewModel = MTTWelcomePageViewModel(info: MTTSequence.OInfoSequence(info!))
        self.VMWelcomeViewModel.MWelcomeModels
            .asObservable()
            .subscribe(onNext:{element in 
                self.MDataSource = element
                DispatchQueue.main.async {
                    self.VCollectionView.reloadData()
                }
            }).disposed(by: DisposeBag())
    }
    
    private func pSetupSubviews(info:[String:Any]?) -> Void 
    {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        VCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: flowLayout)
        VCollectionView.register(MTTWelcomePageCell.self, forCellWithReuseIdentifier: OReusedCellId)
        VCollectionView.delegate = self
        VCollectionView.dataSource = self
        VCollectionView.isPagingEnabled = true
        self.addSubview(VCollectionView)
        
        VPageControl = UIPageControl()
        VPageControl.pageIndicatorTintColor = UIColor.white
        VPageControl.currentPageIndicatorTintColor = UIColor.colorWithString(colorString: "#3399ff")
        VPageControl.numberOfPages = (info!["imageStrings"] as! [String]).count
        self.addSubview(VPageControl)
    }
    
    func pLayoutSubviews() -> Void 
    {
        VCollectionView.snp.makeConstraints { (make) in
            make.left.bottom.right.top.equalTo(self)
        }
        
        VPageControl.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.height.equalTo(20)
            make.width.equalTo(80)
            make.bottom.equalTo(-100)
        }
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// 析构函数 
    deinit {
        print("welcome page deinit")
    }
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}

extension MTTWelcomePageView: MTTWelcomePageCellDelegate
{
    func DDTappedSkipButton(info: [String : Any]?) {
        self.DDelegate?.DTappedSkipButton(welcomePageView: self, info: info)
    }
}

extension MTTWelcomePageView:UICollectionViewDelegateFlowLayout
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

extension MTTWelcomePageView: UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let width = scrollView.frame.width
        VPageControl.currentPage = Int(offsetX / width + 0.5)
    }
}

extension MTTWelcomePageView:UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
}

extension MTTWelcomePageView:UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.MDataSource.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OReusedCellId, for: indexPath) as! MTTWelcomePageCell
        cell.model = self.MDataSource[indexPath.item]
        cell.DDelegate = self
        return cell
    }
}

protocol MTTWelcomePageCellDelegate {
    func DDTappedSkipButton(info:[String:Any]?) -> Void 
}

// MARK: - 欢迎页cell 
class MTTWelcomePageCell: UICollectionViewCell {
    
    private var VImageView:UIImageView!
    private var VSkipButton:UIButton!
    var DDelegate:MTTWelcomePageCellDelegate?
    
    
    var model:MTTWelcomePageModel? {
        didSet{
            self.VImageView.image = UIImage(named: (model?.OImageString)!)
            if (model?.isShowSkipButton)! == false{
                self.VSkipButton.isHidden = true
            } else {
                self.VSkipButton.isHidden = false
            }
        }
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
    
    private func pSetupSubviews() -> Void {
        VImageView = UIImageView()
        self.contentView.addSubview(VImageView)
        
        VSkipButton = UIButton()
        VSkipButton.setTitle("跳过", for: UIControl.State.normal)
        VSkipButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        VSkipButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VSkipButton.setTitleColor(UIColor.black, for: UIControl.State.highlighted)
        VSkipButton.layer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
        VSkipButton.layer.cornerRadius = 5
        VSkipButton.clipsToBounds = true
        VSkipButton.addTarget(self, action: #selector(skipButtonAction), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(VSkipButton)
        
    }
    
    private func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.contentView)
        }
        
        VSkipButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(-50)
            make.centerX.equalTo(self.contentView)
            make.height.equalTo(35)
            make.width.equalTo(100)
        }
    }
    
    @objc func skipButtonAction() -> Void {
        self.DDelegate?.DDTappedSkipButton(info: ["currentModel":self.model as Any])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
