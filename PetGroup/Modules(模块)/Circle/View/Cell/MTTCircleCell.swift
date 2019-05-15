//
//  MTTCircleCell.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/23.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol MTTCircleCellDelegate {
    func dTappedFirstButton(button:UIButton, model:MTTCircleModel) -> Void
    func dTappedSecondButton(button:UIButton, model:MTTCircleModel) -> Void
    func dTappedThirdButton(button:UIButton, model:MTTCircleModel) -> Void
    func dTappedImage(currentIndex:Int, model:MTTCircleModel) -> Void
}

class MTTCircleCell: UITableViewCell {
    
    private var VMarginView:UIView!
    private var VAvatarImageView:UIImageView!
    private var VUsernameLabel:UILabel!
    private var VTimeLabel:UILabel!
    private var VContentLabel:UILabel!
    private var VCommentedButton:UIButton!
    private var VLikedButton:UIButton!
    private var VSharedButton:UIButton!
    private var VPhotoListView:MTTPhotoListView!
    private var VBottomLineView:UIView!
    var DDelegate:MTTCircleCellDelegate!
    
    
    var model:MTTCircleModel? {
        didSet{
            pLayoutSubviews(model: model!)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        pSetupSubviews()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func pSetupSubviews() -> Void {
        VMarginView = UIView()
        VMarginView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.contentView.addSubview(VMarginView)
        
        VAvatarImageView = UIImageView()
        VAvatarImageView.layer.borderColor = UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.5).cgColor
        VAvatarImageView.layer.borderWidth = 0.5
        VAvatarImageView.isUserInteractionEnabled = true
        VAvatarImageView.layer.cornerRadius = 25
        VAvatarImageView.clipsToBounds = true
        self.contentView.addSubview(VAvatarImageView)
        
        VUsernameLabel = UILabel()
        VUsernameLabel.text = "axggxs"
        VUsernameLabel.textColor = UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.8)
        VUsernameLabel.font = UIFont.systemFont(ofSize: 16)
        VUsernameLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(VUsernameLabel)
        
        VTimeLabel = UILabel()
        VTimeLabel.text = "1小时前"
        VTimeLabel.textColor = kG7
        VTimeLabel.font = UIFont.systemFont(ofSize: 10)
        VTimeLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(VTimeLabel)
        
        VContentLabel = UILabel()
        VContentLabel.text = ""
        VContentLabel.textColor = UIColor.black
        VContentLabel.font = UIFont.systemFont(ofSize: 17)
        VContentLabel.textAlignment = NSTextAlignment.left
        VContentLabel.numberOfLines = 0
        self.contentView.addSubview(VContentLabel)
        
        VPhotoListView = MTTPhotoListView()
        VPhotoListView.isUserInteractionEnabled = true
        VPhotoListView.DDelegate = self
        self.contentView.addSubview(VPhotoListView)
        
        VBottomLineView = UIView()
        VBottomLineView.backgroundColor = UIColor.colorWithString(colorString: "#3399ff").withAlphaComponent(0.8)
        self.contentView.addSubview(VBottomLineView)
        
        VCommentedButton = UIButton()
        VCommentedButton.tag = 0
        VCommentedButton.setImage(UIImage.image(imageString:"comment_highlighted"), for: UIControl.State.normal)
        VCommentedButton.setImage(UIImage.image(imageString:"comment_normal"), for: UIControl.State.highlighted)
        VCommentedButton.addTargetTo(self, action: #selector(commentButtonAction(_:)), for: UIControl.Event.touchUpInside)
        VCommentedButton.setTitleColor(kLightBlueColor(), for: UIControl.State.normal)
        VCommentedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(VCommentedButton)
        
        VSharedButton = UIButton()
        VSharedButton.tag = 1
        VSharedButton.setImage(UIImage.image(imageString:"praise_normal"), for: UIControl.State.normal)
        VSharedButton.addTargetTo(self, action: #selector(shareButtonAction(_:)), for: UIControl.Event.touchUpInside)
        VSharedButton.setTitleColor(kLightBlueColor(), for: UIControl.State.normal)
        VSharedButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        self.contentView.addSubview(VSharedButton)
        
        VLikedButton = UIButton()
        VLikedButton.tag = 2
        VLikedButton.setImage(UIImage.image(imageString: "like"), for: UIControl.State.normal)
        VLikedButton.setImage(UIImage.image(imageString: "like_highlight"), for: UIControl.State.highlighted)
        VLikedButton.addTargetTo(self, action: #selector(likeButtonAction(_:)), for: UIControl.Event.touchUpInside)
        self.contentView.addSubview(VLikedButton)
    }
    
    @objc func commentButtonAction(_ button:UIButton) -> Void {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameAnimation.values = [0.5, 1.0, 1.8, 1.6, 1.2, 1.0]
        keyFrameAnimation.keyTimes = [0.0, 0.5, 0.8, 1.0]
        keyFrameAnimation.calculationMode = CAAnimationCalculationMode.linear
        button.imageView?.layer.add(keyFrameAnimation, forKey: "an")
        self.DDelegate.dTappedFirstButton(button: button, model: model!)
    }
    
    @objc func shareButtonAction(_ button:UIButton) -> Void {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameAnimation.values = [0.5, 1.0, 1.8, 1.6, 1.2, 1.0]
        keyFrameAnimation.keyTimes = [0.0, 0.5, 0.8, 1.0]
        keyFrameAnimation.calculationMode = CAAnimationCalculationMode.linear
        button.imageView?.layer.add(keyFrameAnimation, forKey: "an")
        self.DDelegate.dTappedSecondButton(button: button, model: model!)
    }
    
    @objc func likeButtonAction(_ button: UIButton) -> Void {
        let keyFrameAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyFrameAnimation.values = [0.5, 1.0, 1.8, 1.6, 1.2, 1.0]
        keyFrameAnimation.keyTimes = [0.0, 0.5, 0.8, 1.0]
        keyFrameAnimation.calculationMode = CAAnimationCalculationMode.linear
        button.imageView?.layer.add(keyFrameAnimation, forKey: "an")
        self.DDelegate.dTappedThirdButton(button: button, model: model!)
    }
    
    private func pLayoutSubviews(model: MTTCircleModel) -> Void {
        
        if model.header_photo.count > 0 {
            VAvatarImageView.kf.setImage(with: URL(string: kQiNiuServer + model.header_photo), placeholder: UIImage.image(imageString: "avatar_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (rec, tol) in
                MTTPrint("头像 下载进度:\(rec/tol)")
            }) { (result) in
                switch result {
                case .success(let value):
                    print("Task done for: \(value.source.url?.absoluteString ?? "")")
                    break
                case .failure(let error):
                    print("Job failed: \(error.localizedDescription)")
                    break
                }
            }
        } else {
            VAvatarImageView.image = UIImage.image(imageString: "avatar_placeholder")
        }
        
        VUsernameLabel.text = model.username
        
        VTimeLabel.text = model.time
        
        VMarginView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: kCircleCellTopMarginHeight)
        
        VAvatarImageView.frame = CGRect(x: 20, y: VMarginView.frame.maxY + 10, width: 50, height: 50)
        
        VUsernameLabel.frame = CGRect(x: VAvatarImageView.frame.maxX + 15, y: VMarginView.frame.maxY + kCircleCellUsernameTopMarginHeight, width: kScreenWidth - (VMarginView.frame.maxY + kCircleCellUsernameTopMarginHeight), height: kCircleCellUsernameHeight)
        
        VTimeLabel.frame = CGRect(x: VUsernameLabel.x + 8.0, y: VUsernameLabel.frame.maxY + kCircleCellTopMarginHeight, width: VUsernameLabel.width, height: kCircleCellTimeHeight)
        
        var kBottomYValue:CGFloat = 0.0
        switch model.dynamic_Type {
            
            // 只有文本
        case .onlyContent:
            VPhotoListView.isHidden = true
            VContentLabel.isHidden = false
            VContentLabel.text = model.content
            VContentLabel.frame = CGRect(x: VUsernameLabel.x, y: VTimeLabel.frame.maxY + kCircleCellContentTopHeight, width: kScreenWidth - (VUsernameLabel.x + 15), height: model.contentTextHeight)
            VPhotoListView.frame = CGRect.zero
            kBottomYValue = VContentLabel.frame.maxY + 10.0
            
            // 文本和图片
        case .contentAndImage:
            VPhotoListView.isHidden = false
            VContentLabel.isHidden = false
            VContentLabel.text = model.content
            VContentLabel.frame = CGRect(x: VUsernameLabel.x, y: VTimeLabel.frame.maxY + kCircleCellContentTopHeight, width: kScreenWidth - (VUsernameLabel.x + 15), height: model.contentTextHeight)
            VPhotoListView.frame = CGRect(x: VContentLabel.x, y: VContentLabel.frame.maxY + kCircleCellImageTopMarginHeight, width: VContentLabel.width, height: model.contentImageHeight)
            kBottomYValue = VPhotoListView.frame.maxY + 10.0
            VPhotoListView.ODataSource = model
            
            // 只有图片
        case .onlyImage:
            VPhotoListView.isHidden = false
            VContentLabel.isHidden = true
            VContentLabel.frame = CGRect.zero
            VPhotoListView.frame = CGRect(x: VUsernameLabel.x, y: VTimeLabel.frame.maxY + kCircleCellContentTopHeight, width: kScreenWidth - (VUsernameLabel.x + 15), height: model.contentImageHeight)
            VPhotoListView.ODataSource = model
            kBottomYValue = VPhotoListView.frame.maxY + 10.0
            
            // 文本和视频
        case .contentAndVideo:
            VPhotoListView.isHidden = true
            VContentLabel.isHidden = false
            
            // 只有视频
        case .onlyVideo:
            VPhotoListView.isHidden = true
            VContentLabel.isHidden = true
        }
        
        VBottomLineView.frame = CGRect(x: VUsernameLabel.x, y: kBottomYValue - 5.0, width: kScreenWidth - VUsernameLabel.x - 20.0 - 20.0, height: 0.8)
        
        // 评论数量
        if model.commentNum.count > 0 {
            let commentNum = Int(model.commentNum)
            if commentNum! > 0 {
                VCommentedButton.setTitle("  " + model.commentNum, for: UIControl.State.normal)
            } else {
                VCommentedButton.setTitle("", for: UIControl.State.normal)
            }
        } else {
            VCommentedButton.setTitle("", for: UIControl.State.normal)
        }
        
        // 点赞数量
        if model.isPraise == true {
            let praiseNum = Int(model.praiseNum)
            if praiseNum! > 0 {
                VSharedButton.setTitle("" + model.praiseNum, for: UIControl.State.normal)
                VSharedButton.setImage(UIImage.image(imageString:"praise_normal"), for: UIControl.State.normal)
            } else {
                VSharedButton.setTitle("", for: UIControl.State.normal)
                VSharedButton.setImage(UIImage.image(imageString:"praise_highlighted"), for: UIControl.State.normal)
            }
        } else {
            let praiseNum = Int(model.praiseNum)
            if praiseNum != nil && praiseNum! > 0 {
                VSharedButton.setTitle("" + model.praiseNum, for: UIControl.State.normal)
            } else {
                VSharedButton.setTitle("", for: UIControl.State.normal)
            }
            VSharedButton.setImage(UIImage.image(imageString:"praise_highlighted"), for: UIControl.State.normal)
        }
        
        VCommentedButton.frame = CGRect(x: VUsernameLabel.x + 20.0, y: kBottomYValue, width: 60.0, height: 24.0)
        
        VCommentedButton.sizeToFit()
        VLikedButton.frame = CGRect(x: kScreenWidth - 30.0 - 20.0 - 20.0, y: kBottomYValue, width: VCommentedButton.width, height: VCommentedButton.height)
        VSharedButton.frame = CGRect(x: (kScreenWidth - 16.0 - 20.0 + VUsernameLabel.x) / 2.0, y: kBottomYValue, width: 60.0, height: 24.0)
        VSharedButton.sizeToFit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension MTTCircleCell: MTTPhotoListViewDelegate {
    func pTappedImage(currentIndex: Int) {
        self.DDelegate.dTappedImage(currentIndex: currentIndex, model: self.model!)
    }
}
