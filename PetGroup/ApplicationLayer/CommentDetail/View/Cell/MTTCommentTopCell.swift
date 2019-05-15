//
//  MTTCommentTopCell.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/11/27.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

protocol MTTCommentTopCellDelegate {
    func dTappedImage(currentIndex:Int, model:MTTCircleModel) -> Void
}

class MTTCommentTopCell: UITableViewCell {
    
    private var VMarginView:UIView!
    private var VAvatarImageView:UIImageView!
    private var VUsernameLabel:UILabel!
    private var VTimeLabel:UILabel!
    private var VContentLabel:UILabel!
    private var VPhotoListView:MTTPhotoListView!
    private var VBottomLineView:UIView!
    private var VBottomMarginView:UIView!
    
    var DDelegate:MTTCommentTopCellDelegate!
    
    
    
    
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
        
        VBottomMarginView = UIView()
        VBottomMarginView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
        self.contentView.addSubview(VBottomMarginView)
    }
    
    private func pLayoutSubviews(model: MTTCircleModel) -> Void {
        
        if model.header_photo.count > 0 {
            VAvatarImageView.kf.setImage(with: URL(string: kQiNiuServer + model.header_photo), placeholder: UIImage.image(imageString: "avatar_placeholder"), options: [.transition(ImageTransition.fade(1))], progressBlock: { (receivedSize, totalSize) in
                MTTPrint("头像 下载进度:\(receivedSize/totalSize)")
            }) { (img, error, cacheType, url) in
                MTTPrint("头像 cacheType:\(cacheType)")
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
        
        VBottomMarginView.frame = CGRect(x: 0, y: VBottomLineView.frame.maxY + 5, width: kScreenWidth, height: 10)
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

extension MTTCommentTopCell: MTTPhotoListViewDelegate {
    func pTappedImage(currentIndex: Int) {
        self.DDelegate.dTappedImage(currentIndex: currentIndex, model: self.model!)
    }
}
