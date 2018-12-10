//
//  UIBarButtonItem+Extension.h
//  大大财经
//
//  Created by yuanmc on 15-5-21.
//  Copyright (c) 2015年 dada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithImageName:(NSString *)imageName highImageName:(NSString *)highImageName target:(id)target action:(SEL)action;

+ (UIBarButtonItem *) creatBarButtonItemWithTitle:(NSString *) title target:(id) target action:(SEL) action ;


+ (UIBarButtonItem *)creatBarButtonItemWithTitle:(NSString *)title target:(id)target withColor:(UIColor *) color action:(SEL)action;

@end
