//
//  HTBaceNavigationController.m
//  shengyijing
//
//  Created by mac on 16/3/9.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//
#import "HTChargeViewController.h"
#import "HTBaceNavigationController.h"
#import "UIBarButtonItem+Extension.h"
@interface HTBaceNavigationController ()<UINavigationBarDelegate>

@end

@implementation HTBaceNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
    [self.navigationBar setBarTintColor:[UIColor whiteColor]];
    //导航条不透明
    self.navigationBar.translucent = NO;
}


/**
 *  能拦截所有push进来的子控制器
 */
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
        // 设置导航栏按钮
//        self.interactivePopGestureRecognizer.delegate = (id)viewController;
    }
    [super pushViewController:viewController animated:animated];
}
- (void)back
{
    [self popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
