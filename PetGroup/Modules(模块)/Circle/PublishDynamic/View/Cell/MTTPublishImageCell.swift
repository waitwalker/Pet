//
//  MTTPublishImageCell.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/8/2.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit

protocol MTTPublishImageCellDelegate {
    func dTappedImageView(indexPath: IndexPath) -> Void
    func dTappedDeleteButton(currentIndex:Int) -> Void
}


class MTTPublishImageCell: UICollectionViewCell {
    
    var image:UIImage? {
        didSet{
            VImageView.image = image
        }
    }
    
    var DDelegate:MTTPublishImageCellDelegate?
    
    
    var VImageView:UIImageView!
    var VDeleteButton:UIButton!
    
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
    
    func pSetupSubviews() -> Void {
        
        VImageView = UIImageView()
        VImageView.contentMode = UIView.ContentMode.scaleAspectFill
        VImageView.isUserInteractionEnabled = true
        VImageView.layer.cornerRadius = 10
        VImageView.clipsToBounds = true
        VImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VImageView.layer.borderWidth = 1.0
        self.contentView.addSubview(VImageView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(imageTapAction))
        VImageView.addGestureRecognizer(tapGes)
        
        VDeleteButton = UIButton()
        VDeleteButton.setImage(UIImage.image(imageString: "publish_selected_delete"), for: UIControl.State.normal)
        VDeleteButton.setImage(UIImage.image(imageString: "publish_selected_delete_highlight"), for: UIControl.State.highlighted)
        VDeleteButton.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        VDeleteButton.addTargetTo(self, action: #selector(deleteButtonAction(button:)), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(VDeleteButton)
        
    }
    
    @objc func imageTapAction() -> Void {
        MTTPrint("image tapped")
        MTTPrint("image index :\(VImageView.indexPath.item)")
        self.DDelegate?.dTappedImageView(indexPath: VImageView.indexPath)
    }
    
    func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.contentView)
        }
        
        VDeleteButton.snp.makeConstraints { (make) in
            make.top.equalTo(5)
            make.right.equalTo(-5)
            make.height.width.equalTo(32)
        }
    }
    
    @objc func deleteButtonAction(button: UIButton) -> Void {
        self.DDelegate?.dTappedDeleteButton(currentIndex: button.tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
