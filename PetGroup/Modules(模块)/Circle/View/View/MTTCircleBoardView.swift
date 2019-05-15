//
//  MTTCircleBoardView.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/12/23.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTCircleBoardViewDelegate {
    func dTappedCloseButton(button:UIButton, boardView:MTTCircleBoardView) -> Void
    func dTappedCurrentItem(currentIndex:Int, currentItemDataSource:[String:Any]) -> Void
}

class MTTCircleBoardView: UIView {

    var VCollectionView:UICollectionView!
    var VCloseButton:UIButton!
    var MDataSource:[[String:Any]] = []
    var DDelegate:MTTCircleBoardViewDelegate?
    let OReusedBoardCellId:String = "OReusedBoardCellId"


    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupDataSource()
        pSetupLayer()
        pSetupSubviews()
    }

    func pSetupDataSource() -> Void {

        let wetChatTitle:String = WXApi.isWXAppInstalled() ? "分享到微信" : "系统分享"
        let wetChatFriendTitle:String = WXApi.isWXAppInstalled() ? "分享到朋友圈" : "系统分享"
        let qqTitle:String = QQApiInterface.isQQInstalled() ? "分享到QQ" : "系统分享"

        let weChatColor:UIColor = WXApi.isWXAppInstalled() ? kRGBColor(r: 97, g: 183, b: 75) : UIColor.white
        let weChatFriendColor:UIColor = WXApi.isWXAppInstalled() ? kRGBColor(r: 115, g: 213, b: 74) : UIColor.white
        let qqColor:UIColor = QQApiInterface.isQQInstalled() ? kRGBColor(r: 83, g: 132, b: 244) : UIColor.white

        let weChatImageString:String = WXApi.isWXAppInstalled() ? "board_wechat" : "share_icon"
        let weChatFriendImageString:String = WXApi.isWXAppInstalled() ? "board_friend" : "share_icon"
        let qqImageString:String = QQApiInterface.isQQInstalled() ? "board_qq" : "share_icon"

        self.MDataSource = [
            ["image":weChatImageString,"title":wetChatTitle,"currentItemIndex":0,"color":weChatColor],
            ["image":weChatFriendImageString,"title":wetChatFriendTitle,"currentItemIndex":1,"color":weChatFriendColor],
            ["image":"board_sina","title":"分享到微博","currentItemIndex":2,"color":kRGBColor(r: 216, g: 101, b: 104)],
            ["image":qqImageString,"title":qqTitle,"currentItemIndex":3,"color":qqColor],
            ["image":"board_tip","title":"违规举报","currentItemIndex":4,"color":kRGBColor(r: 210, g: 189, b: 133)],
            ["image":"board_block","title":"屏蔽用户","currentItemIndex":5,"color":kRGBColor(r: 188, g: 90, b: 61)]
        ]
    }


    func pSetupSubviews() -> Void {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        VCollectionView = UICollectionView(frame: CGRect(x: 0, y: kScreenHeight - 280 - 100, width: kScreenWidth, height: 280), collectionViewLayout: flowLayout)
        VCollectionView.delegate = self
        VCollectionView.dataSource = self
        VCollectionView.backgroundColor = UIColor.clear
        VCollectionView.register(MTTCircleBoardCell.self, forCellWithReuseIdentifier: OReusedBoardCellId)
        self.addSubview(VCollectionView)

        VCloseButton = UIButton()
        VCloseButton.setImage(UIImage.image(imageString: "board_close"), for: UIControl.State.normal)
        VCloseButton.frame = CGRect(x: (kScreenWidth - 40) / 2, y: kScreenHeight - 40 - 50, width: 40, height: 40)
        VCloseButton.addTargetTo(self, action: #selector(closeButtonAction(button:)), for: UIControl.Event.touchUpInside)
        self.addSubview(VCloseButton)
    }

    @objc func closeButtonAction(button:UIButton) -> Void {
        self.DDelegate?.dTappedCloseButton(button: button, boardView: self)
    }

    func pLayoutSubviews() -> Void {

    }

    private func pSetupLayer() -> Void {
        //定义渐变的颜色（从黄色渐变到橙色）
        let topColor = UIColor(red: 1/255, green: 1/255, blue: 1/255, alpha: 0.5)
        let buttomColor = UIColor(red: 41/255, green: 170/255, blue: 233/255, alpha: 1)
        let gradientColors = [topColor.cgColor, buttomColor.cgColor]

        //定义每种颜色所在的位置
        let gradientLocations:[NSNumber] = [0.0, 1.0]

        //创建CAGradientLayer对象并设置参数
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations

        //设置其CAGradientLayer对象的frame，并插入view的layer
        gradientLayer.frame = self.frame
        self.layer.insertSublayer(gradientLayer, at: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MTTCircleBoardView:UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.MDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OReusedBoardCellId, for: indexPath) as! MTTCircleBoardCell
        cell.itemDataSource = self.MDataSource[indexPath.item]
        return cell

    }
}


extension MTTCircleBoardView:UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.DDelegate?.dTappedCurrentItem(currentIndex: indexPath.item, currentItemDataSource: self.MDataSource[indexPath.item])
    }
}

extension MTTCircleBoardView:UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }



    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth - 4 * 20) / 3, height: 110)
    }
}

class MTTCircleBoardCell: UICollectionViewCell {

    var VImageView:UIImageView!
    var VTitleLabel:UILabel!
    var VInnerImageView:UIImageView!



    var itemDataSource:[String:Any]? {
        didSet{
            let color = itemDataSource!["color"] as! UIColor
            VImageView.backgroundColor = color
            VInnerImageView.image = UIImage.image(imageString: (itemDataSource!["image"] as! String))
            VTitleLabel.text = (itemDataSource!["title"] as! String)
            VTitleLabel.textColor = color
        }
    }


    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupSubviews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        pLayoutSubviews()
    }

    func pSetupSubviews() -> Void {
        VImageView = UIImageView()
        VImageView.isUserInteractionEnabled = true
        VImageView.backgroundColor = kMainGreenColor()
        VImageView.layer.cornerRadius = 35
        VImageView.clipsToBounds = true
        self.contentView.addSubview(VImageView)

        VInnerImageView = UIImageView()
        VInnerImageView.isUserInteractionEnabled = true
        VInnerImageView.layer.cornerRadius = 20
        VInnerImageView.clipsToBounds = true
        VImageView.addSubview(VInnerImageView)

        VTitleLabel = UILabel()
        VTitleLabel.textAlignment = NSTextAlignment.center
        VTitleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        self.contentView.addSubview(VTitleLabel)
    }

    func pLayoutSubviews() -> Void {

        VImageView.snp.makeConstraints { (make) in
            make.top.left.equalTo(10)
            make.width.height.equalTo(70)
        }

        VInnerImageView.snp.makeConstraints { (make) in
            make.width.height.equalTo(40)
            make.center.equalTo(VImageView)
        }

        VTitleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.height.equalTo(20)
            make.top.equalTo(VImageView.snp.bottom).offset(10)
        }

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
