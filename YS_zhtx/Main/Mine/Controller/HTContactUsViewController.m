//
//  HTContactUsViewController.m
//  有术
//
//  Created by mac on 2017/4/26.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTFeedbackController.h"
#import "HTContactUsViewController.h"
#import "HTLianxiViewController.h"
@interface HTContactUsViewController ()

@end

@implementation HTContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后服务";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44 + 2, screenSize.width, screenSize.height - 44 - 2 - nav_height)];
    self.view.backgroundColor = RGB(0.96, 0.96, 0.98, 1);
    self.tabBar.itemTitleColor = [UIColor colorWithHexString:@"#999999"];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHexString:@"#222222"];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.badgeTitleFont = [UIFont systemFontOfSize:10];
    [self.tabBar setNumberBadgeMarginTop:2
                       centerMarginRight:17
                     titleHorizonalSpace:10
                      titleVerticalSpace:4];
    [self createSubVc];
}

-(void)createSubVc{
    HTFeedbackController *vc = [[HTFeedbackController alloc] init];
    vc.yp_tabItemTitle = @"问题反馈";
    HTLianxiViewController *vc1 = [[HTLianxiViewController alloc] init];
    vc1.yp_tabItemTitle = @"联系我们";
    self.viewControllers = @[vc,vc1];
}

@end
