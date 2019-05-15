//
//  MTTMediator+CircleTargetAction.m
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/13.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator+CircleTargetAction.h"

@implementation MTTMediator (CircleTargetAction)

- (UIViewController *)registerCircleModuleWithParameter:(NSDictionary *)parameter
{
    UIViewController *vc = [self performTarget:@"CircleViewController" action:@"registerCircleModule" paramter:parameter shouldCacheTarget:true];
    return vc;
}

@end
