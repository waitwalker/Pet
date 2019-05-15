//
//  MTTUIColorExtension.swift
//  MyTwitter
//
//  Created by LiuChuanan on 2017/11/11.
//  Copyright © 2017年 waitWalker. All rights reserved.
//

import UIKit

extension UIColor
{
    
    /// 随机色 
    class var random:UIColor 
    {
        get{
            return self.randomColor()
        }
    }
    
    /// 生成随机色 
    ///
    /// - Returns: 随机颜色 
   class private func randomColor() -> UIColor {
        return UIColor.init(red: CGFloat((arc4random() % 256)) / 255.0, green: CGFloat((arc4random() % 256)) / 255.0, blue: CGFloat((arc4random() % 256)) / 255.0, alpha: 1.0)
    }
    
    
    /// 十六进制颜色 
    class public func colorWithString(colorString:String) -> UIColor 
    {
        /**
            截串 
         You should leave one side empty, hence the name "partial range".
         
         let newStr = str[..<index]
         The same stands for partial range from operators, just leave the other side empty:
         
         let newStr = str[index...]
         Keep in mind that these range operators return a Substring. If you want to convert it to a string, use String's initialization function:
         
         let newStr = String(str[..<index])
         You can read more about the new substrings here.
         */
        
        var color = UIColor.red  
        var cStr : String = colorString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()  
        
        if cStr.hasPrefix("#") 
        {  
            let index = cStr.index(after: cStr.startIndex)  
            cStr = String(cStr[index...])
            //cStr = cStr.substring(from: index)  
        }  
        if cStr.count != 6 
        {  
            return UIColor.black  
        }  
        
        //两种不同截取字符串的方法  
        let rRange = cStr.startIndex ..< cStr.index(cStr.startIndex, offsetBy: 2)  
        
        let rStr = String(cStr[rRange])//cStr.substring(with: rRange)  
        
        let gRange = cStr.index(cStr.startIndex, offsetBy: 2) ..< cStr.index(cStr.startIndex, offsetBy: 4)  
        let gStr = String(cStr[gRange]) //cStr.substring(with: gRange)  
        
        let bIndex = cStr.index(cStr.endIndex, offsetBy: -2)  
        let bStr = String(cStr[bIndex...]) //cStr.substring(from: bIndex)  
        
        color = UIColor(red: CGFloat(changeToInt(numStr: rStr)) / 255, green: CGFloat(changeToInt(numStr: gStr)) / 255, blue: CGFloat(changeToInt(numStr: bStr)) / 255, alpha: 1.0)
        return color  
    }
    
    
    /// RGB
    ///
    /// - Parameters:
    ///   - r: r
    ///   - g: g
    ///   - b: b
    /// - Returns: RGB 颜色 
    static func RGBColor(r:Int, g:Int, b:Int) -> UIColor {
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: 1.0)
    }
    
    class private func changeToInt(numStr:String) -> Int 
    {  
        let str = numStr.uppercased()  
        var sum = 0  
        for i in str.utf8 
        {  
            sum = sum * 16 + Int(i) - 48  
            if i >= 65 
            {  
                sum -= 7  
            }  
        }  
        return sum  
    }  
}
