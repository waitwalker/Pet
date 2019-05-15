//
//  MTTLauchProgressController.swift
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
 广告处理控制器 
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import UIKit

// MARK: - ***************** class 分割线 ******************
class MTTLauchProgressController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var VImageView:UIImageView!
    
    
    
    // MARK: - instance method 实例方法 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
        pLayoutSubviews()
    }
    
    fileprivate func pSetupSubviews() -> Void {
        VImageView = UIImageView()
        VImageView.image = UIImage(named: "ad")
        self.view.addSubview(VImageView)
    }
    
    fileprivate func pLayoutSubviews() -> Void {
        VImageView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view)
        }
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
