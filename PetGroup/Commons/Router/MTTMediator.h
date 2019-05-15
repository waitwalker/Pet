//
//  MTTMediator.h
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/29.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@interface MTTMediator : NSObject

+ (instancetype)sharedMediator;

- (id)performActionWithUrl:(NSURL *)url completion:(void(^)(NSDictionary *info))completion;

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName paramter:(NSDictionary *)parameter shouldCacheTarget:(BOOL)shouldCacheTarget;
- (void)releaseCachedTargetWithName:(NSString *)targetName;

@end
