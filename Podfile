
swift42 = ['SnapKit','RxSwift','RxCocoa','SwiftyJSON','Alamofire','RealmSwift','HandyJSON','Qiniu','Kingfisher','CryptoSwift','Toast-Swift','MJRefresh','IQKeyboardManagerSwift','MBProgressHUD','YYKit']

swift5 = ['SnapKit','RxSwift','RxCocoa','SwiftyJSON','Alamofire','RealmSwift','HandyJSON','Qiniu','Kingfisher','CryptoSwift','Toast-Swift','MJRefresh','IQKeyboardManagerSwift','MBProgressHUD','YYKit']

post_install do |installer|
    installer.pods_project.targets.each do |target|
        swift_version = nil

        if swift42.include?(target.name)
            print "set pod #{target.name} swift version to 4.2\n"
            swift_version = '4.2'
        end

        if swift5.include?(target.name)
            print "set pod #{target.name} swift version to 5\n"
            swift_version = '5'
        end

        if swift_version
            target.build_configurations.each do |config|
                config.build_settings['SWIFT_VERSION'] = swift_version
            end
        end
    end
end

platform :ios, '10.0'

target 'PetGroup' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for PetGroup
  pod 'SnapKit'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Alamofire'
  pod 'RealmSwift'
  pod 'HandyJSON', :git => 'https://github.com/alibaba/HandyJSON.git', :branch => 'dev_for_swift5.0'
  pod 'Qiniu'
  pod 'Kingfisher'
  pod 'CryptoSwift'
  pod 'Toast-Swift'
  pod 'MJRefresh'
  pod 'IQKeyboardManagerSwift'
  pod 'MBProgressHUD'
  pod 'YYKit'

  
  #统计 
  pod 'Flurry-iOS-SDK/FlurrySDK'
  pod 'Flurry-iOS-SDK/FlurryAds'

  # TensorFlow machine learning 
  pod 'TensorFlowLite', '1.10.1'
  
  # 友盟相关
  pod 'UMCCommon'
  pod 'UMCSecurityPlugins'
  pod 'UMCAnalytics'
  pod 'UMCPush'
  pod 'UMCErrorCatch'

  # U-Share SDK UI模块（分享面板，建议添加）
  pod 'UMCShare/UI'

  # 集成微信(完整版14.4M)
  pod 'UMCShare/Social/WeChat'

  # 集成QQ/QZone/TIM(完整版7.6M)
  pod 'UMCShare/Social/QQ'

  # 集成新浪微博(完整版25.3M)
  pod 'UMCShare/Social/Sina'

  # 集成钉钉
  #pod 'UMCShare/Social/DingDing'

  #基础库
  pod 'UMCCommon'
  pod 'UMCSecurityPlugins'

  #日志库
  pod 'UMCCommonLog'

  #统计
  pod 'UMCAnalytics'

  #推送
  pod 'UMCPush'

  #崩溃
  pod 'UMCErrorCatch'

  #分享
  # U-Share SDK UI模块（分享面板，建议添加）
  pod 'UMCShare/UI'

  # 分享第三方
  pod 'UMCShare/Social/WeChat'
  pod 'UMCShare/Social/QQ'
  pod 'UMCShare/Social/Sina'
  
  target 'PetGroupTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PetGroupUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
