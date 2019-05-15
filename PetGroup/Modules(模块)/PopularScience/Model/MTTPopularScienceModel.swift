//
//  MTTPopularScienceModel.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/8/28.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

import Foundation

struct MTTPopularScienceModel {
    var name:String = ""
    var imageHeight:CGFloat = 0.0
    var cellHeight:CGFloat = 0.0
    
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
        ],
        ["name":"其它",
         "imageHeight":CGFloat(170.0),
         "cellHeight":CGFloat(200.0)
        ],
    ]
    
    
    func allPopularScienceModels() -> [MTTPopularScienceModel] {
        
        var tmp:[MTTPopularScienceModel] = []
        
        for (_,dict) in popularScienceData.enumerated() {
            var model = MTTPopularScienceModel()
            model.name = dict["name"] as! String
            model.imageHeight = dict["imageHeight"] as! CGFloat
            model.cellHeight = dict["cellHeight"] as! CGFloat
            tmp.append(model)
        }
        
        return tmp
    }
}
