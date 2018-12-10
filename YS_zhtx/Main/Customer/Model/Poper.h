//
//  Poper.h
//  转场动画
//
//  Created by ddcj_hx on 16/2/2.
//  Copyright (c) 2016年 DZQ. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
typedef void(^DoSomethingTapBcak)(void);
@interface Poper : NSObject <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>{
   BOOL isPop;
}

@property (nonatomic , assign) CGRect frame;

@property (nonatomic,strong) DoSomethingTapBcak dosomethingTapBack;

@property (nonatomic,strong) UIViewController *controlleer ;
@end
