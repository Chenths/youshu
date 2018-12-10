//
//  HWTabBar.m
//  黑马微博2期
//
//  Created by apple on 14-10-8.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HWTabBar.h"
#import "UIView+Extension.h"
//#import "MyWXLogin.h"

@interface HWTabBar()

@end

@implementation HWTabBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    //设置tabbarButton的位置和尺寸
    CGFloat tabbarButtonW = HMSCREENWIDTH / 5;
    CGFloat tabbarButtonIndex = 0;
    for (UIView *child in self.subviews) {
        Class class = NSClassFromString(@"UITabBarButton");
        if ([child isKindOfClass:class]) {
            // 设置宽度
            child.width = tabbarButtonW;
            // 设置x
            child.x = tabbarButtonIndex * tabbarButtonW;
            // 增加索引
            tabbarButtonIndex++;
        }
    }
}

@end
