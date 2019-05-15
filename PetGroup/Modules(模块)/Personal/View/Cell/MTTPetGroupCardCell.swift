//
//  MTTBedrockCardCell.swift
//  Bedrock
//
//  Created by junzi on 2018/4/5.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

/**
    第一个卡片 Bedrock 
 */

import UIKit

@available(iOS 11.0, *)
class MTTPetGroupCardCell: MTTCardCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubview() {
        dateLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.height.equalTo(20)
            make.width.equalTo(180)
        }
        
        bedrockLabel.snp.makeConstraints { (make) in
            make.top.equalTo(dateLabel.snp.bottom).offset(0)
            make.left.equalTo(20)
            make.height.equalTo(30)
            make.width.equalTo(180)
        }
        
        bedrockIconImageView.snp.makeConstraints { (make) in
            make.right.equalTo(-20)
            make.top.equalTo(self.contentView).offset(30)
            make.height.width.equalTo(40)
        }
        
        personalImageView.snp.makeConstraints { (make) in
            make.right.equalTo(bedrockIconImageView.snp.left).offset(-20)
            make.top.equalTo(self.contentView).offset(30)
            make.height.width.equalTo(40)
        }
        
        backImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(bedrockLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self.contentView)
        }
        
        titleLable.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.bottom.equalTo(-30)
        }
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
