//
//  MTTCardCell.swift
//  Bedrock
//
//  Created by junzi on 2018/4/5.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

/**
    卡片基类
 */


import UIKit

@available(iOS 11.0, *)
protocol MTTIconImageViewDelegate {
    func tappedIconImageView() -> Void
    func tappedPersonalIconImageView() -> Void
}

@available(iOS 11.0, *)
class MTTCardCell: UITableViewCell {

    var dateLabel:UILabel!
    var bedrockLabel:UILabel!
    var bedrockIconImageView:UIImageView!
    var backImageView:UIImageView!
    var personalImageView:UIImageView!
    
    
    var delegate:MTTIconImageViewDelegate?
    
    
    var titleLable:UILabel!
    
    let images:[String] = ["https://source.unsplash.com/random/600x800","https://source.unsplash.com/collection/190727/800x600","https://source.unsplash.com/daily","https://source.unsplash.com/daily","https://source.unsplash.com/weekly?water","https://source.unsplash.com/random/700x900","https://source.unsplash.com/random/500x700"]
    
    
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        setupSubview()
        
    }
    
    func setupSubview() -> Void
    {
        dateLabel = UILabel()
        dateLabel.text = Date().currentMoonDay() + " " + Date().weekDay()
        dateLabel.textColor = kG8.withAlphaComponent(0.7)
        dateLabel.textAlignment = NSTextAlignment.left
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        self.contentView.addSubview(dateLabel)
        
        bedrockLabel = UILabel()
        bedrockLabel.textColor = UIColor.colorWithString(colorString: "#3399ff")
        bedrockLabel.attributedText = bedrockString()
        bedrockLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(bedrockLabel)
        
        bedrockIconImageView = UIImageView()
        bedrockIconImageView.isUserInteractionEnabled = true
        bedrockIconImageView.image = UIImage.image(imageString: "icon_placeholder")
        bedrockIconImageView.layer.cornerRadius = 20
        bedrockIconImageView.clipsToBounds = true
        bedrockIconImageView.layer.borderColor = kMainBlueColor().cgColor
        bedrockIconImageView.layer.borderWidth = 0.5
        self.contentView.addSubview(bedrockIconImageView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGesAction))
        bedrockIconImageView.addGestureRecognizer(tapGes)
        
        personalImageView = UIImageView()
        personalImageView.isUserInteractionEnabled = true
        personalImageView.layer.cornerRadius = 20
        personalImageView.clipsToBounds = true
        personalImageView.layer.borderColor = kMainBlueColor().cgColor
        personalImageView.layer.borderWidth = 0.5
        self.contentView.addSubview(personalImageView)
        
        if MTTUserInfoManager.sharedUserInfo.header_photo.count < 1 {
            if MTTUserInfoManager.sharedUserInfo.headerImage != nil {
                personalImageView.image = MTTUserInfoManager.sharedUserInfo.headerImage
            } else {
                personalImageView.image = UIImage.image(imageString: "avatar_placeholder")
            }
        } else {

            personalImageView.kf.setImage(with:  URL(string: kQiNiuServer + MTTUserInfoManager.sharedUserInfo.header_photo), placeholder: UIImage.image(imageString: "avatar_placeholder"), options: [.cacheOriginalImage], progressBlock: { (receiveSize, totalSize) in

            }) { (result) in
                switch result{
                case .success(let value):
                    MTTPrint("value:\(value)")
                    break

                case .failure(let error):
                    print("\(error.localizedDescription)")
                    break
                }
            }
        }
        
        let pTapGes = UITapGestureRecognizer(target: self, action: #selector(pTapGesAction))
        personalImageView.addGestureRecognizer(pTapGes)
        
        backImageView = UIImageView()
        backImageView.isUserInteractionEnabled = true
        backImageView.layer.cornerRadius = 20
        backImageView.clipsToBounds = true
        self.contentView.addSubview(backImageView)
        
        let randomNum = Int(arc4random_uniform(64))
        titleLable = UILabel()
        titleLable.textColor = UIColor.white
        titleLable.text = kTitles[randomNum]
        titleLable.numberOfLines = 0
        titleLable.textAlignment = NSTextAlignment.left
        titleLable.font = UIFont.boldSystemFont(ofSize: 20)
        titleLable.sizeToFit()
        backImageView.addSubview(titleLable)
        
    }
    
    
    @objc func tapGesAction() -> Void {
        delegate?.tappedIconImageView()
    }
    
    @objc func pTapGesAction() -> Void {
        delegate?.tappedPersonalIconImageView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layoutSubview()
    }
    
    func layoutSubview() -> Void {
        
    }
    
    func bedrockString() -> NSMutableAttributedString {
        let mutableStr = NSMutableAttributedString(string: "狗圈儿  ")
        mutableStr.addAttributes([NSAttributedString.Key.font:
            UIFont.boldSystemFont(ofSize: 22),NSAttributedString.Key.foregroundColor:kMainBlueColor()], range: NSMakeRange(0, mutableStr.length))
        
        let infoDict = Bundle.main.infoDictionary
        let appVersion = infoDict!["CFBundleShortVersionString"]
        
        let versionStr = NSMutableAttributedString(string: String(format: "v%@", appVersion as! CVarArg))
        versionStr.addAttributes([NSAttributedString.Key.foregroundColor:kMainBlueColor().withAlphaComponent(0.7),NSAttributedString.Key.font:UIFont.systemFont(ofSize: 13)], range: NSMakeRange(0, versionStr.length))
        mutableStr.append(versionStr)
        return mutableStr
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
