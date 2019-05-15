//
//  MTTMediator.m
//  PetGroup
//
//  Created by LiuChuanan on 2018/6/29.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import "MTTMediator.h"
#import <UIKit/UIKit.h>

@interface MTTMediator()

@property (nonatomic, strong) NSMutableDictionary *cachedTarget;

@end

@implementation MTTMediator

+ (instancetype)sharedMediator
{
    static MTTMediator *mediator;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mediator = [[MTTMediator alloc]init];
    });
    return mediator;
}

/*
 scheme://[target]/[action]?[params]
 
 url sample:
 aaa://targetA/actionB?id=1234
 */
- (id)performActionWithUrl:(NSURL *)url completion:(void (^)(NSDictionary *))completion
{
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    NSString *urlString = [url query];
    for (NSString *para in [urlString componentsSeparatedByString:@"&"]) {
        NSArray *elts = [para componentsSeparatedByString:@"="];
        if (elts.count < 2) {
            continue;
        }
        [parameter setObject:elts.lastObject forKey:elts.firstObject];
    }
    
    NSString *actionName = [url.path stringByReplacingOccurrencesOfString:@"/" withString:@""];
    if ([actionName hasPrefix:@"native"]) {
        return @(false);
    }
    
    id result = [self performTarget:url.host action:actionName paramter:parameter shouldCacheTarget:false];
    if (completion) {
        if (result) {
            completion(@{@"result":result});
        } else {
            completion(nil);
        }
    }
    return result;
    
}

- (id)performTarget:(NSString *)targetName action:(NSString *)actionName paramter:(NSDictionary *)parameter shouldCacheTarget:(BOOL)shouldCacheTarget
{
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@",targetName];
    NSString *actionString = [NSString stringWithFormat:@"Action_%@",actionName];
    Class targetClass;
    
    NSObject *target = self.cachedTarget[targetClassString];
    if (target == nil) {
        targetClass = NSClassFromString(targetClassString);
        target = [[targetClass alloc]init];
    }
    SEL action =NSSelectorFromString(actionName);
    if (target == nil) {
        return nil;
    }
    
    if ([target respondsToSelector:action]) {
        return [self pSafePerformAction:action target:target parameter:parameter];
    } else {
        actionString = [NSString stringWithFormat:@"Action_%@WithParameter:",actionName];
        action = NSSelectorFromString(actionString);
        if ([target respondsToSelector:action]) {
            return [self pSafePerformAction:action target:target parameter:parameter];
        } else {
            [self.cachedTarget removeObjectForKey:targetClassString];
            return nil;
        }
    }
}

#pragma mark private
- (id)pSafePerformAction:(SEL)action target:(NSObject *)target parameter:(NSDictionary *)parameter
{
    NSMethodSignature *methodSig = [target methodSignatureForSelector:action];
    if (methodSig == nil) {
        return nil;
    }
    
    const char * retType = [methodSig methodReturnType];
    
    if (strcmp(retType, @encode(void)) == 0) {
        
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&parameter atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        return nil;
    }
    
    if (strcmp(retType, @encode(NSInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&parameter atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(BOOL)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&parameter atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        BOOL result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(CGFloat)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&parameter atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        CGFloat result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
    
    if (strcmp(retType, @encode(NSUInteger)) == 0) {
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
        [invocation setArgument:&parameter atIndex:2];
        [invocation setSelector:action];
        [invocation setTarget:target];
        [invocation invoke];
        NSUInteger result = 0;
        [invocation getReturnValue:&result];
        return @(result);
    }
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [target performSelector:action withObject:parameter];
#pragma clang diagnostic pop
}


- (void)releaseCachedTargetWithName:(NSString *)targetName
{
    if (targetName == nil) {
        return;
    }
    
    NSString *targetClassString = [NSString stringWithFormat:@"Target_%@",targetName];
    [self.cachedTarget removeObjectForKey:targetClassString];
}

- (NSMutableDictionary *)cachedTarget
{
    if (_cachedTarget == nil) {
        _cachedTarget = [NSMutableDictionary dictionary];
    }
    return _cachedTarget;
}

@end
