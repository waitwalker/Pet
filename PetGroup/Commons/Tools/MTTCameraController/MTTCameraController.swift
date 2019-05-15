//
//  MTTCameraController.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/10/26.
//  Copyright © 2018 waitWalker. All rights reserved.
//
/*
 * 自定义相机
 *
 **/

/*
 相机基本实现步骤
 捕捉会话——AVCaptureSession
 捕捉输入——AVCaptureDeviceInput
 捕捉预览——AVCaptureVideoPreviewLayer/OpenGL ES
 捕捉连接——AVCaptureConnection
 拍照——AVCaptureStillImageOutput
 音频——AVCaptureAudioDataOutput
 视频——AVCaptureVideoDataOutput
 生成视频文件——AVAssetWriter、AVAssetWriterInput
 写入相册——ALAssetsLibrary、PHPhotoLibrary
 操作相机
 转换摄像头
 补光
 闪光灯
 聚焦
 曝光
 自动聚焦曝光
 缩放
 视频重力——Video gravity
 方向问题——Orientation
 
 */

import UIKit
import AVFoundation
import RxCocoa
import RxSwift

protocol MTTCameraControllerDelegate {
    
    
    /// 拍照结束回调
    ///
    /// - Parameters:
    ///   - image: 图片
    ///   - error: 错误
    /// - Returns: void
    func dTakePhotoFinish(pixelBuffer:CVPixelBuffer?, error:Error?) -> Void
}

@available(iOS 10.2, *)
class MTTCameraController: UIViewController {
    
    /*
     相机实现步骤，下面对每一会对每一步需要做的事情详解
     
     1.创建session(捕捉会话)
     2.创建device input(捕捉设备输入)
     3.预览view
     4.创建capture output(捕捉的输出)
     5.拍照、录视频(元数据转成图片或文件)
     */
    
    var DDelegate:MTTCameraControllerDelegate?
    
    
    private var session:AVCaptureSession!
    private var device:AVCaptureDevice!
    private var input:AVCaptureDeviceInput!
    private var imageOutput:AVCapturePhotoOutput!
    private var previewLayer:AVCaptureVideoPreviewLayer!
    
    
    private var VTakePhotoButton:UIButton!
    private var VSwitchCameraButton:UIButton!
    private var VCancelButton:UIButton!
    private var VFocusView:UIView!
    
    let disposeBag = DisposeBag()
    
    
    
    
    
    
    

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(info:[String:Any]?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    fileprivate func pSetupSubviews() -> Void {
        VCancelButton = UIButton()
        VCancelButton.setImage(UIImage.image(imageString: "cancel_placeholder"), for: UIControl.State.normal)
        self.view.addSubview(VCancelButton)
        
        VSwitchCameraButton = UIButton()
        VSwitchCameraButton.setImage(UIImage.image(imageString: "switch_camera"), for: UIControl.State.normal)
        self.view.addSubview(VSwitchCameraButton)
        
        VTakePhotoButton = UIButton()
        VTakePhotoButton.setImage(UIImage.image(imageString: "take_photo"), for: UIControl.State.normal)
        self.view.addSubview(VTakePhotoButton)
        
        VFocusView = UIView()
        VFocusView.layer.borderColor = kMainBlueColor().cgColor
        VFocusView.layer.borderWidth = 1.5
        VFocusView.backgroundColor = UIColor.clear
        self.view.addSubview(VFocusView)
        VFocusView.isHidden = true
    }
    
    fileprivate func pLayoutSubviews() -> Void {
        VCancelButton.snp.makeConstraints { (make) in
            make.left.equalTo(30)
            make.height.width.equalTo(30)
            make.bottom.equalTo(-30)
        }
        
        VSwitchCameraButton.snp.makeConstraints { (make) in
            make.right.equalTo(-30)
            make.height.width.equalTo(30)
            make.bottom.equalTo(-30)
        }
        
        VTakePhotoButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(60)
            make.bottom.equalTo(-40)
            make.centerX.equalTo(self.view)
        }
        
        VFocusView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
    }
    
    
    
    fileprivate func pSetupEvent() -> Void {
        
        // 取消回调
        VCancelButton.rx.tap.subscribe(onNext: { (_) in
            self.dismiss(animated: false, completion: { 
                
            })
        }, onError: { (error) in
            MTTPrint("cancel camera error:\(error.localizedDescription)")
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        
        // 切换回调
        (VSwitchCameraButton.rx.tap).subscribe(onNext: { (_) in
            self.switchCameraAction()
        }, onError: { (error) in
            
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        
        // 拍照回调
        VTakePhotoButton.rx.tap.subscribe(onNext: { (_) in
            self.pTakePhoto()
        }, onError: { (error) in
            
        }, onCompleted: { 
            
        }).disposed(by: disposeBag)
        
        let tapGes = UITapGestureRecognizer(target: self, action: #selector(focusGestureAction(gesture:)))
        self.view.addGestureRecognizer(tapGes)
        
    }
    
    
    @objc func focusGestureAction(gesture:UITapGestureRecognizer) -> Void {
        let point = gesture.location(in: gesture.view)
        focusAtPoint(point: point)
    }
    
    // MARK: - 调焦设置
    fileprivate func focusAtPoint(point:CGPoint) -> Void {
        let size = self.view.size
        let focusPoint = CGPoint(x: point.y / size.height, y: 1 - point.x / size.width)
        
        try! device.lockForConfiguration()
        device.focusPointOfInterest = focusPoint
        device.focusMode = AVCaptureDevice.FocusMode.autoFocus
        
        if device.isExposureModeSupported(AVCaptureDevice.ExposureMode.autoExpose) {
            device.exposurePointOfInterest = focusPoint
            device.exposureMode = AVCaptureDevice.ExposureMode.autoExpose
        }
        device.unlockForConfiguration()
        VFocusView.center = point
        VFocusView.isHidden = false
        UIView.animate(withDuration: 0.3, animations: { 
            self.VFocusView.transform = CGAffineTransform(scaleX: 1.25, y: 1.25)
        }) { (completed) in
            UIView.animate(withDuration: 0.5, animations: { 
                self.VFocusView.transform = CGAffineTransform.identity
            }, completion: { (completed) in
                self.VFocusView.isHidden = true
            })
        }
        
    }
    
    // MARK: - 切换相机
    private func switchCameraAction() -> Void {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera,AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = discoverySession.devices
        if devices.count > 1 {
            let animation = CATransition()
            animation.duration = 0.3
            animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
            animation.type = convertToCATransitionType("oglFlip")
            
            var newDevice:AVCaptureDevice!
            var newInput:AVCaptureDeviceInput!
            
            let position = input.device.position
            if position == AVCaptureDevice.Position.front {
                newDevice = cameraWithPosition(position: AVCaptureDevice.Position.back)
                animation.subtype = CATransitionSubtype.fromLeft
            } else {
                newDevice = cameraWithPosition(position: AVCaptureDevice.Position.front)
                animation.subtype = CATransitionSubtype.fromRight
            }
            
            if let newD = newDevice {
                newInput = try? AVCaptureDeviceInput(device: newD)
            }
            previewLayer.add(animation, forKey: nil)
            
            if newInput != nil {
                session.beginConfiguration()
                session.removeInput(input)
                
                if session.canAddInput(newInput) {
                    session.addInput(newInput)
                    input = newInput
                } else {
                    session.addInput(input)
                }
                session.commitConfiguration()
            } else {
                MTTPrint("toggle camera failed")
            }
        }
        
    }
    
    // MARK: - 根据相机位置返回AVCaptureDevice
    func cameraWithPosition(position:AVCaptureDevice.Position) -> AVCaptureDevice? {
        let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera,AVCaptureDevice.DeviceType.builtInDualCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        
        let devices = discoverySession.devices
        for device in devices {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    
    // MARK: - 拍照回调
    private func pTakePhoto() -> Void {
        
        DispatchQueue.main.async {
            let settings = AVCapturePhotoSettings()
            //settings.isHighResolutionPhotoEnabled = true
            //                settings.flashMode = AVCaptureDevice.FlashMode.auto
            let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
            let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                                 kCVPixelBufferWidthKey as String: 160,
                                 kCVPixelBufferHeightKey as String: 160,
                                 ]
            settings.previewPhotoFormat = previewFormat
            if self.imageOutput.supportedFlashModes.contains(AVCaptureDevice.FlashMode.auto) {
                settings.flashMode = AVCaptureDevice.FlashMode.auto
            } else if self.imageOutput.supportedFlashModes.contains(AVCaptureDevice.FlashMode.on) {
                settings.flashMode = AVCaptureDevice.FlashMode.on
            } else if self.imageOutput.supportedFlashModes.contains(AVCaptureDevice.FlashMode.off) {
                settings.flashMode = AVCaptureDevice.FlashMode.off
            }
            
            self.imageOutput.capturePhoto(with: settings, delegate: self)
        }
        
        
    }
    
    // MARK: - 装载 
    private func setupCapture() -> Void {
        
        device = AVCaptureDevice.default(for: AVMediaType.video)
        
        input = try! AVCaptureDeviceInput(device: device)
        
        imageOutput = AVCapturePhotoOutput()
        let settings = AVCapturePhotoSettings.init(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
        imageOutput?.setPreparedPhotoSettingsArray([settings]) { (a, e) in
            print(e?.localizedDescription ?? "")
        }
        
        session = AVCaptureSession()
        let queue = DispatchQueue.init(label: "serria", qos: DispatchQoS.background, attributes: DispatchQueue.Attributes.concurrent, autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.never, target: nil)
        queue.sync {
            session.canSetSessionPreset(AVCaptureSession.Preset.vga640x480) ? (session.sessionPreset = AVCaptureSession.Preset.vga640x480) : (session.sessionPreset =  AVCaptureSession.Preset.photo) 
        }
        
        if session.canAddInput(input) {
            session.addInput(input)
        }
        
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
    }
    
    // 根据当前设备的状态计算捕捉到的图像的状态
    var videoOrientationFromCurrentDeviceOrientation: AVCaptureVideoOrientation? {
        get {
            switch UIDevice.current.orientation {
            case .landscapeLeft:
                return .landscapeRight
            case .landscapeRight:
                return .landscapeLeft
                //            case .portraitUpsideDown:
            //                return .portraitUpsideDown
            case .portrait:
                return .portrait
            default:
                return nil
            }
        }
    }

    
    // MARK: - 卸载相关
    private func unsetupCapture() -> Void {
        if device != nil {
            device = nil
        }
        
        if session != nil {
            session = nil
        }
        
        if input != nil {
            input = nil
        }
        
        if imageOutput != nil {
            imageOutput = nil
        }
        
        if previewLayer != nil {
            previewLayer = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCapture()
        pSetupSubviews()
        pLayoutSubviews()
        pSetupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if (session != nil) {
            session.startRunning()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (session != nil) {
            session.stopRunning()
        }
    }
    
    deinit {
        unsetupCapture()
    }
    


}


@available(iOS 11.0, *)
extension MTTCameraController:AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        if let sampleBuffer = photoSampleBuffer {
            let data = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer)
            if let da = data {
                let img = UIImage(data: da)
                if let image  = img {
                    self.DDelegate?.dTakePhotoFinish(pixelBuffer: buffer(from: image), error: error)
                    if session != nil {
                        session.stopRunning()
                    }
                    self.dismiss(animated: true) {
                        
                    }
                }
            }
        }
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: image.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}


// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToCATransitionType(_ input: String) -> CATransitionType {
	return CATransitionType(rawValue: input)
}
