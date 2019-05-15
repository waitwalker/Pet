
//
//  MTTPopularCell.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/20.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation
import UIKit

protocol MTTPopularCellDelegate {
    func dTappedPopularImage(index:Int) -> Void
}

class MTTPopularCell: UICollectionViewCell {
    
    var VContainerView:UIView!
    
    var VImageView:UIImageView!
    var VTitleLabel:UILabel!
    
    var DDelegate:MTTPopularCellDelegate?
    
    var model:MTTPopularScienceModel? {
        didSet{
            if let the_model = model {
                pLayoutSubviews(model: the_model)
                VImageView.image = UIImage.image(imageString: the_model.name)
                VTitleLabel.text = the_model.name
            }
        }
    }
    
    
    
    
    func pSetupSubview() -> Void {
        VContainerView = UIView()
        VContainerView.backgroundColor = UIColor.white
        VContainerView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").cgColor
        VContainerView.layer.borderWidth = 0.5
        VContainerView.layer.cornerRadius = 6.0
        VContainerView.clipsToBounds = true
        self.contentView.addSubview(VContainerView)
        
        VImageView = UIImageView()
        VImageView.backgroundColor = UIColor.random
        VImageView.isUserInteractionEnabled = true
        VContainerView.addSubview(VImageView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        VImageView.addGestureRecognizer(tapGes)
        
        
        VTitleLabel = UILabel()
        VTitleLabel.textColor = UIColor.black
        VTitleLabel.textAlignment = NSTextAlignment.center
        VTitleLabel.font = UIFont.systemFont(ofSize: 17)
        VContainerView.addSubview(VTitleLabel)
    }
    
    func pLayoutSubviews(model:MTTPopularScienceModel) -> Void {
        VContainerView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.contentView)
            make.height.equalTo(180)
        }
        
        VImageView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(150)
        }
        
        VTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo(0)
            make.height.equalTo(30)
        }
    }
    
    @objc func tapGestureAction() -> Void {
        MTTPrint("点击进入详情")
        self.DDelegate?.dTappedPopularImage(index: VImageView.indexPath.item)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
