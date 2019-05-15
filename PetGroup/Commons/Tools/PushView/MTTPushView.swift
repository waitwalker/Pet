//
//  MTTPushView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/12/27.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTPushViewDelegate {
    func dTappedCancelButton() -> Void
    func dTappedPushButton(info:[String:Any]) -> Void
}


class MTTPushView: UIView {

    /**
     title = self.get_argument("title")
     subtitle = self.get_argument("subtitle")
     description = self.get_argument("description")
     push_body = self.get_argument("body")
     production_mode = self.get_argument("production_mode")
     */
    // 标题
    fileprivate var VTitleLabel:UILabel!
    fileprivate var VDescriptionLabel:UILabel!
    fileprivate var VDescriptionTextField:UITextField!
    fileprivate var VPushTitleLabel:UILabel!
    fileprivate var VPushTitleTextField:UITextField!
    fileprivate var VPushSubtitleLabel:UILabel!
    fileprivate var VPushSubtitleTextField:UITextField!
    fileprivate var VPushBodyLabel:UILabel!
    fileprivate var VPushBodyTextView:UITextView!
    fileprivate var VPushProductionModeLabel:UILabel!
    fileprivate var VPushProductionSwitch:UISwitch!
    fileprivate var VCancelButton:UIButton!
    fileprivate var VPushButton:UIButton!
    var DDelegate:MTTPushViewDelegate?
    var isProduction:String = "false"

    
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
        VTitleLabel.text = "推送"
        VTitleLabel.textColor = UIColor.white
        VTitleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        VTitleLabel.textAlignment = NSTextAlignment.center
        self.addSubview(VTitleLabel)
        
        VDescriptionLabel = UILabel()
        VDescriptionLabel.text = "描述:"
        VDescriptionLabel.textColor = kMainBlueColor()
        VDescriptionLabel.font = UIFont.boldSystemFont(ofSize: 16)
        VDescriptionLabel.textAlignment = NSTextAlignment.left
        self.addSubview(VDescriptionLabel)
        
        VDescriptionTextField = UITextField()
        VDescriptionTextField.backgroundColor = UIColor.white
        VDescriptionTextField.textAlignment = NSTextAlignment.left
        VDescriptionTextField.font = UIFont.systemFont(ofSize: 12)
        VDescriptionTextField.textColor = UIColor.black
        VDescriptionTextField.placeholder = "输入描述(必填)"
        VDescriptionTextField.layer.borderColor = UIColor.white.cgColor
        VDescriptionTextField.layer.borderWidth = 1.0
        VDescriptionTextField.layer.cornerRadius = 5.0
        VDescriptionTextField.clipsToBounds = true
        self.addSubview(VDescriptionTextField)

        VPushTitleLabel = UILabel()
        VPushTitleLabel.text = "标题:"
        VPushTitleLabel.textColor = kMainBlueColor()
        VPushTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        VPushTitleLabel.textAlignment = NSTextAlignment.left
        self.addSubview(VPushTitleLabel)

        VPushTitleTextField = UITextField()
        VPushTitleTextField.backgroundColor = UIColor.white
        VPushTitleTextField.textAlignment = NSTextAlignment.left
        VPushTitleTextField.font = UIFont.systemFont(ofSize: 12)
        VPushTitleTextField.textColor = UIColor.black
        VPushTitleTextField.placeholder = "输入推送标题(非必填)"
        VPushTitleTextField.layer.borderColor = UIColor.white.cgColor
        VPushTitleTextField.layer.borderWidth = 1.0
        VPushTitleTextField.layer.cornerRadius = 5.0
        VPushTitleTextField.clipsToBounds = true
        self.addSubview(VPushTitleTextField)

        VPushSubtitleLabel = UILabel()
        VPushSubtitleLabel.text = "副标题:"
        VPushSubtitleLabel.textColor = kMainBlueColor()
        VPushSubtitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        VPushSubtitleLabel.textAlignment = NSTextAlignment.left
        self.addSubview(VPushSubtitleLabel)

        VPushSubtitleTextField = UITextField()
        VPushSubtitleTextField.backgroundColor = UIColor.white
        VPushSubtitleTextField.textAlignment = NSTextAlignment.left
        VPushSubtitleTextField.font = UIFont.systemFont(ofSize: 12)
        VPushSubtitleTextField.textColor = UIColor.black
        VPushSubtitleTextField.placeholder = "输入推送副标题(非必填)"
        VPushSubtitleTextField.layer.borderColor = UIColor.white.cgColor
        VPushSubtitleTextField.layer.borderWidth = 1.0
        VPushSubtitleTextField.layer.cornerRadius = 5.0
        VPushSubtitleTextField.clipsToBounds = true
        self.addSubview(VPushSubtitleTextField)
        
        VPushBodyTextView = UITextView()
        VPushBodyTextView.textAlignment = NSTextAlignment.left
        VPushBodyTextView.font = UIFont.systemFont(ofSize: 12)
        VPushBodyTextView.textColor = UIColor.black
        VPushBodyTextView.layer.borderColor = UIColor.white.cgColor
        VPushBodyTextView.layer.borderWidth = 1.0
        VPushBodyTextView.layer.cornerRadius = 5.0
        VPushBodyTextView.clipsToBounds = true
        self.addSubview(VPushBodyTextView)

        VPushBodyLabel = UILabel()
        VPushBodyLabel.text = "推送内容(必填)"
        VPushBodyLabel.textColor = UIColor.lightGray.withAlphaComponent(0.5)
        VPushBodyLabel.font = UIFont.boldSystemFont(ofSize: 12)
        VPushBodyLabel.textAlignment = NSTextAlignment.left
        VPushBodyTextView.addSubview(VPushBodyLabel)
        
        VPushProductionModeLabel = UILabel()
        VPushProductionModeLabel.text = "是否生产?"
        VPushProductionModeLabel.textColor = kMainBlueColor()
        VPushProductionModeLabel.font = UIFont.boldSystemFont(ofSize: 15)
        VPushProductionModeLabel.textAlignment = NSTextAlignment.left
        self.addSubview(VPushProductionModeLabel)

        VPushProductionSwitch = UISwitch()
        VPushProductionSwitch.addTarget(self, action: #selector(switchAction(switch_:)), for: UIControl.Event.touchUpInside)
        self.addSubview(VPushProductionSwitch)
        
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
        
        VPushButton = UIButton()
        VPushButton.setTitle("推送", for: UIControl.State.normal)
        VPushButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VPushButton.setTitleColor(kMainBlueColor(), for: UIControl.State.highlighted)
        VPushButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        VPushButton.addTargetTo(self, action: #selector(pushButtonAction(button:)), for: UIControl.Event.touchUpInside)
        VPushButton.layer.borderColor = UIColor.white.cgColor
        VPushButton.layer.borderWidth = 1.0
        VPushButton.layer.cornerRadius = 5.0
        VPushButton.clipsToBounds = true
        self.addSubview(VPushButton)
    }

    @objc func switchAction(switch_: UISwitch) -> Void {
        if switch_.isOn {
            isProduction = "true"
        } else {
            isProduction = "false"
        }
    }
    
    @objc func pushButtonAction(button:UIButton) -> Void {
        if (VPushBodyTextView.text == nil || VPushBodyTextView.text.count == 0) && (VDescriptionTextField.text == nil || VDescriptionTextField.text?.count == 0){
            self.toast(message: "请输入必填项,然后再试吧!")
            return
        }
        self.DDelegate?.dTappedPushButton(info: ["description":VDescriptionTextField.text!,"title":self.VPushTitleLabel.text!,"subtitle":self.VPushSubtitleTextField.text!,"body":self.VPushBodyTextView.text!,"production_mode":isProduction])
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
        
        VDescriptionLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(40)
            make.top.equalTo(VTitleLabel.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        VDescriptionTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VDescriptionLabel.snp.right).offset(5)
            make.right.equalTo(-20)
            make.centerY.equalTo(VDescriptionLabel)
            make.height.equalTo(30)
        }

        VPushTitleLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(VDescriptionLabel)
            make.top.equalTo(VDescriptionTextField.snp.bottom).offset(20)
            make.width.equalTo(40)
        }

        VPushTitleTextField.snp.makeConstraints { (make) in
            make.right.height.equalTo(VDescriptionTextField)
            make.left.equalTo(VPushTitleLabel.snp.right).offset(5)
            make.centerY.equalTo(VPushTitleLabel)
        }

        VPushSubtitleLabel.snp.makeConstraints { (make) in
            make.left.height.equalTo(VDescriptionLabel)
            make.top.equalTo(VPushTitleTextField.snp.bottom).offset(20)
            make.width.equalTo(55)
        }

        VPushSubtitleTextField.snp.makeConstraints { (make) in
            make.right.height.equalTo(VDescriptionTextField)
            make.left.equalTo(VPushSubtitleLabel.snp.right).offset(5)
            make.centerY.equalTo(VPushSubtitleLabel)
        }

        VPushProductionModeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.width.equalTo(70)
            make.height.equalTo(30)
            make.top.equalTo(VPushSubtitleTextField.snp.bottom).offset(10)
        }

        VPushProductionSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(VPushProductionModeLabel.snp.right).offset(30)
            make.height.equalTo(30)
            make.centerY.equalTo(VPushProductionModeLabel)
            make.width.equalTo(60)
        }

        VPushBodyTextView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(VPushProductionModeLabel.snp.bottom).offset(10)
            make.height.equalTo(80)
        }

        VPushBodyTextView.setValue(VPushBodyLabel, forKey: "_placeholderLabel")

        VCancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.top.equalTo(VPushBodyTextView.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }

        VPushButton.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(VPushBodyTextView.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.width.equalTo(120)
        }
    }
    
    // MARK: - 清空变量缓存
    func clearInstanceCache() -> Void {
        VDescriptionTextField.text = ""
        VPushTitleTextField.text = ""
        VPushSubtitleTextField.text = ""
        VPushBodyTextView.text = ""
        if self.VPushProductionSwitch.isOn {
            self.VPushProductionSwitch.sendActions(for: UIControl.Event.touchUpInside)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
