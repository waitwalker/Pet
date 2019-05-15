//
//  MTTDateExtension.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/8/21.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation
extension Date
{
    func currentMoonDay() -> String
    {
        let nowDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M月d日"
        
        let moonDay = dateFormatter.string(from: nowDate)
        
        return moonDay
    }
    
    func weekDay() ->String {
        
        let weekDays = [NSNull.init(),"星期日","星期一","星期二","星期三","星期四","星期五","星期六"] as [Any]
        
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        
        let timeZone = NSTimeZone(name:"Asia/Shanghai")
        
        calendar?.timeZone = timeZone! as TimeZone
        let calendarUnit = NSCalendar.Unit.weekday
        
        let theComponents = calendar?.components(calendarUnit, from:self)
        
        return weekDays[(theComponents?.weekday)!] as! String
        
    }
}
