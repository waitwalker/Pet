//
//  MTTArrayExtension.swift
//  PetGroup
//
//  Created by junzi on 2018/10/21.
//  Copyright © 2018 waitWalker. All rights reserved.
//

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()
        
        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
