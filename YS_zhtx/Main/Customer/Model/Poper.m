//
//  Poper.m
//  转场动画
//
//  Created by ddcj_hx on 16/2/2.
//  Copyright (c) 2016年 DZQ. All rights reserved.
//

#import "Poper.h"
#import <UIKit/UIKit.h>
//#import "DDMyPresentationController.h"
@implementation Poper
#pragma mark transitioningDelegate
//只要实现来以下方法  所有的细节都要自己写
/**
 *  告诉系统谁来扶着Model的展示动画
 *
 *  @param presented  被展现的仕途
 *  @param presenting 发起的试图
 *  @param source
 *
 *  @return 谁来负责
 */
- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    isPop =  YES;
    return self;
}

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    isPop = NO;
    return self;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext{
    return 0.5f;
}
/**
 *  如何动画  无论是展现还是消失动画
 *
 *  @param transitionContext 上下文  里面保存了动画需要的所有参数
 */
- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    
    if (isPop) {
        
        UIView *toView = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey].view;
        
        [self containerViewWillLayoutSubviewsWithView:toView andBackView:transitionContext.containerView];
        _controlleer = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

        toView.y = HEIGHT;
        [transitionContext.containerView addSubview:toView];
        [UIView animateWithDuration:0.3 animations:^{
            toView.y = HEIGHT - self.frame.size.height;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        
         UIView *fromView = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey ].view;
        
        [UIView animateWithDuration:0.3 animations:^{
            fromView.y = HEIGHT;
        } completion:^(BOOL finished) {
            [transitionContext completeTransition:YES];
        }];
        
    }
    
    
}
- (void)containerViewWillLayoutSubviewsWithView:(UIView *)toView  andBackView:(UIView *)backView{
    
    // 设置即将跳转页面的frame
    toView.frame  = _frame;
    //
    
    //遮罩
    UIView *v                   = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    v.backgroundColor           = [UIColor blackColor];
    v.alpha                     = 0.2f;
    v.userInteractionEnabled    = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    [v addGestureRecognizer:tap];
    [backView insertSubview:v atIndex:0];
    
}

- (void)dismissView{
    if (self.dosomethingTapBack) {
        self.dosomethingTapBack();
    }else{
        if (_controlleer) {
            [_controlleer dismissViewControllerAnimated:YES completion:nil];
        }  
    }
    
}

@end
