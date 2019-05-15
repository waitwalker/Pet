//
//  MTTConst.swift
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/3.
//  Copyright © 2018年 waitWalker. All rights reserved.
//


/********** 文件说明 **********
 命名:见名知意 
 方法前缀:
 私有方法:p开头 驼峰式 
 代理方法:d开头 驼峰式 
 接口方法:i开头 驼峰式 
 其他类似 
 
 成员变量(属性)前缀:
 视图相关:V开头 驼峰式 View  
 控制器相关:C开头 驼峰式 Controller
 数据相关:M开头 驼峰式 Model
 viewModel相关: VM开头 
 代理相关:D开头 驼峰式 delegate 
 枚举相关:E开头 驼峰式 enum 
 闭包相关:B开头 驼峰式 block 
 bool类型相关:is开头 驼峰式 
 其他相关:O开头 驼峰式 other
 其他类似
 
 1. 类的功能:
 
 2. 注意事项:
 
 3. 其他说明:
 
 
 *****************************/




import Foundation
import UIKit


// 屏幕宽高
let kScreenWidth  = UIScreen.main.bounds.size.width
let kScreenHeight = UIScreen.main.bounds.size.height


/// 格式化输出   
///
/// - Parameters:
///   - message: 打印的内容
///   - file: 文件
///   - funtion: 方法
///   - line: 行号 
func MTTPrint<T>(_ message: T, file: String = #file, funtion: String = #function, line: Int = #line) -> Void {
    #if DEBUG 
    #endif
    let filename = (file as NSString).lastPathComponent
    let date = Date()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy年MM月dd日 HH:mm:ss"
    let currentTimeString = dateFormatter.string(from: date)
    
    print("时间:\(currentTimeString) | 类:\(filename) | 行:\(line) | 方法:\(funtion) |||: \(message) ")
}



/// 网络状态改变通知
let kNetworkStatusNotify:String = "kNetworkStatusNotify"

/// 需要登录的通知
let kNeedLoginNotify:String = "kNeedLoginNotify"

let kReportFailureString:String = "举报失败,请稍后重试"


//颜色
let kG1:UIColor = UIColor.colorWithString(colorString: "#ffffff")
let kG2:UIColor = UIColor.colorWithString(colorString: "#fafafa")
let kG3:UIColor = UIColor.colorWithString(colorString: "#f2f2f2")
let kG4:UIColor = UIColor.colorWithString(colorString: "#cccccc")
let kG5:UIColor = UIColor.colorWithString(colorString: "#999999")
let kG6:UIColor = UIColor.colorWithString(colorString: "#666666")
let kG7:UIColor = UIColor.colorWithString(colorString: "#333333")
let kG8:UIColor = UIColor.colorWithString(colorString: "#000000")
let kG9:UIColor = UIColor.colorWithString(colorString: "#F6F7F9")

let kC1:UIColor = UIColor.colorWithString(colorString: "#4aacee")
let kC2:UIColor = UIColor.colorWithString(colorString: "#ff9b33")
let kC3:UIColor = UIColor.colorWithString(colorString: "#ff6666")
let kC16:UIColor = UIColor.colorWithString(colorString: "#41A2EC")

let kC17:UIColor = UIColor.colorWithString(colorString: "#ff8022")
let kC18:UIColor = UIColor.colorWithString(colorString: "#52c330")


let kInvisiblePlaceholder:String          = "invisable_placeholder"
let kVisiblePlaceholder:String            = "visable_placeholder"
let kDingTalkLoginSuccess:String          = "kDingTalkLoginSuccess"
let kLogoutSuccess:String                 = "kLogoutSuccess"


// MARK: - RGB颜色
func kRGBColor(r:Float,g:Float,b:Float) -> UIColor {
    return UIColor.init(red: CGFloat((r) / 255.0), green: CGFloat((g) / 255.0), blue: CGFloat((b) / 255.0), alpha: 1.0)
}

// coment normal #7EA3BD

// MARK: - #29AAE9
func kLightBlueColor() -> UIColor {
    return UIColor.init(red: (41) / 255.0, green: (170) / 255.0, blue: (233) / 255.0, alpha: 1.0)
}

// MARK: - 主色调 #3399FF
func kMainBlueColor() -> UIColor {
    return UIColor.init(red: (51) / 255.0, green: (153) / 255.0, blue: (255) / 255.0, alpha: 1.0)
}

// MARK: - 主亮灰色
func kMainLightGrayColor() -> UIColor {
    return UIColor.init(red: (230) / 255.0, green: (236) / 255.0, blue: (240) / 255.0, alpha: 1.0)
}

// MARK: - 文字灰色
func kMainTextGrayColor() -> UIColor {
    return UIColor.init(red: (86) / 255.0, green: (107) / 255.0, blue: (123) / 255.0, alpha: 1.0)
}

// MARK: - 主灰色
func kMainGrayColor() -> UIColor {
    return UIColor.init(red: (102) / 255.0, green: (102) / 255.0, blue: (153) / 255.0, alpha: 1.0)
}

// MARK: - 主灰色
func kMainChatBackgroundGrayColor() -> UIColor {
    return UIColor.init(red: (231) / 255.0, green: (236) / 255.0, blue: (239) / 255.0, alpha: 1.0)
}

// MARK: - 主红色
func kMainRedColor() -> UIColor {
    return UIColor.init(red: (221) / 255.0, green: (41) / 255.0, blue: (96) / 255.0, alpha: 1.0)
}

// MARK: - 主绿色
func kMainGreenColor() -> UIColor {
    return UIColor.init(red: (0) / 255.0, green: (183) / 255.0, blue: (83) / 255.0, alpha: 1.0)
}

// MARK: - 主白色
func kMainWhiteColor() -> UIColor {
    return UIColor.white
}



let kTitles:[String] = [
    "人生像一束鲜花,仔细观赏,才能看到它的美丽;人生像一杯清茶,细细品味,才能品出味道",
    "生活如花朵,姹紫嫣红;生活如歌声,美妙动听;生活如美酒,芳香清醇;生活如小诗,意境深远,绚丽多彩",
    "成熟是一种明亮而不刺眼的光辉,是一种圆润而不腻耳的音响,一种不需要对别人察颜观色的从容,是一种终于停止了向周围申诉求告的大气",
    "对上帝生气没有关系.他受得了",
    "退休存款从你的第一张薪水条开始",
    "重拾快乐童年永不嫌晚.但这第二次只能靠自己不靠人",
    "原谅每一个人.每一件事",
    "永远选择生活",
    "除了你, 没有人在主宰你的快乐",
    "时间会痊愈几乎每一件事.要给时间.时间",
    "自恋是源于对于生活的极端热爱,对于细节以及享乐主义的不断追求",
    "聆听不代表沉默,有时安静也是一种力量",
    "一切利己的生活,都是非理性的,动物的生活",
    "千万别说直到永远,因为你压根不知道永远有多远",
    "心清如水即是佛,了无牵挂佛无边",
    "没有不老的誓言,没有不变的承诺,踏上旅途,义无反顾",
    "态度决定一切,实力扞卫尊严！人要经得起诱惑耐得住寂寞",
    "牢记所得到的,忘记所付出的",
    "笑口常开,好彩自然来",
    "人生最难吃的三碗面:人面情面场面",
    "沉默是毁谤最好的答覆",
    "生活中没有朋友,就像生活中没有阳光一样；若你想要拥有完美无瑕的友谊,可能一辈子找不到朋友",
    "当你劝告别人时,若不顾及别人的自尊心,那么再好的言语都没有用的",
    "不要在你的智慧中夹杂着傲慢.不要使你的谦虚心缺乏智慧",
    "忌妒别人,不会给自己增加任何的好处.忌妒别人,也不可能减少别人的成就",
    "人们总是对陌生人很宽容,对熟悉的人很挑剔",
    "认识自己,降伏自己,改变自己,才能改变别人",
    "头脑是日用品,而不是装饰品",
    "像穷人一样讲价,像绅士一样付账",
    "学会宽恕就是学会顺从自己的心,“恕”字拆开就是“如心”",
    "心中装满着自己的看法与想法的人,永远听不见别人的心声",
    "人之所以痛苦,在于追求错误的东西",
    "与其说是别人让你痛苦,不如说自己的修养不够",
    "人生没有彩排,每天都在现场直播",
    "每一种创伤,都是一种成熟","你不要一直不满人家,你应该一直检讨自己才对.不满人家,是苦了你自己",
    "相遇,心绪如白云飘飘；拥有,心花如雨露纷纷；错过,心灵如流沙肆虐.回首,幽情如蓝静夜清",
    "涵养,使人严肃而不孤僻,使人活泼而不放浪,使人稳重而不呆板,使人热情而不轻狂,使人沉着而不寡言,使人和气而不盲从",
    "路还很长,难免心酸皱眉,但无论怎样,别松手就好",
    "学会承受,因为在人生当中总是发生一些突如其来、让人意想不到的事情,别无选择,只是默默地承受,并勇敢地面对",
    "一个人在乎的不是金钱而是一颗奋斗的心啊！",
    "学会看淡,不是面对生活的妥协,而是一种积极的人生智慧",
    "笑,是一种没有副作用的镇静剂",
    "其实,某些时候,一些语言只是狡辩,来掩饰自己不愿意让别人知道的心伤",
    "让春天的温暖陪伴着你,让小草的绿意陪伴着你,让灿烂的阳光陪伴着你,伴你踏上征途,并早日获得成功",
    "怕苦的人将苦一辈子,不怕苦的人只苦一阵子.没有备胎意识的人,人生将有很大的风险.想过与众不同的生活,就要有与众不同的想法",
    "学会放下,懂得从容.人就这么凑巧的一生,只有笑看人生,才能拥有海阔天空的心胸",
    "生活如花,姹紫嫣红；生活如歌,美妙动听；生活如酒,芳香清醇；生活如诗,意境深远,绚丽多彩",
    "沉浸在孤独的世界里,一发不可收拾,即便在人群里也是孤单相随",
    "没人会把我们变的越来越好，时间也只是陪衬。支撑我们变的越来越好的是我们自己不断进阶的才华，修养，品行以及不断的反思和修正。",
    "这个社会是存在不公平的，不要抱怨，因为没有用！人总是在反省中进步的！",
    "前有阻碍，奋力把它冲开，运用炙热的激情，转动心中的期待，血在澎湃，吃苦流汗算什么。",
    "有一个人任何时候都不会背弃你，这个人就是你自己。谁不虚伪，谁不善变，谁都不是谁的谁。又何必把一些人，一些事看得那么重要。",
    "有的感情，无奈分开，但也不失为一段好感情；有的感情，一直在一起，但双方负能量缠身，这不能是好感情。",
    "大智慧的人不是关心他得到了什么，而是关心他创造了什么。",
    "也许你我皆是那刚刚成长的心灵，不求成长，也不知道什么是成长，只是在一天天中，越来成熟越来懵懂。",
    "相信优美的生命，就是一曲无字的挽歌，漫过心际的孤独，早已蔚然成冰，而你，是这个季节最美丽的音符。",
    "从蛹破茧而出的瞬间，是撕掉一层皮的痛苦彻心彻肺很多蝴蝶都是在破茧而出的那一刻被痛得死掉了。",
    "就算你做得再好，也会有人指指点点；即便你一塌糊涂，亦能听到赞歌。不必纠结于外界的评判，不必掉进他人的眼神，不必为了讨好这个世界而扭曲了自己。能够拯救我的，只能是我自己。",
    "因为每一言行都是种子，所以人迟早会品尝到自己亲手培育的甜苦果子；因为每一选择都是基因，所以人迟早会走进自己亲自选定的好坏命运。",
    
    "强者不是没有眼泪，只是可以含着眼泪向前跑。时间是治疗心灵创伤的大师，但不是解决问题的高手。",
    "在人的一生中，也许有些人会经历四种爱：在错的时候遇到对的人，是遗憾；在对的时候遇到错的人，是错爱；在错的时候遇到错的人，是幸运；在对的时候遇到对的人，是幸福。",
    "修行，不修不行，越修越行。“修”有三意：一是修建，二是修正，三是修补；“行”有三意：一是功德，二是能力，三是行为。",
    "如果你热爱读书，那你就会从书籍中得到灵魂的慰藉；从书中找到生活的榜样；从书中找到自己生活的乐趣；并从中不断地发现自己，提升自己，从而超越自己。",
    "永远要感恩生命中那些给你扔石头的人，因为他堆起了使你站得更高的台阶。"
]






