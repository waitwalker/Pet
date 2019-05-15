//
//  MTTReportView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/10/16.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTReportViewDelegate {
    func dTappedCancelButton() -> Void
    func dTappedReportButton(model:MTTCircleModel, info:[String:Any]) -> Void
}

class MTTReportView: UIView {
    
    // 标题
    fileprivate var VTitleLabel:UILabel!
    fileprivate var VKeywordLabel:UILabel!
    
    // 关键词输入框
    var VKeywordTextField:UITextField!
    fileprivate var VReportContentLabel:UILabel!
    
    // 违规内容输入框
    var VReportContentTextView:UITextView!
    
    // 其他联系方式
    var VOtherContactLable:UILabel!
    
    // 取消按钮
    var VCancelButton:UIButton!
    
    // 举报按钮
    var VReportButton:UIButton!
    var DDelegate:MTTReportViewDelegate?
    var model:MTTCircleModel!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupLayer()
        pSetupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
        pSetupLayer()
    }
    
    private func pSetupLayer() -> Void {
        //定义渐变的颜色（从黄色渐变到橙色）
        let topColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.4)
        let buttomColor = UIColor(red: 41/255, green: 170/255, blue: 233/255, alpha: 0.8)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]
        
        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]
        
        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations
        
        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func pSetupSubviews() -> Void {
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        VTitleLabel = UILabel()
        VTitleLabel.text = "违规举报"
        VTitleLabel.textColor = UIColor.white
        VTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        VTitleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(VTitleLabel)
        
        VKeywordLabel = UILabel()
        VKeywordLabel.text = "请输入违规关键词,多个请用逗号(\"，\")隔开:"
        VKeywordLabel.textColor = kMainBlueColor()
        VKeywordLabel.font = UIFont.boldSystemFont(ofSize: 12)
        VKeywordLabel.textAlignment = NSTextAlignment.left
        self.addSubview(VKeywordLabel)
        
        VKeywordTextField = UITextField()
        VKeywordTextField.backgroundColor = UIColor.white
        VKeywordTextField.textAlignment = NSTextAlignment.left
        VKeywordTextField.font = UIFont.systemFont(ofSize: 15)
        VKeywordTextField.textColor = UIColor.black
        VKeywordTextField.placeholder = "违规关键词"
        VKeywordTextField.layer.borderColor = UIColor.white.cgColor
        VKeywordTextField.layer.borderWidth = 1.0
        VKeywordTextField.layer.cornerRadius = 5.0
        VKeywordTextField.clipsToBounds = true
        self.addSubview(VKeywordTextField)
        
        VReportContentLabel = UILabel()
        VReportContentLabel.text = "请输入违规内容:"
        VReportContentLabel.textColor = kMainBlueColor()
        VReportContentLabel.font = UIFont.boldSystemFont(ofSize: 12)
        VReportContentLabel.textAlignment = NSTextAlignment.left
        self.addSubview(VReportContentLabel)
        
        VReportContentTextView = UITextView()
        VReportContentTextView.textAlignment = NSTextAlignment.left
        VReportContentTextView.font = UIFont.systemFont(ofSize: 15)
        VReportContentTextView.textColor = UIColor.black
        VReportContentTextView.layer.borderColor = UIColor.white.cgColor
        VReportContentTextView.layer.borderWidth = 1.0
        VReportContentTextView.layer.cornerRadius = 5.0
        VReportContentTextView.clipsToBounds = true
        self.addSubview(VReportContentTextView)
        
        VOtherContactLable = UILabel()
        VOtherContactLable.text = "其它举报方式:waitwalker@163.com"
        VOtherContactLable.textColor = UIColor.white.withAlphaComponent(0.7)
        VOtherContactLable.font = UIFont.boldSystemFont(ofSize: 13)
        VOtherContactLable.textAlignment = NSTextAlignment.left
        self.addSubview(VOtherContactLable)
        
        VCancelButton = UIButton()
        VCancelButton.setTitle("取消", for: UIControl.State.normal)
        VCancelButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VCancelButton.setTitleColor(kMainBlueColor(), for: UIControl.State.highlighted)
        VCancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        VCancelButton.addTargetTo(self, action: #selector(cancelButtonAction(button:)), for: UIControl.Event.touchUpInside)
        VCancelButton.layer.borderColor = UIColor.white.cgColor
        VCancelButton.layer.borderWidth = 1.0
        VCancelButton.layer.cornerRadius = 5.0
        VCancelButton.clipsToBounds = true
        self.addSubview(VCancelButton)
        
        VReportButton = UIButton()
        VReportButton.setTitle("举报", for: UIControl.State.normal)
        VReportButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VReportButton.setTitleColor(kMainBlueColor(), for: UIControl.State.highlighted)
        VReportButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        VReportButton.addTargetTo(self, action: #selector(reportButtonAction(button:)), for: UIControl.Event.touchUpInside)
        VReportButton.layer.borderColor = UIColor.white.cgColor
        VReportButton.layer.borderWidth = 1.0
        VReportButton.layer.cornerRadius = 5.0
        VReportButton.clipsToBounds = true
        self.addSubview(VReportButton)
    }
    
    @objc func reportButtonAction(button:UIButton) -> Void {
        if (VReportContentTextView.text == nil || VReportContentTextView.text.count == 0) && (VKeywordTextField.text == nil || VKeywordTextField.text?.count == 0){
            self.toast(message: "请输入举报内容再试吧!")
            return
        }
        self.DDelegate?.dTappedReportButton(model: model, info: ["report_keyword" : VKeywordTextField.text as Any,"report_content":VReportContentTextView.text])
    }
    
    @objc func cancelButtonAction(button:UIButton) -> Void {
        self.DDelegate?.dTappedCancelButton()
    }
    
    private func pLayoutSubviews() -> Void {
        VTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(10)
            make.height.equalTo(30)
        }
        
        VKeywordLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(VTitleLabel)
            make.top.equalTo(VTitleLabel.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        VKeywordTextField.snp.makeConstraints { (make) in
            make.left.right.equalTo(VTitleLabel)
            make.top.equalTo(VKeywordLabel.snp.bottom).offset(10)
            make.height.equalTo(30)
        }
        
        VReportContentLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(VTitleLabel)
            make.top.equalTo(VKeywordTextField.snp.bottom).offset(10)
            make.height.equalTo(20)
        }
        
        VReportContentTextView.snp.makeConstraints { (make) in
            make.left.right.equalTo(VTitleLabel)
            make.top.equalTo(VReportContentLabel.snp.bottom).offset(10)
            make.height.equalTo(120)
        }
        
        VOtherContactLable.snp.makeConstraints { (make) in
            make.left.right.equalTo(VTitleLabel)
            make.height.equalTo(30)
            make.top.equalTo(VReportContentTextView.snp.bottom).offset(10)
        }
        
        VCancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(VTitleLabel)
            make.top.equalTo(VOtherContactLable.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
        
        VReportButton.snp.makeConstraints { (make) in
            make.right.equalTo(VTitleLabel)
            make.top.equalTo(VOtherContactLable.snp.bottom).offset(10)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
