//
//  MTTMediator+LoginRegisterTargetAction.m
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/29.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator+LoginRegisterTargetAction.h"

@implementation MTTMediator (LoginRegisterTargetAction)

- (UIViewController *)registerLoginModuleWithParameter:(NSDictionary *)parameter
{
    UIViewController *vc = [self performTarget:@"LoginRegisterViewController" action:@"registerLoginModule" paramter:parameter shouldCacheTarget:true];
    if ([vc isKindOfClass:[UIViewController class]]) {
        return vc;
    } else
    {
        NSLog(@"%@ 未能实例化页面",NSStringFromSelector(_cmd));
        return [UIViewController new];
    }
}

@end
