//
//  UIView+Rotate.h
//  mainViewRotate
//
//  Created by li.min on 2016/11/4.
//  Copyright © 2016年 limin. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef UIView *(^RotateBlock)(void);
typedef void (^FinishedAnima)(BOOL);
typedef UIView *(^RotateAnimationBlock)(NSInteger,FinishedAnima);
@interface UIView (Rotate)<CAAnimationDelegate>
@property (nonatomic,retain) CAKeyframeAnimation *keyAnimation;
@property (nonatomic,copy) FinishedAnima completion;
- (RotateBlock)topRotate;
- (RotateBlock)bottomRotate;
- (RotateBlock)leftRotate;
- (RotateBlock)rightRotate;
- (RotateBlock)rotateX;
- (RotateBlock)rotateY;
- (RotateAnimationBlock)animationRotate;
@end

