//
//  MTTPopularScienceViewController.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/7/19.
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
import Foundation

// MARK: - 科普区
class MTTPopularScienceViewController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var OInfo:[String:Any]?
    var VCollectionView:UICollectionView!
    let reusedCellId:String = "reusedCellId"
    var ODataSource:[MTTPopularScienceModel] = []
    
    
    
    
    /// 构造函数
    ///
    /// - Parameter info: info
    required init(info:[String:Any]?) {
        super.init(info: info)
        self.OInfo = info
        self.ODataSource = MTTPopularScienceModel().allPopularScienceModels()
    }
    
    /// 析构函数
    deinit {
        print("welcome release")
    }
    
    func pSetupSubview() -> Void {
//        let collectionViewFlowLayout = MTTCollectionViewFlowLayout()
        let collectionViewFlowLayout = UICollectionViewFlowLayout()
        
        collectionViewFlowLayout.minimumLineSpacing = 10
        collectionViewFlowLayout.minimumInteritemSpacing = 10
        collectionViewFlowLayout.sectionInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        
        VCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight - 64 - 100), collectionViewLayout: collectionViewFlowLayout)
        VCollectionView.backgroundColor = UIColor.white
        VCollectionView.delegate = self
        VCollectionView.dataSource = self
        VCollectionView.register(MTTPopularCell.self, forCellWithReuseIdentifier: reusedCellId)
        self.view.addSubview(VCollectionView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "大百科"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubview()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - class method  类方法
    
    // MARK: - private method 私有方法
    
}

extension MTTPopularScienceViewController: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = MTTPopularScienceDetailViewController(info: nil)
        self.navigationController?.pushViewController(detailVC, animated: true)
        
    }
}

extension MTTPopularScienceViewController: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ODataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reusedCellId, for: indexPath) as! MTTPopularCell
        if self.ODataSource.count > 0 {
            cell.model = self.ODataSource[indexPath.item]
        }
        cell.VImageView.indexPath = indexPath
        cell.DDelegate = self
        return cell
    }
}

extension MTTPopularScienceViewController: MTTPopularCellDelegate
{
    func dTappedPopularImage(index: Int) {
        
        if self.ODataSource.count > 0 {
            let info:[String:Any] = ["title":self.ODataSource[index].name]
            
            let detailVC = MTTPopularScienceDetailViewController(info: info)
            detailVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}

extension MTTPopularScienceViewController: MTTCollectionViewFlowLayoutDelegate
{
    func collectionView(_ collectionView: UICollectionView, layout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: IndexPath) -> CGSize {
        if indexPath.item < self.ODataSource.count - 1 {
            return CGSize(width: (kScreenWidth - 20.0 - 20.0 - 10.0) / 2.0, height: 180)
        } else {
            return CGSize(width: kScreenWidth - 40, height: 200)
        }
    }
}

