



//
//  MTTCommentMenuView.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/12/20.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit

protocol MTTCommentMenuViewDelegate {
    func dTappedItem(menuView:MTTCommentMenuView, currentIndex:Int) -> Void 
}

class MTTCommentMenuView: UIView {
    
    var VMenuTableView:UITableView!
    let ORusedMenuCellId:String = "ORusedMenuCellId"
    var MDataSource:[[String:Any]] = []
    var DDelegate:MTTCommentMenuViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        pSetupDataSource()
        pSetupSubviews()
        pSetupGesture()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func pSetupDataSource() -> Void {
        self.MDataSource = [["image":"write","title":"撰写评论","currentIndex":0],
                            ["image":"tip","title":"违规举报","currentIndex":1],
                            ["image":"block","title":"屏蔽用户","currentIndex":2]
            
        ]
    }
    
    func pSetupGesture() -> Void {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.addGestureRecognizer(tapGes)
    }
    
    @objc func tapAction() -> Void {
        if self.isHidden == false {
            self.isHidden = true
        }
    }
    
    private func pSetupSubviews() -> Void {
        
        VMenuTableView = UITableView(frame: CGRect(x: kScreenWidth - 180 - 20, y: 5, width: 180, height: 44 * 3 + 1))
        VMenuTableView.layer.cornerRadius = 10.0
        VMenuTableView.clipsToBounds = true
        VMenuTableView.delegate = self
        VMenuTableView.dataSource = self
        VMenuTableView.backgroundColor = kRGBColor(r: 53, g: 53, b: 53)
        VMenuTableView.register(MTTMenuCell.self, forCellReuseIdentifier: ORusedMenuCellId)
        self.addSubview(VMenuTableView)
    }
}

extension MTTCommentMenuView:UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.MDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: ORusedMenuCellId) as? MTTMenuCell
        if cell == nil {
            cell = MTTMenuCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: ORusedMenuCellId)
        }
        cell?.itemDataSource = self.MDataSource[indexPath.item]
        cell?.DDelegate = self
        return cell!
    }
}

extension MTTCommentMenuView: MTTMenuCellDelegate{
    func dTappedCellCallBack(currentIndex: Int) {
        self.DDelegate?.dTappedItem(menuView: self, currentIndex: currentIndex)
    }
}

extension MTTCommentMenuView:UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.DDelegate?.dTappedItem(menuView: self, currentIndex: indexPath.item)
    }
}

protocol MTTMenuCellDelegate {
    func dTappedCellCallBack(currentIndex:Int) -> Void
}

class MTTMenuCell: UITableViewCell {
    
    private var VImageView:UIImageView!
    private var VTitleLabel:UILabel!
    
    var DDelegate:MTTMenuCellDelegate?
    
    
    var itemDataSource:[String:Any]? {
        didSet{
            let currentIndex = itemDataSource!["currentIndex"] as! Int
            var color:UIColor = UIColor.white
            if currentIndex == 0 {
                color = kRGBColor(r: (210.0), g: (189.0), b: (133.0))
            } else if currentIndex == 1 {
                color = kRGBColor(r: (126.0), g: (183.0), b: (210.0))
            } else if currentIndex == 2 {
                color = kRGBColor(r: (188.0), g: (90.0), b: (61.0))
            }
            VImageView.tintColor = color
            VImageView.image = UIImage.image(imageString: (itemDataSource!["image"] as! String)).withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
            VTitleLabel.textColor = color
            VTitleLabel.text = (itemDataSource!["title"] as! String)
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
    
    private func pSetupSubviews() -> Void {
        
        self.backgroundColor = kRGBColor(r: 53, g: 53, b: 53)
        self.contentView.backgroundColor = kRGBColor(r: 53, g: 53, b: 53)
        
        VImageView = UIImageView()
        VImageView.tintColor = UIColor.brown
        VImageView.isUserInteractionEnabled = true
        self.contentView.addSubview(VImageView)
        
        VTitleLabel = UILabel()
        VTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        VTitleLabel.textColor = UIColor.white
        VTitleLabel.textAlignment = NSTextAlignment.left
        self.contentView.addSubview(VTitleLabel)
    }
    
    private func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(32)
            make.centerY.equalTo(self.contentView)
        }
        
        VTitleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(VImageView.snp.right).offset(10)
            make.top.bottom.right.equalTo(self.contentView)
        }
    }
    
    func pSetupGesture() -> Void {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        self.contentView.addGestureRecognizer(tapGes)
    }
    
    @objc func tapAction() -> Void {
        let currentIndex = itemDataSource!["currentIndex"] as! Int
        
        self.DDelegate?.dTappedCellCallBack(currentIndex: currentIndex)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
