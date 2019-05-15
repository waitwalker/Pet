//
//  MTTPhotoBrowser.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/2.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit
import Kingfisher


// MARK: - 上一层级collectionView应该刷新回调
protocol MTTPhotoBrowserDelegate {
    func dShouldReloadData(images: [UIImage]) -> Void 
}

// MARK: - 图片浏览器 
class MTTPhotoBrowser: UIViewController {
    
    var info:[String:Any] = [:]
    
    var currentIndex:Int!
    var images:[UIImage] = []
    var imageURLStrings:[String] = []
    var type:Int = 0
    
    
    var VDeleteButton:UIButton!
    
    var DDelegate:MTTPhotoBrowserDelegate?
    
    let reusedCellId:String = "reusedCellId"
    
    
    typealias BCallBack = (_ photos:[UIImage])->()
    typealias BCBack = (_ showTabBar:Bool)->()
    var BCompletion:BCallBack!
    var completion:BCBack!
    
    // collectionView
    lazy var VCollectionView:UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = UICollectionView.ScrollDirection.horizontal
        let collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = UIColor.clear
        collectionView.register(MTTPhotoBrowserCell.self, forCellWithReuseIdentifier: reusedCellId)
        collectionView.decelerationRate = UIScrollView.DecelerationRate.fast
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.view.addSubview(collectionView)
        return collectionView
    } ()
    
    
    // 懒加载
    // 主滚动容器
    lazy var VMainScrollView:UIScrollView = {
        let scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.isPagingEnabled = true
        scrollView.bounces = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.indicatorStyle = UIScrollView.IndicatorStyle.white
        scrollView.backgroundColor = UIColor.clear
        scrollView.alwaysBounceVertical = true
        scrollView.alwaysBounceHorizontal = true
        return scrollView
    } ()
    
    // 分页
    lazy var VPageControl:UIPageControl = {
        let pageC = UIPageControl(frame: CGRect(x: (kScreenWidth - 80) / 2, y: kScreenHeight - 30 - 30, width: 80, height: 30))
        pageC.pageIndicatorTintColor = UIColor.lightGray
        pageC.currentPageIndicatorTintColor = UIColor.colorWithString(colorString: "#3399ff")
        self.view.addSubview(pageC)
        return pageC
    } ()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    /// 构造方法
    ///
    /// - Parameter info: info 
    init(info:[String:Any]?) {
        super.init(nibName: nil, bundle: nil)
        self.info = info!
        self.currentIndex = (self.info["currentIndex"] as! Int)
        if let ty = self.info["type"] {
            self.type = ty as! Int
        }
        if self.type == 0 {
            self.images = self.info["imageSource"] as! [UIImage]
        } else {
            self.imageURLStrings = self.info["imageURLStrings"] as! [String]
        }
        
        self.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        self.transitioningDelegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        pSetupCollectionView()
        if self.type == 0 {
            pSetupDeleteButton()
        }
        pSetupPageControl()
    }
    
    // MARK: - 设置浏览器collectionView 
    func pSetupCollectionView() -> Void {
        self.view.addSubview(VCollectionView)
        VCollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: UICollectionView.ScrollPosition.right, animated: false)
    }
    
    // 初始化删除按钮
    func pSetupDeleteButton() -> Void {
        
        VDeleteButton = UIButton()
        VDeleteButton.frame = CGRect(x: 30, y: kScreenHeight - 30 - 32, width: 32, height: 32)
        VDeleteButton.setImage(UIImage(named: "delete_normal"), for: UIControl.State.normal)
        VDeleteButton.setImage(UIImage(named: "delete_highlighted"), for: UIControl.State.highlighted)
        VDeleteButton.addTargetTo(self, action: #selector(deleteAction(_:)), for: UIControl.Event.touchUpInside)
        self.view.addSubview(VDeleteButton)
        
    }
    
    // MARK: - 设置分页
    func pSetupPageControl() -> Void {
        if self.type == 0 {
            VPageControl.numberOfPages = self.images.count
        } else {
            VPageControl.numberOfPages = self.imageURLStrings.count
        }
        VPageControl.currentPage = self.currentIndex
    }
    
    // 删除按钮事件回调 
    @objc func deleteAction(_ button: UIButton) -> Void {
        if self.images.count > 0 {
            self.images.remove(at: self.currentIndex)
            VCollectionView.reloadData()
            VPageControl.currentPage = self.currentIndex - 1
            VPageControl.numberOfPages = self.images.count
            if self.images.count == 0
            {
                self.dismiss(animated: true) { 
                }
            }
        } else {
            self.dismiss(animated: true) { 
                
            }
        }
        if currentIndex > 0 {
            self.currentIndex = self.currentIndex - 1
        }
        
        self.DDelegate?.dShouldReloadData(images: self.images)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

// MARK: - UIScrollViewDelegate
extension MTTPhotoBrowser: UIScrollViewDelegate
{
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.width + 0.5)
        if self.type == 0 {
            VPageControl.numberOfPages = self.images.count
        } else {
            VPageControl.numberOfPages = self.imageURLStrings.count
        }
        VPageControl.currentPage = pageIndex
        self.currentIndex = pageIndex
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = Int(scrollView.contentOffset.x / scrollView.width + 0.5)
        if self.type == 0 {
            VPageControl.numberOfPages = self.images.count
        } else {
            VPageControl.numberOfPages = self.imageURLStrings.count
        }
        VPageControl.currentPage = pageIndex
        self.currentIndex = pageIndex
    }
}


// MARK: - collectionview delegate
extension MTTPhotoBrowser: UICollectionViewDelegate
{
    
}

extension MTTPhotoBrowser: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.type == 0 {
            return self.images.count
        } else {
            return self.imageURLStrings.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! MTTPhotoBrowserCell
        if self.images.count > 0 {
            cell.image = self.images[indexPath.item]
        }
        if self.imageURLStrings.count > 0 {
            cell.imageURLString = self.imageURLStrings[indexPath.item]
        }
        cell.DDelegate = self
        return cell
        
    }
}

extension MTTPhotoBrowser: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: kScreenWidth, height: kScreenHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - MTTPhotoBrowserCellDelegate
extension MTTPhotoBrowser: MTTPhotoBrowserCellDelegate
{
    func dPhotoBrowserCell(_ cell: MTTPhotoBrowserCell, didPanScale scale: CGFloat) {
        
        self.view.backgroundColor = UIColor.black.withAlphaComponent(scale)
        if self.type == 0 {
            if scale < 0.55 {
                self.BCompletion(self.images)
            }
        }
    }
    
    func dPhotoBrowserCell(_ cell: MTTPhotoBrowserCell, didSingleTapWith image: UIImage?) {
        if self.type == 0 {
            self.BCompletion(self.images)
        } else {
            self.completion(true)
        }
        self.dismiss(animated: true) {
            
        }
    }
    
    func dPhotoBrowserCell(_ cell: MTTPhotoBrowserCell, didLongPressWith image: UIImage?) {
        
    }
    
    func dPhotoBrowserCellDidLayout(_ cell: MTTPhotoBrowserCell) {
        
    }
    
    func dPhotoBrowserCellSetImage(_ cell: MTTPhotoBrowserCell, placeholder: UIImage?, highQuality: URL?, raw: URL?) {
        
    }
    
    func dPhotoBrowserCellWillLoadImage(_ cell: MTTPhotoBrowserCell, placeholder: UIImage?, url: URL) {
        
    }
    
    func dPhotoBrowserCellLoadingImage(_ cell: MTTPhotoBrowserCell, totalSize: Int64, receiveSize: Int64) {
        
    }
    
    func dPhotoBrowserCellDidLoadImage(_ cell: MTTPhotoBrowserCell, placeholder: UIImage?, url: URL) {
        
    }
    
    
}

// MARK: - 转场动画协议
extension MTTPhotoBrowser: UIViewControllerTransitioningDelegate
{
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MTTAnimatorTransition()
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return MTTAnimatorTransition()
    }
}

// MARK: - *********************** cell ***********************
protocol MTTPhotoBrowserCellDelegate {
    
    
    /// 拖拽手势回调
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - scale: 拖拽比例
    /// - Returns:
    func dPhotoBrowserCell(_ cell: MTTPhotoBrowserCell, didPanScale scale: CGFloat) -> Void
    
    /// 单击手势回调
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - image: image
    /// - Returns:
    func dPhotoBrowserCell(_ cell: MTTPhotoBrowserCell, didSingleTapWith image: UIImage? ) -> Void
    
    /// 长按手势回调
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - image: image
    /// - Returns:
    func dPhotoBrowserCell(_ cell: MTTPhotoBrowserCell, didLongPressWith image: UIImage? ) -> Void
    
    /// cell重新布局
    ///
    /// - Parameter cell: cell
    /// - Returns:
    func dPhotoBrowserCellDidLayout(_ cell: MTTPhotoBrowserCell) -> Void
    
    /// 设置图片
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - placeholder: 站位
    ///   - highQuality: 高清
    ///   - raw: 未处理
    /// - Returns:
    func dPhotoBrowserCellSetImage(_ cell: MTTPhotoBrowserCell, placeholder: UIImage?, highQuality: URL?, raw:URL?) -> Void
    
    /// 图片即将加载
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - placeholder: 站位
    ///   - url: url
    /// - Returns:
    func dPhotoBrowserCellWillLoadImage(_ cell: MTTPhotoBrowserCell, placeholder: UIImage?, url: URL) -> Void
    
    /// 图片正在加载
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - totalSize: 总大小
    ///   - receiveSize: 已接收大小
    /// - Returns:
    func dPhotoBrowserCellLoadingImage(_ cell: MTTPhotoBrowserCell, totalSize: Int64, receiveSize: Int64) -> Void
    
    /// 图片加载完成
    ///
    /// - Parameters:
    ///   - cell: cell
    ///   - placeholder: 站位
    ///   - url: url
    /// - Returns:
    func dPhotoBrowserCellDidLoadImage(_ cell: MTTPhotoBrowserCell, placeholder: UIImage?, url: URL) -> Void
    
}

// MARK: - MTTPhotoBrowserCell
class MTTPhotoBrowserCell: UICollectionViewCell {
    
    var DDelegate:MTTPhotoBrowserCellDelegate?
    
    /// 双击放大图片时的目标比例
    open var imageZoomScaleForDoubleTap: CGFloat = 2.0
    
    /// 计算contentSize应处于的中心位置
    var centerOfContentSize: CGPoint {
        let deltaWidth = bounds.width - VScrollView.contentSize.width
        let offsetX = deltaWidth > 0 ? deltaWidth * 0.5 : 0
        let deltaHeight = bounds.height - VScrollView.contentSize.height
        let offsetY = deltaHeight > 0 ? deltaHeight * 0.5 : 0
        return CGPoint(x: VScrollView.contentSize.width * 0.5 + offsetX,
                       y: VScrollView.contentSize.height * 0.5 + offsetY)
    }
    
    /// 记录pan手势开始时imageView的位置
    private var beganFrame = CGRect.zero
    
    /// 记录pan手势开始时，手势位置
    private var beganTouch = CGPoint.zero
    
    let VScrollView = UIScrollView()
    let VImageView = UIImageView()
    
    /// 取图片适屏size
    private var fitSize: CGSize {
        guard let image = VImageView.image else {
            return CGSize.zero
        }
        let width = VScrollView.bounds.width
        let scale = image.size.height / image.size.width
        return CGSize(width: width, height: scale * width)
    }
    
    /// 取图片适屏frame
    private var fitFrame: CGRect {
        let size = fitSize
        let y = (VScrollView.bounds.height - size.height) > 0 ? (VScrollView.bounds.height - size.height) * 0.5 : 0
        return CGRect(x: 0, y: y, width: size.width, height: size.height)
    }
    
    var image:UIImage? {
        didSet{
            VImageView.image = image
        }
    }
    
    var imageURLString:String? {
        didSet{
            let dprocessor = DefaultImageProcessor()

            VImageView.kf.setImage(with: URL(string: kQiNiuServer + imageURLString!), placeholder: UIImage.image(imageString: ""), options: [.processor(dprocessor)], progressBlock: { (rec, total) in

            }) { (_) in

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
    
    
    
    func pSetupSubviews() -> Void {
        contentView.addSubview(VScrollView)
        VScrollView.delegate = self
        VScrollView.maximumZoomScale = 2.0
        VScrollView.minimumZoomScale = 1.0
        VScrollView.showsVerticalScrollIndicator = false
        VScrollView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            VScrollView.contentInsetAdjustmentBehavior = .never
        }
        
        VScrollView.addSubview(VImageView)
        VImageView.clipsToBounds = true
        VImageView.isUserInteractionEnabled = true
        VImageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        // 长按手势
        let longPressGes = UILongPressGestureRecognizer(target: self, action: #selector(self.longPressAction(gesture:)))
        contentView.addGestureRecognizer(longPressGes)
        
        // 双击手势
        let doubleTapGes = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapAction(gesture:)))
        doubleTapGes.numberOfTapsRequired = 2
        contentView.addGestureRecognizer(doubleTapGes)
        
        // 单击手势
        let singleTapGes = UITapGestureRecognizer(target: self, action: #selector(self.singleTapAction(gesture:)))
        singleTapGes.require(toFail: doubleTapGes)
        contentView.addGestureRecognizer(singleTapGes)
        
        // 拖拽手势
        let panGes = UIPanGestureRecognizer(target: self, action: #selector(self.panAction(gesture:)))
        panGes.delegate = self
        contentView.addGestureRecognizer(panGes)
        
    }
    
    func pLayoutSubviews() -> Void {
        VScrollView.frame = contentView.bounds
        VImageView.frame = VScrollView.bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - cell UIScrollViewDelegate
extension MTTPhotoBrowserCell: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return VImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        VImageView.center = centerOfContentSize
    }
}

// MARK: - cell 上手势事件回调方法 
extension MTTPhotoBrowserCell
{
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) -> Void {
        if gesture.state == UIGestureRecognizer.State.began {
            self.DDelegate?.dPhotoBrowserCell(self, didLongPressWith: VImageView.image)
        }
    }
    
    @objc func doubleTapAction(gesture: UITapGestureRecognizer) -> Void {
        if VScrollView.zoomScale > 1.0 {
            VScrollView.setZoomScale(1.0, animated: true)
        } else {
            VScrollView.setZoomScale(2.0, animated: true)
        }
    }
    
    @objc func singleTapAction(gesture: UITapGestureRecognizer) -> Void {
        self.DDelegate?.dPhotoBrowserCell(self, didSingleTapWith: VImageView.image)
    }
    
    @objc func panAction(gesture: UIPanGestureRecognizer) -> Void {
        guard VImageView.image != nil else {
            return
        }
        switch gesture.state {
        case .began:
            beganFrame = VImageView.frame
            beganTouch = gesture.location(in: VScrollView)
        case .changed:
            let result = panResult(gesture)
            VImageView.frame = result.0
            // 通知代理，发生了缩放。代理可依scale值改变背景蒙板alpha值
            DDelegate?.dPhotoBrowserCell(self, didPanScale: result.1)
            
        case .ended, .cancelled:
            VImageView.frame = panResult(gesture).0
            if gesture.velocity(in: self).y > 30 {
                // dismiss
                singleTapAction(gesture: UITapGestureRecognizer())
            } else {
                // 取消dismiss
                endPan()
            }
        default:
            endPan()
        }
    }
    
    private func panResult(_ pan: UIPanGestureRecognizer) -> (CGRect, CGFloat) {
        // 拖动偏移量
        let translation = pan.translation(in: VScrollView)
        let currentTouch = pan.location(in: VScrollView)
        
        // 由下拉的偏移值决定缩放比例，越往下偏移，缩得越小。scale值区间[0.3, 1.0]
        let scale = min(1.0, max(0.3, 1 - translation.y / bounds.height))
        
        let width = beganFrame.size.width * scale
        let height = beganFrame.size.height * scale
        
        // 计算x和y。保持手指在图片上的相对位置不变。
        // 即如果手势开始时，手指在图片X轴三分之一处，那么在移动图片时，保持手指始终位于图片X轴的三分之一处
        let xRate = (beganTouch.x - beganFrame.origin.x) / beganFrame.size.width
        let currentTouchDeltaX = xRate * width
        let x = currentTouch.x - currentTouchDeltaX
        
        let yRate = (beganTouch.y - beganFrame.origin.y) / beganFrame.size.height
        let currentTouchDeltaY = yRate * height
        let y = currentTouch.y - currentTouchDeltaY
        
        return (CGRect(x: x.isNaN ? 0 : x, y: y.isNaN ? 0 : y, width: width, height: height), scale)
    }
    
    private func endPan() {
        DDelegate?.dPhotoBrowserCell(self, didPanScale: 1.0)
        // 如果图片当前显示的size小于原size，则重置为原size
        let size = fitSize
        let needResetSize = VImageView.bounds.size.width < size.width
            || VImageView.bounds.size.height < size.height
        UIView.animate(withDuration: 0.25) {
            self.VImageView.center = self.centerOfContentSize
            if needResetSize {
                self.VImageView.bounds.size = size
            }
        }
    }
}

extension MTTPhotoBrowserCell: UIGestureRecognizerDelegate
{
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let pan = gestureRecognizer as? UIPanGestureRecognizer else {
            return true
        }
        
        // 向上滑动时, 不响应手势
        let velocity = pan.velocity(in: self)
        if velocity.y < 0.0 {
            return false
        }
        
        // 左右滑动时, 不响应滑动手势
        if abs(Int(velocity.x)) > Int(velocity.y) {
            return false
        }
        
        // 向下滑动, 如果图片顶部超出可视区域, 不响应pan手势
        if VScrollView.contentOffset.y > 0 {
            return false
        }
        return true
    }
}

