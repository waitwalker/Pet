//
//  MTTWaterWaveView.h
//
//
//  Created by WangJunZi on 2018/8/26.
//  Copyright © 2018年 waitWalker. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MTTWaterWaveViewDelegate <NSObject>

@optional
- (void)dTappedImageViewCallBack;

@end

@interface MTTWaterWaveView : UIView

@property (nonatomic, weak) id<MTTWaterWaveViewDelegate> DDelegate;

@end
