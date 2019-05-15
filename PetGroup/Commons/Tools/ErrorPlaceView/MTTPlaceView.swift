//
//  MTTPlaceView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/26.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit


/// 点击回调
protocol MTTPlaceViewDelegate {
    
    func dTapPlaceImageViewCallBack(_ placeView: MTTPlaceView) -> Void 
}

class MTTPlaceView: UIView {
    
    var DDelegate:MTTPlaceViewDelegate?
    
    private var titleLabel:UILabel!
    private var placeImageView:UIImageView!
    
    
    
    var title:String?{
        didSet{
            titleLabel.text = title
        }
    }
    
    var placeImageString:String?{
        didSet{
            placeImageView.image = UIImage(named: "placeImageString")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubviews(frame: frame)
    }
    
    private func pSetupSubviews(frame: CGRect) -> Void {
        placeImageView = UIImageView()
        placeImageView.isUserInteractionEnabled = true
        placeImageView.image = UIImage(named: "nodata_placeholder")
        placeImageView.frame = CGRect(x: (UIScreen.main.bounds.size.width - 180.0) / 2.0 - 20, y: (UIScreen.main.bounds.size.height - 215.0) / 2.0 - 80, width: 180.0, height: 215.0)
        self.addSubview(placeImageView)
        
        titleLabel = UILabel()
        titleLabel.numberOfLines = 0
        titleLabel.text = "糟糕,加载失败\n戳我重试"
        titleLabel.backgroundColor = UIColor.white.withAlphaComponent(0.9)
        titleLabel.layer.borderColor = UIColor.colorWithString(colorString: "#f2f2f2").cgColor
        titleLabel.layer.borderWidth = 1.0
        titleLabel.layer.cornerRadius = 10.0
        titleLabel.textColor = UIColor.colorWithString(colorString: "#999999")
        titleLabel.clipsToBounds = true
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 16)
        titleLabel.frame = CGRect(x: placeImageView.frame.maxX - 60, y: placeImageView.frame.minY, width: 160, height: 80)
        self.addSubview(titleLabel)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(placeImageViewTapAction))
        placeImageView.addGestureRecognizer(tapGes)
        
        
    }
    
    
    
    @objc func placeImageViewTapAction() -> Void {
        self.DDelegate?.dTapPlaceImageViewCallBack(self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
