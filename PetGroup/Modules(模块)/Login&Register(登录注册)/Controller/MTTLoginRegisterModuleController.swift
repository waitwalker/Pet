//
//  MTTLoginRegisterModuleController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/7.
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
 视图相关:V开头 驼峰式 
 控制器相关:C开头 驼峰式 
 数据相关:M开头 驼峰式 
 代理相关:D开头 驼峰式 
 其他类似
 
 1. 类的功能:
 登录注册 
 
 2. 注意事项:
 
 3. 其他说明:
 里氏替换原则:任何基类都可以被子类替换 
 单一功能原则:一个类只负责一个功能
 
 
 *****************************/




import UIKit
import SnapKit
import RxCocoa
import RxSwift

// MARK: - ***************** class 分割线 ******************
@available(iOS 11.0, *)
class MTTLoginRegisterModuleController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var OInfo:[String:Any]!
    var VBackgroudImageView:UIImageView!
    fileprivate var VContainerView:UIView! 
    var OUid:String = ""
    var OName:String = ""
    
    // 账号 
    var VAccountContainerView:UIView!
    fileprivate var VAccoutPlaceImageView:UIImageView!
    var VAccoutTextField:UITextField!
    
    // 密码 
    var VPasswordContainerView:UIView!
    fileprivate var VPasswordPlaceImageView:UIImageView!
    var VPasswordTextField:UITextField!
    fileprivate var VPasswordShowButton:UIButton!
    
    // 登录 
    var VLoginButton:UIButton!
    var VRegisterButton:UIButton!
    var VForgetButton:UIButton!
    
    // 三方 
    var VThirdWeChatButton:UIButton!
    var VThirdSinaButton:UIButton!
    var VThirdQQButton:UIButton!
    
    let disposeBag = DisposeBag()
    var loginViewModel:MTTLoginViewModel!
    var VMRegisterViewModel:MTTRegisterViewModel!
    
    typealias BCompletionCallBack = (_ isLoginSuccess: Bool, _ info:[String:Any]?) -> ()
    var BCompletion:BCompletionCallBack!
    
    
    
    
    // MARK: - instance method 实例方法 
    
    // MARK: - 构造函数 
    required init(info:[String:Any]?) {
        super.init(nibName: nil, bundle: nil)
        if info != nil {
            self.OInfo = info
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setUpNavigation(title: "登录")
    }
    
    
    /// 重写pop方法 dismiss loginVC 
    override func pop() {
        self.navigationController?.dismiss(animated: true, completion: { 
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
    }
    
    // MARK: - 初始相关控件 
    private func pSetupSubviews() -> Void {
        VBackgroudImageView = UIImageView()
        VBackgroudImageView.isUserInteractionEnabled = true
        VBackgroudImageView.frame = self.view.bounds
        VBackgroudImageView.image = UIImage.image(imageString: "my_sense")
        self.view.addSubview(VBackgroudImageView)
        
        // 中间容器 
        VContainerView = UIView()
        VContainerView.backgroundColor = UIColor.RGBColor(r: 60, g: 175, b: 224).withAlphaComponent(0.25)
        VContainerView.layer.cornerRadius = 10
        VContainerView.clipsToBounds = true
        VBackgroudImageView.addSubview(VContainerView)
        
        // 账号容器 
        VAccountContainerView = UIView()
        VAccountContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        VAccountContainerView.layer.cornerRadius = 3
        VContainerView.addSubview(VAccountContainerView)
        
        VAccoutPlaceImageView = UIImageView()
        VAccoutPlaceImageView.image = UIImage.image(imageString: "phone_placeholder")
        VAccountContainerView.addSubview(VAccoutPlaceImageView)
        
        VAccoutTextField = UITextField()
        VAccoutTextField.textAlignment = NSTextAlignment.left
        VAccoutTextField.placeholder = "手机号"
        VAccoutTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        VAccountContainerView.addSubview(VAccoutTextField)
        
        // 密码容器 
        VPasswordContainerView = UIView()
        VPasswordContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        VPasswordContainerView.layer.cornerRadius = 3
        VContainerView.addSubview(VPasswordContainerView)
        
        VPasswordPlaceImageView = UIImageView()
        VPasswordPlaceImageView.image = UIImage.image(imageString: "password_placeholder")
        VPasswordContainerView.addSubview(VPasswordPlaceImageView)
        
        VPasswordShowButton = UIButton()
        VPasswordShowButton.isSelected = true
        VPasswordShowButton.setImage(UIImage.image(imageString: "visable_placeholder"), for: UIControl.State.normal)
        VPasswordShowButton.setImage(UIImage.image(imageString: "invisable_placeholder"), for: UIControl.State.selected)
        VPasswordContainerView.addSubview(VPasswordShowButton)
        
        VPasswordTextField = UITextField()
        VPasswordTextField.textAlignment = NSTextAlignment.left
        VPasswordTextField.placeholder = "6位以上密码"
        VPasswordTextField.isSecureTextEntry = true
        VPasswordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        VPasswordContainerView.addSubview(VPasswordTextField)
        
        // 登录 
        VLoginButton = UIButton(type: .custom)
        VLoginButton.showsTouchWhenHighlighted = true
        VLoginButton.setTitle("登录", for: UIControl.State.normal)
        VLoginButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VLoginButton.layer.cornerRadius = 3
        VLoginButton.clipsToBounds = true
        VLoginButton.layer.borderWidth = 1
        VLoginButton.layer.borderColor = UIColor.white.cgColor
        VContainerView.addSubview(VLoginButton)
        
        VRegisterButton = UIButton(type: .custom)
        VRegisterButton.showsTouchWhenHighlighted = true
        VRegisterButton.setTitle("注册账号", for: UIControl.State.normal)
        VRegisterButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        VRegisterButton.sizeToFit()
        VContainerView.addSubview(VRegisterButton)
        
        VForgetButton = UIButton(type: .custom)
        VForgetButton.isHidden = true
        VForgetButton.showsTouchWhenHighlighted = true
        VForgetButton.setTitle("忘记密码", for: UIControl.State.normal)
        VForgetButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VForgetButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        VForgetButton.sizeToFit()
        VContainerView.addSubview(VForgetButton)
        
        VThirdWeChatButton = UIButton(type: UIButton.ButtonType.custom)
        VThirdWeChatButton.setImage(UIImage(named: "board_dingtalk"), for: UIControl.State.normal)
        VThirdWeChatButton.showsTouchWhenHighlighted = true
        VThirdWeChatButton.layer.cornerRadius = 20
        VThirdWeChatButton.clipsToBounds = true
        VThirdWeChatButton.layer.borderColor = UIColor.white.cgColor
        VThirdWeChatButton.layer.borderWidth = 1.0
        VThirdWeChatButton.isHidden = DTOpenAPI.isDingTalkInstalled() ? false : true
        VContainerView.addSubview(VThirdWeChatButton)
        
        VThirdQQButton = UIButton(type: UIButton.ButtonType.custom)
        VThirdQQButton.isHidden = QQApiInterface.isQQInstalled() ? false : true
        VThirdQQButton.setImage(UIImage(named: "board_qq"), for: UIControl.State.normal)
        VThirdQQButton.showsTouchWhenHighlighted = true
        VThirdQQButton.layer.cornerRadius = 20
        VThirdQQButton.clipsToBounds = true
        VThirdQQButton.layer.borderColor = UIColor.white.cgColor
        VThirdQQButton.layer.borderWidth = 1.0
        VContainerView.addSubview(VThirdQQButton)
        
        VThirdSinaButton = UIButton(type: UIButton.ButtonType.custom)
        VThirdSinaButton.setImage(UIImage(named: "board_sina"), for: UIControl.State.normal)
        VThirdSinaButton.showsTouchWhenHighlighted = true
        VThirdSinaButton.layer.cornerRadius = 20
        VThirdSinaButton.clipsToBounds = true
        VThirdSinaButton.layer.borderColor = UIColor.white.cgColor
        VThirdSinaButton.layer.borderWidth = 1.0
        VContainerView.addSubview(VThirdSinaButton)
    }
    
    
    // MARK: - 设置viewModel
    func setupViewModel() -> Void {
        loginViewModel = MTTLoginViewModel(input: (account: VAccoutTextField.rx.text.orEmpty.asDriver(), password: VPasswordTextField.rx.text.orEmpty.asDriver(), loginTap: VLoginButton.rx.tap.asDriver()))
        
        loginViewModel.OAccountDriverSequence.drive(onNext: { result in
            switch result
            {
            case .empty, .failure( _):
                self.VAccoutTextField.textColor = UIColor.red
            case .success( _):
                self.VAccoutTextField.textColor = UIColor.black
            }
        }, onCompleted: { 
            print("账号输入完成")
        }).disposed(by: disposeBag)
        
        loginViewModel.OPasswordDriverSequence.drive(onNext: { (result) in
            switch result
            {
                case .empty, .failure( _):
                self.VPasswordTextField.textColor = UIColor.red
                case .success( _):
                self.VPasswordTextField.textColor = UIColor.black
            }
        }, onCompleted: { 
            print("密码输入完成")
        }).disposed(by: disposeBag)
        
        loginViewModel.OLoginButtonDriverSequence.asObservable().bind(to: VLoginButton.rx_buttonEnable)
        .disposed(by: disposeBag)
        
        VLoginButton.rx.tap.subscribe(onNext: { (_) in
            let otherInfo:[String:Any] = ["isNormalLogin":true]
            self.loginViewModel.loginAction(account: self.VAccoutTextField.text!, password: self.VPasswordTextField.text!, otherInfo: otherInfo, delegate: self)
            self.pSetupHUD(title:"登录中...")
        }, onError: { (error) in
            print("login button tap error:\(error)")
        }, onCompleted: { 
            print("login button tap")
        }).disposed(by: disposeBag)
        
        VPasswordShowButton.rx.tap.subscribe(onNext: { (_) in
            self.VPasswordShowButton.isSelected = !self.VPasswordShowButton.isSelected
            self.VPasswordTextField.isSecureTextEntry = self.VPasswordShowButton.isSelected
        }, onError: { (error) in
            MTTPrint("VPasswordShowButton error: \(error)")
        }, onCompleted: { 
            MTTPrint("VPasswordShowButton tap complete")
        }).disposed(by: disposeBag)
        
        VRegisterButton.rx.tap.subscribe(onNext: { (_) in
            let registerVC = MTTMediator.shared().registerRegisterModule(withParameter: nil)
            self.navigationController?.pushViewController(registerVC!, animated: true)
            
        }, onError: { (error) in
            
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        
        VForgetButton.rx.tap.subscribe(onNext: { (_) in
            self.view.toast(message: "功能即将上线, 请稍候")
        }, onError: { (error) in
            MTTPrint("login page forgetbutton tap error")
        }, onCompleted: { 
            MTTPrint("login page forgetbutton tap complete")
        }).disposed(by: disposeBag)
        
        VThirdQQButton.rx.tap.subscribe(onNext: { (_) in
            self.thirdLogin(thirdPlatformName: UMSocialPlatformType.QQ)
        }, onError: { (error) in
            MTTPrint("qq login error")
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        
        VThirdSinaButton.rx.tap.subscribe(onNext: { (_) in
            self.thirdLogin(thirdPlatformName: UMSocialPlatformType.sina)
        }, onError: { (error) in
            MTTPrint("weibo login error")
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        
        VThirdWeChatButton.rx.tap.subscribe(onNext: { (_) in
            self.ssoDingTalk()
        }, onError: { (error) in
            MTTPrint("wechat login error")
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        NotificationCenter.default.addObserver(self, selector: #selector(handleDingTalkLogin(notification:)), name: NSNotification.Name.init(kDingTalkLoginSuccess), object: nil)
    }
    
    @objc func handleDingTalkLogin(notification:Notification) -> Void {
        let userInfo = notification.object as! [String:Any]
        let otherInfo:[String:Any] = ["isNormalLogin":false]
        self.OUid = userInfo["uid"] as! String
        self.OName = userInfo["name"] as! String
        self.pSetupHUD(title:"登录中...")
        self.loginViewModel.loginAction(account: self.OName, password: self.OUid, otherInfo: otherInfo, delegate: self)
    }
    
    // MARK: - 处理钉钉登录
    func ssoDingTalk() -> Void {
        
        let authReq = DTAuthorizeReq()
        authReq.bundleId = "cn.waitwalker.petgroup"
        
        let result = DTOpenAPI.send(authReq)
        if result {
            MTTUserInfoManager.sharedUserInfo.header_photo = "header_photo_placeholder"
            MTTUserInfoManager.sharedUserInfo.isNormalLogin = false
        } else {
            self.view.toast(message: "登录遇到问题,请稍后重试!")
        }
    }
    
    // MARK: - 获取第三方授权 
    private func thirdLogin(thirdPlatformName:UMSocialPlatformType) -> Void {
        UMSocialManager.default().getUserInfo(with: thirdPlatformName, currentViewController: self) { (result, error) in
            // 第三方登录异常
            if error != nil {
                self.view.toast(message: "遇到一些问题,请一会再重试!")
                return
            } else {
                let response = result as! UMSocialUserInfoResponse
                let uid = response.uid
                let name = response.name
                let iconurl = response.iconurl
                MTTUserInfoManager.sharedUserInfo.header_photo = iconurl!
                MTTUserInfoManager.sharedUserInfo.isNormalLogin = false
                
                if let uidStr = uid, let nameStr = name {
                    let otherInfo:[String:Any] = ["isNormalLogin":false]
                    self.OUid = uidStr
                    self.OName = nameStr
                    self.pSetupHUD(title:"登录中...")
                    self.loginViewModel.loginAction(account: nameStr, password: uidStr, otherInfo: otherInfo, delegate: self)
                } else {
                    
                }
            }
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

extension UIButton {
    // 拓展一个只读属性 
    var rx_buttonEnable:AnyObserver<MTTResult> {
        return Binder(self, binding: { (button, result) in
            if result == MTTResult.success(message: kButtonEnableMatchSuccess) {
                button.setTitleColor(UIColor.white, for: UIControl.State.normal)
                button.layer.borderColor = UIColor.white.cgColor
                button.isEnabled = true
            }  else {
                button.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
                button.layer.borderColor = UIColor.lightGray.cgColor
                button.isEnabled = false
            }
        }).asObserver()
    }
}

// MARK: - 按钮点击回调
@available(iOS 11.0, *)
extension MTTLoginRegisterModuleController: MTTLoginViewModelDelegate, MTTRegisterViewModelDelegate {
    func dRegisterSuccessCallBack(info: [String : Any]?) {
        let otherInfo:[String:Any] = ["isNormalLogin":false]
        self.pRemoveHUD()
        self.pSetupHUD(title:"登录中...")
        self.loginViewModel.loginAction(account: self.OName, password: self.OUid, otherInfo: otherInfo, delegate: self)
    }
    
    func dRegisterFailureCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
        self.view.toast(message: "遇到问题,请稍候重试!")
    }
    
    func dLoginActionSuccessCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
        let isNormalLogin = info!["isNormalLogin"] as! Bool
        if isNormalLogin == false {
            NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "kLoginSuccess"), object: info)
            self.navigationController?.dismiss(animated: true, completion: { 
                
            })
        } else {
            self.navigationController?.dismiss(animated: true, completion: { 
                self.BCompletion(true, info)
            })
        }
    }
    
    func dLoginActionFailureCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
        let isNormalLogin = info!["isNormalLogin"] as! Bool
        let result = info!["result"] as! Int
        
        if isNormalLogin == false && result == -1{
            self.pSetupHUD(title:"登录中...")
            VMRegisterViewModel = MTTRegisterViewModel(input: (account: VAccoutTextField.rx.text.orEmpty.asDriver(), username: VAccoutTextField.rx.text.orEmpty.asDriver(), password: VPasswordTextField.rx.text.orEmpty.asDriver()))
            VMRegisterViewModel.DDelegate = self
            self.VMRegisterViewModel.registerButtonAction(self.OName, username: self.OName, password: self.OUid)
        } else {
            if let message = info!["msg"] {
                let msg = message as! String
                self.view.toast(message: msg)
            } else {
                self.view.toast(message: "登录遇到错误,请稍候重试")
            }
        }
    }
}

// MARK: - iPhone登录页面 
@available(iOS 11.0, *)
class MTTiPhoneLoginViewController: MTTLoginRegisterModuleController {
    
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pLayoutSubviews()
        setupViewModel()
    }
    
    
    private func pLayoutSubviews() -> Void {
        
        // MARK: - 中间容器高度 如果添加第三方登录 高度调整在这里 250合适
        VContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.top.equalTo(100)
            make.height.equalTo(320)
        }
        
        VAccountContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(20)
            make.height.equalTo(50)
        }
        
        VAccoutPlaceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(18)
            make.top.equalTo(16)
        }
        
        VAccoutTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VAccoutPlaceImageView.snp.right).offset(10)
            make.right.top.bottom.equalTo(VAccountContainerView)
        }
        
        VPasswordContainerView.snp.makeConstraints { (make) in
            make.right.left.height.equalTo(VAccountContainerView)
            make.top.equalTo(VAccountContainerView.snp.bottom).offset(15)
        }
        
        VPasswordPlaceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(18)
            make.top.equalTo(16)
        }
        
        VPasswordShowButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalTo(0)
            make.centerY.equalTo(VPasswordContainerView)
        }
        
        VPasswordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VPasswordPlaceImageView.snp.right).offset(10)
            make.right.equalTo(VPasswordShowButton.snp.left).offset(-10)
            make.height.top.equalTo(VPasswordContainerView)
        }
        
        VLoginButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(VAccountContainerView)
            make.top.equalTo(VPasswordContainerView.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
        
        VRegisterButton.snp.makeConstraints { (make) in
            make.left.equalTo(VLoginButton.snp.left).offset(30)
            make.top.equalTo(VLoginButton.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        VForgetButton.snp.makeConstraints { (make) in
            make.right.equalTo(VLoginButton.snp.right).offset(-30)
            make.top.equalTo(VLoginButton.snp.bottom).offset(20)
            make.height.equalTo(30)
        }
        
        VThirdWeChatButton.snp.makeConstraints { (make) in
            make.left.equalTo(VAccountContainerView).offset(20)
            make.bottom.equalTo(VContainerView.snp.bottom).offset(-10)
            make.height.width.equalTo(40)
        }
        
        VThirdSinaButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(VThirdWeChatButton)
            make.bottom.equalTo(VThirdWeChatButton)
            make.centerX.equalTo(VContainerView)
        }
        
        VThirdQQButton.snp.makeConstraints { (make) in
            make.right.equalTo(VAccountContainerView).offset(-20)
            make.bottom.equalTo(VThirdWeChatButton)
            make.height.width.equalTo(VThirdWeChatButton)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - iPad登录页面 
@available(iOS 11.0, *)
class MTTiPadLoginViewController: MTTLoginRegisterModuleController {
    
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 注册控制器 
@available(iOS 11.0, *)
class MTTRegisterViewController: MTTViewController {
    
    var VBackgroundImageView:UIImageView!
    fileprivate var VContainerView:UIView! 
    
    // 账号 
    var VAccountContainerView:UIView!
    fileprivate var VAccoutPlaceImageView:UIImageView!
    var VAccoutTextField:UITextField!
    
    // 用户名 
    var VUsernameContainerView:UIView!
    fileprivate var VUsernamePlaceImageView:UIImageView!
    var VUsernameTextField:UITextField!
    
    // 密码 
    var VPasswordContainerView:UIView!
    fileprivate var VPasswordPlaceImageView:UIImageView!
    var VPasswordTextField:UITextField!
    fileprivate var VPasswordShowButton:UIButton!
    
    var VRegisterButton:UIButton!
    var VMRegisterViewModel:MTTRegisterViewModel!
    let ODisposeBag = DisposeBag()
    
    
    
    
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
        pLayoutSubviews()
        setupRegisteViewModel()
        setupRightNavigation()
    }
    
    private func pSetupSubviews() -> Void {
        
        VBackgroundImageView = UIImageView()
        VBackgroundImageView.image = UIImage.image(imageString: "my_sense")
        VBackgroundImageView.frame = self.view.bounds
        VBackgroundImageView.isUserInteractionEnabled = true
        self.view.addSubview(VBackgroundImageView)
        
        // 中间容器 
        VContainerView = UIView()
        VContainerView.backgroundColor = UIColor.RGBColor(r: 60, g: 175, b: 224).withAlphaComponent(0.25)
        VContainerView.layer.cornerRadius = 10
        VContainerView.clipsToBounds = true
        VBackgroundImageView.addSubview(VContainerView)
        
        // 账号容器 
        VAccountContainerView = UIView()
        VAccountContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        VAccountContainerView.layer.cornerRadius = 3
        VContainerView.addSubview(VAccountContainerView)
        
        VAccoutPlaceImageView = UIImageView()
        VAccoutPlaceImageView.image = UIImage.image(imageString: "phone_placeholder")
        VAccountContainerView.addSubview(VAccoutPlaceImageView)
        
        VAccoutTextField = UITextField()
        VAccoutTextField.textColor = UIColor.black
        VAccoutTextField.font = UIFont.boldSystemFont(ofSize: 17)
        VAccoutTextField.textAlignment = NSTextAlignment.left
        VAccoutTextField.placeholder = "输入手机号"
        VAccoutTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        VAccountContainerView.addSubview(VAccoutTextField)
        
        // 用户名 
        VUsernameContainerView = UIView()
        VUsernameContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        VUsernameContainerView.layer.cornerRadius = 3
        VContainerView.addSubview(VUsernameContainerView)
        
        VUsernamePlaceImageView = UIImageView()
        VUsernamePlaceImageView.image = UIImage.image(imageString: "account_placeholder")
        VUsernameContainerView.addSubview(VUsernamePlaceImageView)
        
        VUsernameTextField = UITextField()
        VUsernameTextField.textColor = UIColor.black
        VUsernameTextField.font = UIFont.boldSystemFont(ofSize: 17)
        VUsernameTextField.textAlignment = NSTextAlignment.left
        VUsernameTextField.placeholder = "输入用户名"
        VUsernameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        VUsernameContainerView.addSubview(VUsernameTextField)
        
        // 密码容器 
        VPasswordContainerView = UIView()
        VPasswordContainerView.backgroundColor = UIColor.white.withAlphaComponent(0.8)
        VPasswordContainerView.layer.cornerRadius = 3
        VContainerView.addSubview(VPasswordContainerView)
        
        VPasswordPlaceImageView = UIImageView()
        VPasswordPlaceImageView.image = UIImage.image(imageString: "password_placeholder")
        VPasswordContainerView.addSubview(VPasswordPlaceImageView)
        
        VPasswordShowButton = UIButton()
        VPasswordShowButton.isSelected = true
        VPasswordShowButton.setImage(UIImage.image(imageString: "visable_placeholder"), for: UIControl.State.normal)
        VPasswordShowButton.setImage(UIImage.image(imageString: "invisable_placeholder"), for: UIControl.State.selected)
        VPasswordContainerView.addSubview(VPasswordShowButton)
        
        VPasswordTextField = UITextField()
        VPasswordTextField.textColor = UIColor.black
        VPasswordTextField.font = UIFont.boldSystemFont(ofSize: 17)
        VPasswordTextField.textAlignment = NSTextAlignment.left
        VPasswordTextField.placeholder = "输入6位以上密码"
        VPasswordTextField.isSecureTextEntry = true
        VPasswordTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        VPasswordContainerView.addSubview(VPasswordTextField)
        
        // 注册
        VRegisterButton = UIButton(type: .custom)
        VRegisterButton.setTitle("注册账号", for: UIControl.State.normal)
        VRegisterButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        VRegisterButton.layer.cornerRadius = 3
        VRegisterButton.clipsToBounds = true
        VRegisterButton.layer.borderWidth = 2
        VRegisterButton.layer.borderColor = UIColor.white.cgColor
        VRegisterButton.showsTouchWhenHighlighted = true
        VRegisterButton.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        VContainerView.addSubview(VRegisterButton)
    }
    
    
    /// 布局 子类要重写 
    public func pLayoutSubviews() -> Void {
        
    }
    
    func addGradientLayer(_ toView: UIView) {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = toView.bounds
        
        //设置渐变的主颜色
        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
        //将gradientLayer作为子layer添加到主layer上
        toView.layer.addSublayer(gradientLayer)
    }
    
    // MARK: - 设置导航栏
    func setupRightNavigation() -> Void {
        let rightButton = UIButton(frame: CGRect(x: 0, y: 0, width: 140, height: 44))
        rightButton.setTitle("用户协议及隐私政策", for: UIControl.State.normal)
        rightButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        rightButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        rightButton.addTargetTo(self, action: #selector(rightButtonAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightButton)
    }
    
    @objc func rightButtonAction() -> Void {
        let userAgreementVC = MTTUserAgreementViewController()
        self.navigationController?.pushViewController(userAgreementVC, animated: true)
    }
    
    func setupRegisteViewModel() -> Void {
        VMRegisterViewModel = MTTRegisterViewModel(input: (account: VAccoutTextField.rx.text.orEmpty.asDriver(), username: VUsernameTextField.rx.text.orEmpty.asDriver(), password: VPasswordTextField.rx.text.orEmpty.asDriver()))
        VMRegisterViewModel.DDelegate = self
        
        VMRegisterViewModel.OAccountDriverSequence.drive(onNext: { (result) in
            switch result {
            case .empty, .failure(_ ):
                self.VAccoutTextField.textColor = UIColor.red
            case .success(_):
                self.VAccoutTextField.textColor = UIColor.black
            }
            
        }, onCompleted: {
            MTTPrint("register account handler complete")
        }).disposed(by: ODisposeBag)
         VMRegisterViewModel.OUsernameDriverSequence.drive(onNext: { (result) in
            switch result {
            case .empty, .failure(_ ):
                self.VUsernameTextField.textColor = UIColor.red
            case .success(_):
                self.VUsernameTextField.textColor = UIColor.black
            }
        }, onCompleted: {
            MTTPrint("register username handler complete")
        }).disposed(by: ODisposeBag)
        
        VMRegisterViewModel.OPasswordDriverSequence.drive(onNext: { (result) in
            switch result {
            case .empty, .failure(_ ):
                self.VPasswordTextField.textColor = UIColor.red
            case .success(_):
                self.VPasswordTextField.textColor = UIColor.black
            }
        }, onCompleted: {
            MTTPrint("register password handler complete")
        }).disposed(by: ODisposeBag)
         VMRegisterViewModel.ORegisterButtonDriverSequence.asObservable().bind(to: VRegisterButton.rx_buttonEnable).disposed(by: ODisposeBag)
        
        VPasswordShowButton.rx.tap.subscribe(onNext: { (_) in
            self.VPasswordShowButton.isSelected = !self.VPasswordShowButton.isSelected
            self.VPasswordTextField.isSecureTextEntry = self.VPasswordShowButton.isSelected
        }, onError: { (error) in
            MTTPrint("VPasswordShowButton error: \(error)")
        }, onCompleted: { 
            MTTPrint("VPasswordShowButton tap complete")
        }).disposed(by: ODisposeBag)
        
        VRegisterButton.rx.tap.subscribe(onNext: { _ in
           self.pSetupHUD(title:"登录中...")
            self.VMRegisterViewModel.registerButtonAction(self.VAccoutTextField.text!, username: self.VUsernameTextField.text!, password: self.VPasswordTextField.text!)
        }, onError: { (error) in
            MTTPrint("register button tap error:\(error)")
        }, onCompleted: {
            MTTPrint("register button tap complete")
        }).disposed(by: ODisposeBag)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.title = "注册"
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// MARK: - 注册按钮 delegate 回调 
@available(iOS 11.0, *)
extension MTTRegisterViewController: MTTRegisterViewModelDelegate
{
    func dRegisterSuccessCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
        self.view.toast(message: "注册成功, 快去登录吧")
        let timeInterval:TimeInterval = 1.0
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + timeInterval) { 
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func dRegisterFailureCallBack(info: [String : Any]?) {
        self.pRemoveHUD()
        self.view.toast(message: "注册遇到问题啦, 请重试")
    }
    
    
}


/// 手机注册 
@available(iOS 11.0, *)
class MTTiPhoneRegisterViewController: MTTRegisterViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func pLayoutSubviews() {
        super.pLayoutSubviews()
        
        VContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(300)
            make.centerY.equalTo(self.view).offset(-60)
        }
        
        VAccountContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(20)
            make.height.equalTo(50)
        }
        
        VAccoutPlaceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(18)
            make.top.equalTo(16)
        }
        
        VAccoutTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VAccoutPlaceImageView.snp.right).offset(10)
            make.right.top.bottom.equalTo(VAccountContainerView)
        }
        
        VUsernameContainerView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(VAccountContainerView.snp.bottom).offset(20)
            make.height.equalTo(50)
        }
        
        VUsernamePlaceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(18)
            make.top.equalTo(16)
        }
        
        VUsernameTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VUsernamePlaceImageView.snp.right).offset(10)
            make.right.top.bottom.equalTo(VUsernameContainerView)
        }
        
        VPasswordContainerView.snp.makeConstraints { (make) in
            make.right.left.height.equalTo(VAccountContainerView)
            make.top.equalTo(VUsernameContainerView.snp.bottom).offset(20)
        }
        
        VPasswordPlaceImageView.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.height.width.equalTo(18)
            make.top.equalTo(16)
        }
        
        VPasswordShowButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(30)
            make.right.equalTo(0)
            make.centerY.equalTo(VPasswordContainerView)
        }
        
        VPasswordTextField.snp.makeConstraints { (make) in
            make.left.equalTo(VPasswordPlaceImageView.snp.right).offset(10)
            make.right.equalTo(VPasswordShowButton.snp.left).offset(-10)
            make.height.top.equalTo(VPasswordContainerView)
        }
        
        
        VRegisterButton.snp.makeConstraints { (make) in
            make.left.right.equalTo(VAccountContainerView)
            make.top.equalTo(VPasswordContainerView.snp.bottom).offset(30)
            make.height.equalTo(40)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


/// iPad 注册 
@available(iOS 11.0, *)
class MTTiPadRegisterViewController: MTTRegisterViewController {
    required init(info: [String : Any]?) {
        super.init(info: info)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



