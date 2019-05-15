//
//  MTTViewController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/3.
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
import MBProgressHUD

// MARK: - ***************** class 分割线 ******************
class MTTViewController: UIViewController {
    
    // MARK: - variable 变量 属性
    
    var VLoadingHUD:MBProgressHUD!
    
    // MARK: - instance method 实例方法 
    // MARK: - instance method 实例方法 
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    
    /// 构造函数  
    ///
    /// - Parameter info: info 
    required init(info:[String:Any]?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var prefersStatusBarHidden: Bool {
        return self.isStatusBarHidden
    }
    
    var isStatusBarHidden = false {
        
        didSet{
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MobClick.beginLogPageView(self.className)
        
        if self.navigationController != nil && (self.navigationController?.viewControllers.count)! > 1 {
            
            navigationController?.interactivePopGestureRecognizer?.delegate = self
            navigationController?.interactivePopGestureRecognizer?.isEnabled = true
            setUpNavigation(title: "")
        }
        
        print("MTTViewController viewWillAppear")
    }
    
    func setUpNavigation(title: String) -> Void {
        self.navigationItem.title = title
        let leftCameraButton = UIButton()
        leftCameraButton.addTarget(self, action: #selector(pop), for: UIControl.Event.touchUpInside)
        leftCameraButton.frame = CGRect(x: 0, y: 0, width: 32, height: 32)
        
        leftCameraButton.setImage(UIImage(named: "left_back"), for: UIControl.State.normal)
        leftCameraButton.imageEdgeInsets = UIEdgeInsets.init(top: 4, left: 4, bottom: 4, right: 4)
        
        let fixedButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.fixedSpace, target: nil, action: nil)
        fixedButton.width = -12.0
        navigationItem.leftBarButtonItems = [fixedButton, UIBarButtonItem(customView: leftCameraButton)]
    }
    
    
    // MARK: - 私有方法  设置加载
    func pSetupHUD(_ view: UIView = UIApplication.shared.keyWindow!, title: String = "加载中...") -> Void {
        
        pRemoveHUD()
        
        VLoadingHUD = MBProgressHUD.showAdded(to: view, animated: true)
        VLoadingHUD.animationType = MBProgressHUDAnimation.fade
        VLoadingHUD.bezelView.backgroundColor = UIColor.clear
        VLoadingHUD.label.text = title
        VLoadingHUD.show(animated: true)
    }
    
    func pRemoveHUD() -> Void {
        if VLoadingHUD != nil {
            VLoadingHUD.removeFromSuperview()
            VLoadingHUD = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        pSetupViewAction()
        pSetupNotification()
        print("MTTViewController viewDidLoad")
    }
    
    private func pSetupNotification() -> Void {
        NotificationCenter.default.addObserver(self, selector: #selector(handlerNeedLoginAction(notify:)), name: NSNotification.Name(rawValue: kNeedLoginNotify), object: nil)
    }
    
    @objc func handlerNeedLoginAction(notify:Notification) -> Void {
        
    }
    
    // MARK: - 收起键盘
    private func pSetupViewAction() -> Void {
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(viewAction))
        self.view.addGestureRecognizer(tapGes)
    }
    
    @objc func viewAction() -> Void {
        //self.view.endEditing(true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("MTTViewController viewDidAppear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        MobClick.endLogPageView(self.className)
        self.hidesBottomBarWhenPushed = false
        print("MTTViewController viewWillDisappear")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("MTTViewController viewDidDisappear")
    }
    
    func pushViewController(_ controller: UIViewController) -> Void {
        self.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    // MARK: - class method  类方法 
    
    // MARK: - private method 私有方法  
    
}
