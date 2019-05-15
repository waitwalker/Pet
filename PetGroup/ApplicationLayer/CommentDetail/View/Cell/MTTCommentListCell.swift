//
//  MTTCommentListCell.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/11/27.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTCommentListCellDelegate {
    func dTappedFromUser(model:MTTCommentModel) -> Void 
    func dTappedToUser(model:MTTCommentModel) -> Void 
    func dTappedCurrentItem(model:MTTCommentModel) -> Void 
}

class MTTCommentListCell: UITableViewCell {

    private var VContainerView:UIView!
    private var VCommentLabel:YYLabel!
    private var VBottomLineView:UIView!
    var DDelegate:MTTCommentListCellDelegate!
    
    
    var model:MTTCommentModel? {
        didSet{
            VCommentLabel.attributedText = commentAttributeString(model: model!)
        }
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        pSetupSubviews()
        pSetupGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }
    
    func pSetupGesture() -> Void {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        self.addGestureRecognizer(tapGes)
    }
    
    @objc func tapGestureAction() -> Void {
        self.DDelegate.dTappedCurrentItem(model: model!)
    }
    
    private func pSetupSubviews() -> Void {
        VContainerView = UIView()
        self.contentView.addSubview(VContainerView)
        
        VCommentLabel = YYLabel()
        VCommentLabel.numberOfLines = 0
        VCommentLabel.textAlignment = NSTextAlignment.left
        VContainerView.addSubview(VCommentLabel)
        
        VBottomLineView = UIView()
        VBottomLineView.backgroundColor = kLightBlueColor()
        VContainerView.addSubview(VBottomLineView)
    }
    
    func pLayoutSubviews() -> Void {
        VContainerView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(0)
        }
        
        VCommentLabel.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.bottom.equalTo(-5)
            make.left.equalTo(30)
            make.right.equalTo(-30)
        }
        
        VBottomLineView.snp.makeConstraints { (make) in
            make.left.equalTo(25)
            make.right.equalTo(-25)
            make.bottom.equalTo(-1)
            make.height.equalTo(0.5)
        }
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
    
    func commentAttributeString(model:MTTCommentModel) -> NSMutableAttributedString {
        let attributeString = NSMutableAttributedString(string: model.fromUsername + "  回复  " + model.toUsername + ":  " + model.content)
        attributeString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 16), range: NSMakeRange(0, attributeString.length))
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: kLightBlueColor(), range: NSMakeRange(model.fromUsername.count + 6, model.toUsername.count))
        
        
        attributeString.setTextHighlight(NSMakeRange(0, model.fromUsername.count), color: kLightBlueColor(), backgroundColor: kLightBlueColor().withAlphaComponent(0.3), userInfo: nil, tapAction: { (view, attributeString, range, rect) in
            self.DDelegate.dTappedFromUser(model: model)
        }) { (view, attribute, range, rect) in
            self.DDelegate.dTappedFromUser(model: model)
        }
        
        attributeString.setTextHighlight(NSMakeRange(model.fromUsername.count + 6, model.toUsername.count), color: kLightBlueColor(), backgroundColor: kLightBlueColor().withAlphaComponent(0.3), userInfo: nil, tapAction: { (view, attributeString, range, rect) in
            self.DDelegate.dTappedToUser(model: model)
        }) { (view, attribute, range, rect) in
            
        }
        return attributeString
    }

}
