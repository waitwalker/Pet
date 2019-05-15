//
//  MTTMediator+WelcomePageTargetAction.m
//  PetGroup
//
//  Created by LiuChuanan on 2018/7/2.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator+WelcomePageTargetAction.h"

@implementation MTTMediator (WelcomePageTargetAction)

- (UIViewController *)registerWelcomePageModuleWithParameter:(NSDictionary *)parameter
{
    UIViewController *viewController = [self performTarget:@"WelcomePageViewController" action:@"registerWelcomePageModule" paramter:parameter shouldCacheTarget:true];
    return viewController;
}

@end
