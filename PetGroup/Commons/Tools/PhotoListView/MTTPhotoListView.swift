//
//  MTTPhotoListView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/8/23.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit
import Kingfisher

protocol MTTPhotoListViewDelegate {
    func pTappedImage(currentIndex:Int) -> Void
}

class MTTPhotoListView: UIView {
    
    private var VPlaceImageView:UIView!
    private var VPhotoListCollectionView:UICollectionView!
    private let reusedCellId:String = "reusedCellId"
    private var collectionViewFlowLayout:UICollectionViewFlowLayout!
    
    private var VFirstImageView:UIImageView!
    private var VSecondImageView:UIImageView!
    private var VThirdImageView:UIImageView!
    private var VFourthImageView:UIImageView!
    var DDelegate:MTTPhotoListViewDelegate?
    
    
    
    
    var ODataSource:MTTCircleModel?{
        didSet{
            if let dataSource = ODataSource {
                switch dataSource.attach.count{
                    case 1:
                        VFirstImageView.frame = CGRect(x: 0.0, y: 10.0, width: self.width - 20.0, height: self.height - 20.0)
                        VSecondImageView.frame = CGRect.zero
                        VThirdImageView.frame = CGRect.zero
                        VFourthImageView.frame = CGRect.zero
                        
                    VFirstImageView.isHidden = false
                    VSecondImageView.isHidden = true
                    VThirdImageView.isHidden = true
                    VFourthImageView.isHidden = true
                        VFirstImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[0]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                    
                    case 2:
                        VFirstImageView.frame = CGRect(x: 0.0, y: 10.0, width: (self.width - 30.0) / 2.0, height: self.height - 20.0)
                        VSecondImageView.frame = CGRect(x: VFirstImageView.frame.maxX + 10.0, y: 10.0, width: VFirstImageView.width, height: VFirstImageView.height)
                        VThirdImageView.frame = CGRect.zero
                        VFourthImageView.frame = CGRect.zero
                        VFirstImageView.isHidden = false
                        VSecondImageView.isHidden = false
                        VThirdImageView.isHidden = true
                        VFourthImageView.isHidden = true
                        VFirstImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[0]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        VSecondImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[1]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                    }
                    case 3:
                        VFirstImageView.frame = CGRect(x: 0.0, y: 10.0, width: (self.width - 30.0) / 2.0, height: (self.height - 30.0) / 2.0)
                        VSecondImageView.frame = CGRect(x: VFirstImageView.frame.maxX + 10.0, y: 10.0, width: VFirstImageView.width, height: VFirstImageView.height)
                        VThirdImageView.frame = CGRect(x: VFirstImageView.x, y: VFirstImageView.frame.maxY + 10.0, width: VFirstImageView.width, height: VFirstImageView.height)
                        VFourthImageView.frame = CGRect.zero
                        VFirstImageView.isHidden = false
                        VSecondImageView.isHidden = false
                        VThirdImageView.isHidden = false
                        VFourthImageView.isHidden = true
                        VFirstImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[0]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        VSecondImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[1]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        VThirdImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[2]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        
                    case 4:
                        VFirstImageView.frame = CGRect(x: 0.0, y: 10.0, width: (self.width - 30.0) / 2.0, height: (self.height - 30.0) / 2.0)
                        VSecondImageView.frame = CGRect(x: VFirstImageView.frame.maxX + 10.0, y: 10.0, width: VFirstImageView.width, height: VFirstImageView.height)
                        VThirdImageView.frame = CGRect(x: VFirstImageView.x, y: VFirstImageView.frame.maxY + 10.0, width: VFirstImageView.width, height: VFirstImageView.height)
                        VFourthImageView.frame = CGRect(x: VSecondImageView.x, y: VThirdImageView.y, width: VFirstImageView.width, height: VFirstImageView.height)
                        VFirstImageView.isHidden = false
                        VSecondImageView.isHidden = false
                        VThirdImageView.isHidden = false
                        VFourthImageView.isHidden = false
                        
                        VFirstImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[0]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        VSecondImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[1]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        VThirdImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[2]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                        VFourthImageView.kf.setImage(with: URL(string: kQiNiuServer +  dataSource.attach[3]), placeholder: UIImage.image(imageString: "pet_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                            MTTPrint("下载进度:\(receivedSize/totalSize)")
                        }) { (img, error, cacheType, url) in
                            MTTPrint("cacheType:\(cacheType)")
                        }
                    default:
                        VFirstImageView.frame = CGRect.zero
                        VSecondImageView.frame = CGRect.zero
                        VThirdImageView.frame = CGRect.zero
                        VFourthImageView.frame = CGRect.zero
                        VFirstImageView.isHidden = true
                        VSecondImageView.isHidden = true
                        VThirdImageView.isHidden = true
                        VFourthImageView.isHidden = true
                }
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubview()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //pLayoutSubview()
    }
    
    func pSetupSubview() -> Void {
        
        VFirstImageView = UIImageView()
        VFirstImageView.layer.cornerRadius = 5.0
        VFirstImageView.layer.borderWidth = 0.5
        VFirstImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VFirstImageView.clipsToBounds = true
        VFirstImageView.isUserInteractionEnabled = true
        VFirstImageView.indexPath = IndexPath(item: 0, section: 0)
        self.addSubview(VFirstImageView)
        
        VSecondImageView = UIImageView()
        VSecondImageView.layer.cornerRadius = 5.0
        VSecondImageView.layer.borderWidth = 0.5
        VSecondImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VSecondImageView.clipsToBounds = true
        VSecondImageView.isUserInteractionEnabled = true
        VSecondImageView.indexPath = IndexPath(item: 0, section: 1)
        self.addSubview(VSecondImageView)
        
        VThirdImageView = UIImageView()
        VThirdImageView.isUserInteractionEnabled = true
        VThirdImageView.layer.cornerRadius = 5.0
        VThirdImageView.layer.borderWidth = 0.5
        VThirdImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VThirdImageView.clipsToBounds = true
        VThirdImageView.indexPath = IndexPath(item: 0, section: 2)
        self.addSubview(VThirdImageView)
        
        VFourthImageView = UIImageView()
        VFourthImageView.isUserInteractionEnabled = true
        VFourthImageView.layer.cornerRadius = 5.0
        VFourthImageView.layer.borderWidth = 0.5
        VFourthImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VFourthImageView.clipsToBounds = true
        VFourthImageView.indexPath = IndexPath(item: 0, section: 3)
        self.addSubview(VFourthImageView)
        
        let tapFirstGest = UITapGestureRecognizer(target: self, action: #selector(firstTapGesAction(gesture:)))
        let tapSecondGest = UITapGestureRecognizer(target: self, action: #selector(secondTapGesAction(gesture:)))
        let tapThirdGest = UITapGestureRecognizer(target: self, action: #selector(thirdTapGesAction(gesture:)))
        let tapFourthGest = UITapGestureRecognizer(target: self, action: #selector(fourthTapGesAction(gesture:)))
        VFirstImageView.addGestureRecognizer(tapFirstGest)
        VSecondImageView.addGestureRecognizer(tapSecondGest)
        VThirdImageView.addGestureRecognizer(tapThirdGest)
        VFourthImageView.addGestureRecognizer(tapFourthGest)
    }
    
    @objc func firstTapGesAction(gesture:UITapGestureRecognizer) -> Void {
        self.DDelegate?.pTappedImage(currentIndex: 0)
    }
    
    @objc func secondTapGesAction(gesture:UITapGestureRecognizer) -> Void {
        self.DDelegate?.pTappedImage(currentIndex: 1)
    }
    
    @objc func thirdTapGesAction(gesture:UITapGestureRecognizer) -> Void {
        self.DDelegate?.pTappedImage(currentIndex: 2)
    }
    
    @objc func fourthTapGesAction(gesture:UITapGestureRecognizer) -> Void {
        self.DDelegate?.pTappedImage(currentIndex: 3)
    }
    
    func pLayoutSubview() -> Void {
        VPhotoListCollectionView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
    }

}

extension MTTPhotoListView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MTTPhotoListView: UICollectionViewDataSource{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard ((ODataSource?.attach) != nil) else {
            return 0
        }
        return (ODataSource?.attach.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! MTTPopularCell
        cell.VTitleLabel.text = String(indexPath.item)
        cell.VImageView.indexPath = indexPath
        cell.DDelegate = self
        return cell
    }
    
    
}

extension MTTPhotoListView: MTTCollectionViewFlowLayoutDelegate {
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        
        if let attach = ODataSource?.attach {
            switch attach.count{
                case 1:
                return CGSize(width: kScreenWidth - 160.0, height: ((ODataSource?.contentImageHeight)! - 50.0))
                case 2,3,4:
                return CGSize(width: (kScreenWidth - 160.0) / 2.0 , height: ((ODataSource?.contentImageHeight)! - 40.0) / 2.0)
                
                default:
                return CGSize.zero
            }
        } else {
            return CGSize.zero
        }
    }
}

extension MTTPhotoListView: MTTPopularCellDelegate {
    func dTappedPopularImage(index: Int) {
        
    }
}

