//
//  MTTPopularScienceDetailViewController.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/20.
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
import WebKit


// MARK: - 科普详情
class MTTPopularScienceDetailViewController: MTTViewController {
    
    // MARK: - variable 变量 属性
    var OInfo:[String:Any]?
    
    var OTitle:String = ""
    
    var VPlaceView:MTTPlaceView!
    var VWebView:WKWebView!
    var OURLString:String = ""
    
    var VTitleView:UIView!
    var VTopLabel:UILabel!
    var VBottomLabel:UILabel!
    
    
    
    
    
    
    /// 构造函数
    ///
    /// - Parameter info: info
    required init(info:[String:Any]?) {
        super.init(info: info)
        if let inf = info {
            self.OTitle = inf["title"] as! String
        }
        self.OInfo = info
    }
    
    /// 析构函数
    deinit {
        print("\(MTTPopularScienceDetailViewController.self) release")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pSetupSubviews() -> Void {
        VWebView = WKWebView(frame: CGRect(x: 0, y: -40, width: kScreenWidth, height: kScreenHeight - 40))
        VWebView.navigationDelegate = self
        VWebView.uiDelegate = self
        self.view.addSubview(VWebView)
        
        if self.OTitle == "其它" {
            OURLString = "https://www.baidu.com/"
        } else {
            OURLString = String(format: "https://baike.baidu.com/search/word?word=%@", self.OTitle)
        }
        let encodedStr = OURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let url = URL(string: encodedStr!)
        VWebView.load(URLRequest(url: url!))
        
        pSetupHUD(self.view, title: "加载中...")
        
        pSetupNavigation()
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationItem.title = self.OTitle
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
    }
    
    func pSetupNavigation() -> Void {
        VTitleView = UIView()
        VTitleView.frame = CGRect(x: 0, y: 0, width: 180, height: 44)
        self.navigationItem.titleView = VTitleView
        
        VTopLabel = UILabel()
        VTopLabel.frame = CGRect(x: 0, y: 0, width: VTitleView.width, height: 25)
        VTopLabel.text = self.OTitle
        VTopLabel.textColor = UIColor.white
        VTopLabel.textAlignment = NSTextAlignment.center
        VTopLabel.font = UIFont.boldSystemFont(ofSize: 16)
        VTitleView.addSubview(VTopLabel)
        
        VBottomLabel = UILabel()
        VBottomLabel.frame = CGRect(x: 0, y: 25, width: VTitleView.width, height: 19)
        VBottomLabel.text = "资源来自于网络:百度百科"
        VBottomLabel.textColor = UIColor.white
        VBottomLabel.textAlignment = NSTextAlignment.center
        VBottomLabel.font = UIFont.systemFont(ofSize: 12)
        VTitleView.addSubview(VBottomLabel)
        
        let backButton = UIButton()
        backButton.setTitle("网页返回", for: UIControl.State.normal)
        backButton.setTitleColor(UIColor.white, for: UIControl.State.normal)
        backButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 10.0)
        backButton.frame = CGRect(x: 0, y: 0, width: 80, height: 32)
        backButton.setImage(UIImage.image(imageString: "webview_back"), for: UIControl.State.normal)
        backButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        backButton.setImageWithPosition(postion: MTTButtonImagePostion.Left, spacing: 5.0)
        backButton.addTargetTo(self, action: #selector(backButtonAction), for: UIControl.Event.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backButtonAction() -> Void {
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
        if VWebView.canGoBack {
            VWebView.goBack()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.setStatusBarHidden(false, with: UIStatusBarAnimation.none)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - 设置加载失败站位图
    func pSetupPlaceView() -> Void {
        
        if VPlaceView != nil {
            VPlaceView.removeFromSuperview()
            VPlaceView = nil
        }
        
        VPlaceView = MTTPlaceView(frame: self.view.bounds)
        VPlaceView.DDelegate = self
        VPlaceView.title = "加载失败\n点我返回"
        self.view.addSubview(VPlaceView)
        
    }
    
    // MARK: - class method  类方法
    
    // MARK: - private method 私有方法
    
}

extension MTTPopularScienceDetailViewController: MTTPlaceViewDelegate
{
    func dTapPlaceImageViewCallBack(_ placeView: MTTPlaceView) {
        if self.OURLString.count > 0 {
            if VPlaceView != nil {
                VPlaceView.removeFromSuperview()
                VPlaceView = nil
            }
            VWebView.isHidden = false
            let encodedStr = OURLString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
            let url = URL(string: encodedStr!)
            VWebView.load(URLRequest(url: url!))
        }
    }
    
}

extension MTTPopularScienceDetailViewController: WKNavigationDelegate, WKUIDelegate
{
    // WKNavigationDelegate
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        pRemoveHUD()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        pRemoveHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        pRemoveHUD()
        webView.isHidden = true
        pSetupPlaceView()
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        
    }
    
    // WKUIDelegate
    func webViewDidClose(_ webView: WKWebView) {
        
    }
    
    func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
    }
    
}
