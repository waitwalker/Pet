//
//  MTTNSObjectExtension.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/11/5.
//  Copyright © 2018 waitWalker. All rights reserved.
//

import Foundation
extension NSObject
{
    // MARK:返回className
    var className:String{
        get{
            let name =  type(of: self).description()
            if(name.contains(".")){
                return name.components(separatedBy: ".")[1];
            }else{
                return name;
            }
        }
    }
}
