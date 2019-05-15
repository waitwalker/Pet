//
//  MTTStringExtension.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/7/19.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

/*
 let newStr = String(str[..<index]) // = str.substring(to: index) In Swift 3
 let newStr = String(str[index...]) // = str.substring(from: index) In Swif 3
 let newStr = String(str[range]) // = str.substring(with: range) In Swift 3

 */

import Foundation

extension String
{
    public var normalImage: UIImage? {
        return UIImage(named: self + "_normal")?.withRenderingMode(.alwaysOriginal)
    }
    
    public var selectedImage: UIImage? {
        return UIImage(named: self + "_selected")?.withRenderingMode(.alwaysOriginal)
    }
    
    
    /// 计算图片文件大小
    ///
    /// - Parameter data: 二进制数据
    /// - Returns: 计算后的结果
    static func imageFileSize(data:Data) -> String {
        let length = Double(data.count)
        if (length / 1024.0) < 1024.4 {
            let str = String(format: "%.0f KB", (length / 1024.0))
            return str
        } else if (length / 1024.0) > 1024.0
        {
            let str = String(format: "%.0f MB", (length / 1024.0 / 1024.0))
            return str
        }
        return ""
    }
    
    /// 生成富文本
    ///
    /// - Parameters:
    ///   - firstString: 第一个字符串
    ///   - string: 第二个字符串
    /// - Returns: 富文本
    static func attributeString(_ firstString:String, second string: String) -> NSMutableAttributedString {
        let firstAttributedSting = NSMutableAttributedString(string: firstString)
        let secondeAttributedSting = NSMutableAttributedString(string: String(format: " (%@)", string))
        
        firstAttributedSting.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor:UIColor.black.withAlphaComponent(0.8)], range: NSMakeRange(0, firstAttributedSting.length))
        
        secondeAttributedSting.addAttributes([NSAttributedString.Key.font:UIFont.systemFont(ofSize: 17), NSAttributedString.Key.foregroundColor:UIColor.black.withAlphaComponent(0.5)], range: NSMakeRange(0, secondeAttributedSting.length))
        
        firstAttributedSting.append(secondeAttributedSting)
        return firstAttributedSting
    }
    
    
    /// 计算文本高度  
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - fontSize: 文本字体大小 
    /// - Returns: 文本高度 
    static func calculateTextHeight(_ text: String, fontSize: CGFloat) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: text)
        let style           = NSMutableParagraphStyle.init()
        style.lineSpacing   = 5
        let font            = UIFont.systemFont(ofSize: fontSize)
       attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
        attributeString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, text.count))
        let options         = UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue)
        let rect            = attributeString.boundingRect(
            with: CGSize.init(width: kScreenWidth - 110, height: CGFloat.greatestFiniteMagnitude), 
            options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(options)), 
            context: nil)
        return rect.size.height
    }
    
    
    /// 计算文本高度
    ///
    /// - Parameters:
    ///   - text: 文本
    ///   - textWidth: 文本宽度
    ///   - fontSize: 文本字体
    /// - Returns: 文本高度
    static func calculateTextHeightWithText(_ text: String, textWidth:CGFloat, fontSize: CGFloat) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: text)
        let style           = NSMutableParagraphStyle.init()
        style.lineSpacing   = 5
        let font            = UIFont.systemFont(ofSize: fontSize)
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
        attributeString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, text.count))
        let options         = UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue)
        let rect            = attributeString.boundingRect(
            with: CGSize.init(width: textWidth, height: CGFloat.greatestFiniteMagnitude), 
            options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(options)), 
            context: nil)
        return rect.size.height
    }
    
    
    /// 生成期望时间格式
    ///
    /// - Parameter timeStamp: 时间戳
    /// - Returns: 期望的时间格式
    static func generateExpectedTime(timeStamp: String) -> String {
        let serverTimeInterval = Double(timeStamp)!
        
        let startDate = Date(timeIntervalSince1970: serverTimeInterval)
        
        let currentDate = Date()
        let timeInterval = currentDate.timeIntervalSince(startDate)
        var tmp:Int = 0
        var result:String = ""
        if timeInterval / 60.0 < 1.0 {
            result = "刚刚"
        } else if timeInterval / 60.0 < 60.0 {
            tmp = Int(timeInterval) / 60
            result = "\(tmp) 分钟前"
        } else if timeInterval / (60.0 * 60.0)  < 24.0 {
            tmp = Int(timeInterval) / (60 * 60)
            result = "\(tmp) 小时前"
        } else if timeInterval / (60.0 * 60.0)  >= 24.0 && timeInterval / (60.0 * 60.0) < (2.0 * 24.0) {
            result = "昨天"
        } else {
            let dataFormatter = DateFormatter()
            dataFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
            result = dataFormatter.string(from: startDate)
        }
        
        return result
    }
    
    // MARK: - 字符串切片截取
    /// 截取第一个到第任意位置
    ///
    /// - Parameter end: 结束的位值
    /// - Returns: 截取后的字符串
    func sliceString(toEnd: Int) -> String{
        print(self.count)
        if !(toEnd < count) { return "截取超出范围" }
        let sInde = index(startIndex, offsetBy: toEnd)
        
        return String(self[..<sInde])
    }
    
    /// 截取人任意位置到结束
    ///
    /// - Parameter end:
    /// - Returns: 截取后的字符串
    func sliceStringFromIndexToEnd(start: Int) -> String {
        if !(start < count) { return "截取超出范围" }
        let sRange = index(startIndex, offsetBy: start)..<endIndex
        return String(self[sRange])
    }
    
    
    /// 字符串截取         3  6
    /// e.g let aaa = "abcdefghijklmnopqrstuvwxyz"  -> "cdef"
    /// - Parameters:
    ///   - start: 开始位置 3
    ///   - end: 结束位置 6
    /// - Returns: 截取后的字符串 "cdef"
    func sliceString(_ from: Int, to: Int) -> String {
        if !(to < count) || from > to { return "取值范围错误" }
        var tempStr: String = ""
        for i in from...to {
            let temp: String = self[self.index(self.startIndex, offsetBy: i)].description
            tempStr += temp
        }
        return tempStr
    }
    
    /// 字符串任意位置插入
    ///
    /// - Parameters:
    ///   - content: 插入内容
    ///   - locate: 插入的位置
    /// - Returns: 添加后的字符串
    func insertString(content: String, to locate: Int) -> String {
        if !(locate < count) { return "截取超出范围" }
        let str1 = sliceString(toEnd: locate)
        let str2 = sliceStringFromIndexToEnd(start: locate)
        return str1 + content + str2
    }
    
    /// 计算字符串的尺寸
    ///
    /// - Parameters:
    ///   - text: 字符串
    ///   - rectSize: 容器的尺寸
    ///   - fontSize: 字体
    /// - Returns: 尺寸
    func getStringSize(text: String, rectSize: CGSize,fontSize: CGFloat) -> CGSize {
        let str = text as NSString
        let rect = str.boundingRect(with: rectSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: fontSize)], context: nil)
        
        return rect.size
    }
    
    
    /// 输入字符串 输出数组
    /// e.g  "qwert" -> ["q","w","e","r","t"]
    /// - Returns: ["q","w","e","r","t"]
    func stringToArray() -> [String] {
        let num = count
        if !(num > 0) { return [""] }
        var arr: [String] = []
        for i in 0..<num {
            let tempStr: String = self[self.index(self.startIndex, offsetBy: i)].description
            arr.append(tempStr)
        }
        return arr
    }
    
    
    /// 字符URL格式化
    ///
    /// - Returns: 格式化的 url
    func stringEncoding() -> String {
        let url = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return url!
    }
    
    public static func contentsOfFileWithResourceName(_ name: String, ofType type: String, fromBundle bundle: Bundle, encoding: String.Encoding, error: NSErrorPointer) -> String? {
        if let path = bundle.path(forResource: name, ofType: type) {
            do {
                return try String(contentsOfFile: path, encoding: encoding)
            } catch {
                return nil
            }
        } else {
            return nil
        }
    }
    
    public func startsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other,
                                  options: NSString.CompareOptions.anchored) {
            return range.lowerBound == self.startIndex
        }
        return false
    }
    
    public func endsWith(_ other: String) -> Bool {
        // rangeOfString returns nil if other is empty, destroying the analogy with (ordered) sets.
        if other.isEmpty {
            return true
        }
        if let range = self.range(of: other,
                                  options: [NSString.CompareOptions.anchored, NSString.CompareOptions.backwards]) {
            return range.upperBound == self.endIndex
        }
        return false
    }
    
    func escape() -> String {
        let raw: NSString = self as NSString
        let allowedEscapes = CharacterSet(charactersIn: ":/?&=;+!@#$()',*")
        let str = raw.addingPercentEncoding(withAllowedCharacters: allowedEscapes)
        return (str as String?)!
    }
    
    func unescape() -> String {
        return CFURLCreateStringByReplacingPercentEscapes(
            kCFAllocatorDefault,
            self as CFString,
            "[]." as CFString) as String
    }
    
    /**
     Ellipsizes a String only if it's longer than `maxLength`
     
     "ABCDEF".ellipsize(4)
     // "AB…EF"
     
     :param: maxLength The maximum length of the String.
     
     :returns: A String with `maxLength` characters or less
     */
    func ellipsize(maxLength: Int) -> String {
        if (maxLength >= 2) && (self.count > maxLength) {
            let index1 = self.index(self.startIndex, offsetBy: (maxLength + 1) / 2) // `+ 1` has the same effect as an int ceil
            let index2 = self.index(self.endIndex, offsetBy: maxLength / -2)
            
            return self.substring(to: index1) + "…\u{2060}" + self.substring(from: index2)
        }
        return self
    }
    
    private var stringWithAdditionalEscaping: String {
        return self.replacingOccurrences(of: "|", with: "%7C", options: NSString.CompareOptions(), range: nil)
    }
    
    public var asURL: URL? {
        // Firefox and NSURL disagree about the valid contents of a URL.
        // Let's escape | for them.
        // We'd love to use one of the more sophisticated CFURL* or NSString.* functions, but
        // none seem to be quite suitable.
        return URL(string: self) ??
            URL(string: self.stringWithAdditionalEscaping)
    }
    
    /// Returns a new string made by removing the leading String characters contained
    /// in a given character set.
    public func stringByTrimmingLeadingCharactersInSet(_ set: CharacterSet) -> String {
        var trimmed = self
        while trimmed.rangeOfCharacter(from: set)?.lowerBound == trimmed.startIndex {
            trimmed.remove(at: trimmed.startIndex)
        }
        return trimmed
    }
    
    /// Adds a newline at the closest space from the middle of a string.
    /// Example turning "Mark as Read" into "Mark as\n Read"
    public func stringSplitWithNewline() -> String {
        let mid = self.count/2
        
        let arr: [Int] = self.indices.compactMap {
            if self[$0] == " " {
                return self.distance(from: startIndex, to: $0)
            }
            
            return nil
        }
        guard let closest = arr.enumerated().min(by: { abs($0.1 - mid) < abs($1.1 - mid) }) else {
            return self
        }
        var newString = self
        newString.insert("\n", at: newString.index(newString.startIndex, offsetBy: closest.element))
        return newString
    }
    
    
    /// 计算文本高度
    ///
    /// - Parameter text: 文本 
    /// - Returns: 高度 
    public func calculateTextHeight(text:String) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: text)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 5
        let font = UIFont.systemFont(ofSize: 14)
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
        attributeString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, text.count))
        let options = UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue)
        let rect = attributeString.boundingRect(with: CGSize.init(width: kScreenWidth - 60 - 20, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(options)), context: nil)
        return rect.size.height
    }
    
    /**
     Get the height with font.
     
     - parameter font:       The font.
     - parameter fixedWidth: The fixed width.
     
     - returns: The height.
     */
    func heightWithFont(fontSize : CGFloat, fixedWidth : CGFloat) -> CGFloat {
        let attributeString = NSMutableAttributedString.init(string: self)
        let style = NSMutableParagraphStyle.init()
        style.lineSpacing = 5
        let font = UIFont.systemFont(ofSize: fontSize)
        attributeString.addAttribute(NSAttributedString.Key.paragraphStyle, value: style, range: NSMakeRange(0, self.count))
        attributeString.addAttribute(NSAttributedString.Key.font, value: font, range: NSMakeRange(0, self.count))
        let options = UInt8(NSStringDrawingOptions.usesLineFragmentOrigin.rawValue) | UInt8(NSStringDrawingOptions.usesFontLeading.rawValue)
        let rect = attributeString.boundingRect(with: CGSize.init(width: fixedWidth, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions(rawValue: NSStringDrawingOptions.RawValue(options)), context: nil)
        return rect.size.height
    }
    
    // MARK: - 获取当前时间string
    static func getTimeString(date:Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
        let dateStr = dateFormatter.string(from:date)
        return dateStr
    }
    
    
    /// 获取随机数
    ///
    /// - Parameter peakValue: 最大随机数
    /// - Returns: 随机数 
    static func getRandomValue(peakValue:Int) -> Int {
        return Int(arc4random_uniform(UInt32(peakValue)))
    }
    
    /// 获取当前时间戳
    ///
    /// - Returns: 时间戳
    static func getCurrentTimeStamp() -> String {
        
        let now = Date()
        let timeInterval = Int(now.timeIntervalSince1970)
        
        return String(format: "%d", timeInterval)
        
    }

}
