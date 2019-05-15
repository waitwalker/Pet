//
//  MTTAssistantInterface.swift
//  PetGroup
//
//  Created by WangJunZi on 2018/7/19.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

// MARK: - 助手接口
protocol MTTAssistantInterface: class {
    
    
    /// 助手处理雇主的任务
    ///
    /// - Parameters:
    ///   - hirer: 雇主
    ///   - assistantType: 助手要处理的类型
    /// - Returns: 
    func iAssistantHandler(_ hirer:MTTAssistantInterface, assistantType: MTTAssistantType) -> Void
    
}
