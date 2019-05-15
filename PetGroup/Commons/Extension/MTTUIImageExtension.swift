//
//  MTTUIImageExtension.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/16.
//  Copyright © 2018年 waitWalker. All rights reserved.
//


import Foundation
import UIKit

extension UIImage
{
    
    /// 获取图片 
    ///
    /// - Parameter imageString: imageString
    /// - Returns: image
    static func image(imageString:String?) -> UIImage {
        guard let string = imageString else {
            return UIImage(named: "pet_placeholder")!
        }
        
        if let image = UIImage(named: string) {
            return image
        } else {
            return UIImage(named: "pet_placeholder")!
        }
    }
    
    
    /// 仿照微信图片压缩算法 
    ///
    /// - Parameter originalImage: 原始图片
    /// - Returns: 压缩后图片 
    static func compressImage(originalImage: UIImage) -> UIImage {
        let width = originalImage.size.width
        let height = originalImage.size.height
        
        var updateWidth = width
        var updateHeight = height
        
        let longSide = max(width, height)
        let shortSide = min(width, height)
        
        let scale = shortSide / longSide
        
        if shortSide < 1080.0 || longSide < 1080.0 {
            updateWidth = width
            updateHeight = height
        } else {
            if width < height
            {
                updateWidth = 1080.0
                updateHeight = 1080.0 / scale
            } else {
                updateWidth = 1080.0 / scale
                updateHeight = 1080.0
            }
        }
        
        let compressSize = CGSize(width: updateWidth, height: updateHeight)
        UIGraphicsBeginImageContext(compressSize)
        originalImage.draw(in: CGRect(x: 0, y: 0, width: compressSize.width, height: compressSize.height))
        let compressImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let compressData = compressImage!.jpegData(compressionQuality: 0.5)
        let finalImage = UIImage(data: compressData!)
        return finalImage!
        
    }
    
    
    /// 根据颜色生成image
    ///
    /// - Parameter color: color
    /// - Returns: image
    static func imageWithColor(color:UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let theImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return theImage
    }
}
