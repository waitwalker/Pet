//
//  MTTMediator+RegisterTargetAction.m
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/25.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator+RegisterTargetAction.h"

@implementation MTTMediator (RegisterTargetAction)

- (UIViewController *)registerRegisterModuleWithParameter:(NSDictionary *)parameter
{
    UIViewController *vc = [self performTarget:@"RegisterViewController" action:@"registerRegisterModule" paramter:parameter shouldCacheTarget:true];
    return vc;
}

@end
