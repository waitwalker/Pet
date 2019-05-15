//
//  MTTLaunchProgressView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/4.
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
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import UIKit
import SnapKit
import Kingfisher

// MARK: - ***************** class 分割线 ******************
class MTTLaunchProgressView: UIView {
    
    // MARK: - variable 变量 属性
    private var VImageView:UIImageView!
    private var VSkipButton:UIButton!
    private var timeCount:Int = 3
    
    private var timeQueue:DispatchQueue!
    private var sourceTimer:DispatchSourceTimer!
    
    var progressInterface:MTTProgressInterface!
    
    
    
    
    
    // MARK: - instance method 实例方法 
    init(frame:CGRect, info:[String:Any]?, progress:MTTProgressInterface) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.blue
        pSetupSubviews(info:info, progress:progress)
        pSetupTimerSource()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
    
    private func pSetupSubviews(info:[String:Any]?, progress:MTTProgressInterface) -> Void {
        self.progressInterface = progress
        
        let image = UIImage(named: "ad")
        VImageView = UIImageView()
        VImageView.image = image
        VImageView.isUserInteractionEnabled = true
        self.addSubview(VImageView)
        
        
        let download_url = URL(string: "http://pa78d7kmx.bkt.clouddn.com/my_ad")
        
        if MTTUserInfoManager.sharedUserInfo.shouldLoadNewAd {
            VImageView.kf.setImage(with: download_url, placeholder: image, options: [.transition(ImageTransition.fade(0.3))], progressBlock: { (receiveSize, totalSize) in
                
            }) { (image, error, catchType, url) in
                if let img = image {
                    if let imageData = img.pngData() {
                        let fullPath = NSHomeDirectory().appending("/Documents/").appending("ad")
                        let queue = DispatchQueue(label: "queue")
                        queue.async {
                            try! imageData.write(to: URL(fileURLWithPath: fullPath))
                        }
                    }
                }
            }
        } else {
            let fullPath = NSHomeDirectory().appending("/Documents/").appending("ad")
            if let ima = UIImage(contentsOfFile: fullPath) {
                VImageView.image = ima
            } else {
                VImageView.image = image
            }
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedImageAction))
        VImageView.addGestureRecognizer(tapGesture)
        
        VSkipButton = UIButton()
        VSkipButton.setTitle("跳过 3", for: UIControl.State.normal)
        VSkipButton.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        VSkipButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VSkipButton.layer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
        VSkipButton.layer.cornerRadius = 5
        VSkipButton.clipsToBounds = true
        VSkipButton.addTarget(self, action: #selector(skipButtonAction), for: UIControl.Event.touchUpInside)
        self.addSubview(VSkipButton)
        
    }
    
    private func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self)
        }
        
        VSkipButton.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.right.equalTo(-35)
            make.height.equalTo(25)
            make.width.equalTo(50)
        }
    }
    
    @objc func skipButtonAction() -> Void {
        self.sourceTimer.cancel()
        self.progressInterface.iTappedSkipButtonAction(info: ["progressModel":"model"])
    }
    
    @objc func tappedImageAction() -> Void {
        self.sourceTimer.cancel()
        self.progressInterface.iTappedImageAction(info: ["progressModel":"model"])
    }
    
    /// 设置倒计时 
    private func pSetupTimerSource() -> Void {
        timeQueue = DispatchQueue(
            label: "codeQueue")
        sourceTimer = DispatchSource.makeTimerSource(
            flags: DispatchSource.TimerFlags.strict, 
            queue: timeQueue)
        
        sourceTimer.schedule(
            deadline: DispatchTime.now(), 
            repeating: DispatchTimeInterval.seconds(1))
        sourceTimer.setEventHandler(handler: {
            self.timeCount -= 1
            if self.timeCount <= 0
            {
                self.sourceTimer.cancel()
                DispatchQueue.main.async {
                    self.progressInterface.iTappedSkipButtonAction(info: ["progressModel":"model"])
                }
            } else {
                DispatchQueue.main.async {
                    self.VSkipButton.setTitle("跳过 " + String(self.timeCount), for: UIControl.State.normal)
                }
            }
        })
        
        sourceTimer.resume()
    }
    
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}
