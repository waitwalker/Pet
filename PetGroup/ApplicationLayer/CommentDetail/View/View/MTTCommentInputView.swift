//
//  MTTCommentInputView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/11/27.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTCommentInputViewDelegate {
    
    
    /// 提交按钮点击回调
    ///
    /// - Parameter info: info
    /// - Returns: void
    func pTappedCommitButton(info:[String:Any]?) -> Void
    
    
    /// 取消按钮点击回调
    ///
    /// - Parameter info: info
    /// - Returns: void
    func pTappedCancelButton(info:[String:Any]?) -> Void
}

class MTTCommentInputView: UIView {
    
    fileprivate var VBackgroundView:UIView!
    fileprivate var VContainerView:UIView!
    fileprivate var VTitleLabel:UILabel!
    
    open var VTextView:UITextView!
    fileprivate var VCancelButton:UIButton!
    fileprivate var VCommitButton:UIButton!
    var DDlegate:MTTCommentInputViewDelegate?
    
    
    
    
    init(superView:UIView) {
        super.init(frame: CGRect.zero)
        superView.addSubview(self)
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
        VBackgroundView = UIView()
        VBackgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.addSubview(VBackgroundView)
        
        VContainerView = UIView()
        VContainerView.backgroundColor = UIColor.white
        VContainerView.layer.cornerRadius = 20
        VContainerView.clipsToBounds = true
        VBackgroundView.addSubview(VContainerView)
        
        VTitleLabel = UILabel()
        VTitleLabel.text = "写评论"
        VTitleLabel.textAlignment = NSTextAlignment.center
        VTitleLabel.backgroundColor = kLightBlueColor()
        VTitleLabel.textColor = UIColor.white
        VTitleLabel.font = UIFont.boldSystemFont(ofSize: 17)
        VContainerView.addSubview(VTitleLabel)
        
        VTextView = UITextView()
        VTextView.textColor = UIColor.black
        VTextView.font = UIFont.systemFont(ofSize: 15)
        VTextView.layer.cornerRadius = 5
        VTextView.clipsToBounds = true
        VTextView.layer.borderColor = kLightBlueColor().cgColor
        VTextView.layer.borderWidth = 0.5
        VContainerView.addSubview(VTextView)
        
        VCancelButton = UIButton()
        VCancelButton.setTitle("取消", for: UIControl.State.normal)
        VCancelButton.setTitleColor(kLightBlueColor(), for: UIControl.State.normal)
        VCancelButton.layer.cornerRadius = 5.0
        VCancelButton.clipsToBounds = true
        VCancelButton.layer.borderColor = kLightBlueColor().cgColor
        VCancelButton.layer.borderWidth = 0.5
        VCancelButton.addTargetTo(self, action: #selector(cancelButtonAction), for: UIControl.Event.touchUpInside)
        VContainerView.addSubview(VCancelButton)
        
        VCommitButton = UIButton()
        VCommitButton.setTitle("提交", for: UIControl.State.normal)
        VCommitButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VCommitButton.setBackgroundImage(UIImage.imageWithColor(color: kLightBlueColor()), for: UIControl.State.normal)
        VCommitButton.layer.cornerRadius = 5.0
        VCommitButton.clipsToBounds = true
        VCommitButton.addTargetTo(self, action: #selector(commitButtonAction), for: UIControl.Event.touchUpInside)
        VContainerView.addSubview(VCommitButton)
    }
    
    @objc func cancelButtonAction() -> Void {
        self.DDlegate?.pTappedCancelButton(info: nil)
    }
    
    @objc func commitButtonAction() -> Void {
        let inf:[String:Any] = ["content":VTextView.text]
        self.DDlegate?.pTappedCommitButton(info: inf)
    }
    
    private func pLayoutSubviews() -> Void {
        VBackgroundView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        VContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(kScreenHeight * 0.55)
            make.centerY.equalTo(VBackgroundView)
        }
        
        VTitleLabel.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(44)
        }
        
        VCancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.width.equalTo(((kScreenWidth - 60) - 30) / 2)
            make.bottom.equalTo(-20)
            make.height.equalTo(44)
        }
        
        VCommitButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.width.height.bottom.equalTo(VCancelButton)
        }
        
        VTextView.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.top.equalTo(VTitleLabel.snp.bottom).offset(10)
            make.bottom.equalTo(VCancelButton.snp.top).offset(-10)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
