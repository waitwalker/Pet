//
//  MTTPetRecogniseViewController.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/10/24.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import UIKit
import CoreMotion

@available(iOS 11.0, *)
class MTTPetRecogniseViewController: MTTViewController {
    
    
    var balls:[UIImageView]!
    var OGravityBeahvuirOne:UIGravityBehavior! //重力
    var OCollisionBehavior:UICollisionBehavior! //碰撞
    var ODynamicAnimator:UIDynamicAnimator! //运动管理
    var ODynamicItemBehavior:UIDynamicItemBehavior! //运动行为(基类)
    var OMotionManager:CMMotionManager!
    var blurImageView:UIImageView!
    var VBottomImageView:UIImageView!
    var VBoardLable:UILabel!
    let popularScienceData:[[String:Any]] = [
        ["name":"哈士奇",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"贵宾犬",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"松狮",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"边境牧羊犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"吉娃娃",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"德国牧羊犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"秋田犬",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"蝴蝶犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"博美犬",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"杜宾犬",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"柴犬",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"金毛",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"拉布拉多",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"法国斗牛犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"牛头梗",
         "imageHeight":CGFloat(150.0),
         "cellHeight":CGFloat(180.0)
        ],
        ["name":"英国斗牛犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"雪纳瑞",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"阿拉斯加犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"柯基",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"沙皮",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"腊肠犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
        ["name":"京巴犬",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ]
        ]
    
    
    
    lazy var VTopImageView = { () -> UIImageView in 
        
        let imageView = UIImageView(frame: CGRect(x: 20.0, y: 40.0, width: kScreenWidth - 40.0, height: kScreenHeight * 0.40))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "top_placeholder")
        return imageView
    }()
    
    lazy var VWoodenImageView = { () -> UIImageView in
        
        let imageView = UIImageView(frame: CGRect(x: 10.0, y: 40.0, width: kScreenWidth - 20.0, height: 25))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "wooden")
        return imageView
    }()
    
    lazy var VStartImageView = { () -> UIImageView in
        
        var kMargin:CGFloat = 33.0 * (kScreenHeight / 896.0)
        
        let imageView = UIImageView(frame: CGRect(x: 0.0, y: (kScreenHeight - (kScreenHeight * 0.33) - kMargin), width: 80, height: 40))
        imageView.isUserInteractionEnabled = true
        imageView.image = UIImage(named: "start_recognise")
        return imageView
    }()
    
    
    
    
    //视图将要显示
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    //视图将要消失
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    
    required init(info: [String : Any]?) {
        super.init(info: info)
        MTTAssistantManager.assistantHandler(nil, assistantType: MTTAssistantType.initializePetRecogniseData)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pSetupSubviews()
        pSetupFlyAction()
    }
    
    func pSetupSubviews() -> Void {
        blurImageView = UIImageView()
        blurImageView.frame = UIScreen.main.bounds
        blurImageView.image = UIImage.image(imageString: "sense_placeholder")
        blurImageView.isUserInteractionEnabled = true
        self.view.addSubview(blurImageView)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let visualEffectView = UIVisualEffectView(effect: blurEffect)
        visualEffectView.frame = blurImageView.bounds
        blurImageView.addSubview(visualEffectView)
        
        blurImageView.addSubview(VWoodenImageView)
        
        self.blurImageView.addSubview(self.VTopImageView)
        
        VBottomImageView = UIImageView()
        VBottomImageView.image = UIImage.image(imageString: "bottom_placeholder")
        blurImageView.addSubview(VBottomImageView)
        VBottomImageView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.bottom.equalTo((-(self.tabBarController?.tabBar.height)!))
            make.height.equalTo(kScreenHeight * 0.33)
        }
        
        blurImageView.addSubview(VStartImageView)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction))
        VStartImageView.addGestureRecognizer(tapGes)
        
        VBoardLable = UILabel()
        VBoardLable.numberOfLines = 0
        VBoardLable.textColor = kMainBlueColor()
        VBoardLable.text = "我要鉴宠"
        VBoardLable.textAlignment = NSTextAlignment.center
        VBoardLable.font = UIFont.boldSystemFont(ofSize: 20)
        VBoardLable.sizeToFit()
        blurImageView.addSubview(VBoardLable)
        
        VBoardLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.left.equalTo(80)
            make.right.equalTo(-80)
            make.top.equalTo(140 * (kScreenHeight / 896))
        }
    }
    
    @objc func tapGestureAction() -> Void {
        
        if MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == .Simulator_x86_64 || MTTDeviceInfoManager.deviceInfoManager.deviceModelTypeName == .Simulator_i386{
            self.view.toast(message: "模拟器暂不支持相机")
            return
        }
        
        let cameraController = MTTCameraController(info: nil)
        cameraController.DDelegate = self
        self.present(cameraController, animated: true) {
            
        }
    }
    
    func pSetupFlyAction() -> Void {
        pSetupBalls()
        pUseGyroPush()
    }
    
    func pSetupBalls() -> Void {
        balls = Array()
        if balls.count > 0 {
            balls.removeAll()
        }
        let numberBalls:Int = 22
        for index in 0 ..< numberBalls {
            
            let dict = popularScienceData[index]
            
            let imageView = UIImageView()
            imageView.image = UIImage.image(imageString: (dict["name"] as! String))
            let width:Int = 50
            imageView.layer.cornerRadius = 25
            imageView.clipsToBounds = true
            
            imageView.frame = CGRect(x: Int(arc4random_uniform(UInt32(Int(kScreenWidth) - width))), y: 0, width: width, height: width)
            self.view.addSubview(imageView)
            balls.append(imageView)
        }
        
        if ODynamicAnimator != nil {
            ODynamicAnimator = nil
        }
        
        if OGravityBeahvuirOne != nil {
            OGravityBeahvuirOne = nil
        }
        
        if OCollisionBehavior != nil {
            OCollisionBehavior = nil
        }
        
        if ODynamicItemBehavior != nil {
            ODynamicItemBehavior = nil
        }
        
        ODynamicAnimator = UIDynamicAnimator(referenceView: self.view)
        OGravityBeahvuirOne = UIGravityBehavior(items: balls)
        ODynamicAnimator.addBehavior(OGravityBeahvuirOne)
        OCollisionBehavior = UICollisionBehavior(items: balls)
        OCollisionBehavior.translatesReferenceBoundsIntoBoundary = true
        ODynamicAnimator.addBehavior(OCollisionBehavior)
        
        ODynamicItemBehavior = UIDynamicItemBehavior(items: balls)
        ODynamicItemBehavior.allowsRotation = true
        ODynamicItemBehavior.elasticity = 0.8//弹性
        ODynamicItemBehavior.resistance = 0.2 //抗阻力
        ODynamicItemBehavior.friction = 0.3 //摩擦力
        ODynamicAnimator.addBehavior(ODynamicItemBehavior)
        
    }
    
    func pUseGyroPush() -> Void {
        OMotionManager = CMMotionManager()
        OMotionManager.deviceMotionUpdateInterval = 0.5
        
        OMotionManager.startDeviceMotionUpdates(to: OperationQueue.current!) { (motion, error) in
            if let yaw = motion?.attitude.yaw, let pitch = motion?.attitude.pitch, let roll = motion?.attitude.roll {
                _ = String(format: "%f", yaw)
                _ = String(format: "%f", pitch)
                _ = String(format: "%f", roll)
                let rotation = atan2(pitch, roll)
                self.OGravityBeahvuirOne.angle = CGFloat(rotation)
            }
            
        }
    }
    
    deinit {
        OMotionManager.stopDeviceMotionUpdates()
    }

}

@available(iOS 11.0, *)
extension MTTPetRecogniseViewController:MTTCameraControllerDelegate {
    func dTakePhotoFinish(pixelBuffer: CVPixelBuffer?, error: Error?) {
        if let pixelB = pixelBuffer {
            MTTPetRecogniseHandler().recogniseImage(withCVPixelBufferRef: pixelB, delegate: self)
        }
    }
}

extension MTTPetRecogniseViewController:MTTPetRecogniseHandlerDelegate {
    func dRecognised(withValue value: [AnyHashable : Any]!) {
        var recogniseResult:String = ""
        for (_, dict) in value.enumerated() {
            let keyStr = dict.key as! String
            let val = dict.value as! Double
            let object = MTTRealm.sharedRealm.objects(MTTPetRecogniseDataInfo.self).filter(String(format: "objectEnglishName = '%@'", keyStr))
            if let petRecogniseInfo = object.first {
                recogniseResult = recogniseResult + petRecogniseInfo.objectChineseName + "概率:" + String(format: "%.0f", val * 100.0) + "%\n"
            } else {
                let idx = MTTPetRecogniseModel.originalObjects.index(of:keyStr)
                
                if let ind = idx {
                    let objectChineseName = MTTPetRecogniseModel.translateObjects[ind]
                    recogniseResult = recogniseResult + objectChineseName + "概率:" + String(format: "%.0f", val * 100.0) + "%\n"
                }
            }
        }
        VBoardLable.text = recogniseResult
        VBoardLable.sizeToFit()
    }
}
