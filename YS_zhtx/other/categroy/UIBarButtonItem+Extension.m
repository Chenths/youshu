//
//  UIBarButtonItem+Extension.m
//  大大财经
//
//  Created by yuanmc on 15-5-21.
//  Copyright (c) 2015年 dada. All rights reserved.
//
#import "UIImage+Extension.h"
//#import "MBProgressHUD.h"
#import "UIBarButtonItem+Extension.h"
@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if ([imageName isEqualToString:@"back"]) {
        [button setImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageWithName:highImageName] forState:UIControlStateHighlighted];
        button.frame = CGRectMake(0, 0, 44, 44);
        button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 44 - 11);
    }else{
        [button setBackgroundImage:[UIImage imageWithName:imageName] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithName:highImageName] forState:UIControlStateHighlighted];
        [button sizeToFit];
    }
   
    
    // 监听按钮点击
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)creatBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action{
    
    UIButton *bt = [[UIButton alloc] init];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    bt.titleLabel.font = [UIFont systemFontOfSize:13];
    [bt setTitleColor:[UIColor colorWithHexString:@"222222"] forState:UIControlStateNormal];
    [bt sizeToFit];

    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}
+ (UIBarButtonItem *)creatBarButtonItemWithTitle:(NSString *)title target:(id)target withColor:(UIColor *) color action:(SEL)action{
    
    UIButton *bt = [[UIButton alloc] init];
    [bt setTitle:title forState:UIControlStateNormal];
    [bt addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    bt.titleLabel.font = [UIFont systemFontOfSize:13];
    [bt setTitleColor:color forState:UIControlStateNormal];
    [bt sizeToFit];
    
    return [[UIBarButtonItem alloc] initWithCustomView:bt];
}
@end
