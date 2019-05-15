//
//  MTTMediator+PersonalTargetAction.m
//  PetGroup
//
//  Created by WangJunZi on 2018/7/19.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator+PersonalTargetAction.h"

@implementation MTTMediator (PersonalTargetAction)

- (UIViewController *)registerPersonalModuleWithParameter:(NSDictionary *)parameter
{
    UIViewController *personalVC = [self performTarget:@"PersonalViewController" action:@"registerPersonalModule" paramter:parameter shouldCacheTarget:true];
    return personalVC;
}

@end
