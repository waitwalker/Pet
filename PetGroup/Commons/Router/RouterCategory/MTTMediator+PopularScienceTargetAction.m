//
//  MTTMediator+PopularScienceTargetAction.m
//  PetGroup
//
//  Created by WangJunZi on 2018/7/19.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator+PopularScienceTargetAction.h"

@implementation MTTMediator (PopularScienceTargetAction)

- (UIViewController *)registerPopularScienceModuleWithParameter:(NSDictionary *)parameter
{
    UIViewController *popularScienceVC = [self performTarget:@"PopularScienceViewController" action:@"registerPopularScienceModule" paramter:parameter shouldCacheTarget:true];
    return popularScienceVC;
}

@end
