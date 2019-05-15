//
//  MTTNormalCardCell.swift
//  Bedrock
//
//  Created by junzi on 2018/4/5.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

/**
    正常卡片 
 */

import UIKit

@available(iOS 11.0, *)
class MTTNormalCardCell: MTTCardCell {

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubview() {
        super.layoutSubview()
        
        backImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(self.contentView).offset(20)
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
