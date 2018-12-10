//
//  HTParameterSetsCenterController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTMsgSetViewController.h"
#import "HTWarningSetViewController.h"
#import "HTVipLevelAndSaleController.h"
#import "HTParameterSetsCenterController.h"

@interface HTParameterSetsCenterController ()

@end

@implementation HTParameterSetsCenterController


#pragma mark -life cycel
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"参数配置";
    [self initViewControllers];
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44 + 2, screenSize.width, screenSize.height - 44 - 2 - nav_height)];
    self.view.backgroundColor = RGB(0.96, 0.96, 0.98, 1);
//    self.tabBar.itemSelectedBgColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.tabBar.itemTitleColor = [UIColor colorWithHexString:@"#999999"];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHexString:@"#222222"];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
//    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40,( HMSCREENWIDTH/2 - 80)/2, 0, ( HMSCREENWIDTH/2 - 80)/2) tapSwitchAnimated:YES];
//    self.tabBar.itemSelectedBgScrollFollowContent = YES;
//    [self.tabBar setItemSeparatorColor:[UIColor colorWithHexString:@"#FFFFFF"] width:0 marginTop:9 marginBottom:9];
//    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    self.tabBar.badgeTitleFont = [UIFont systemFontOfSize:10];
    [self.tabBar setNumberBadgeMarginTop:2
                       centerMarginRight:17
                     titleHorizonalSpace:10
                      titleVerticalSpace:4];
}


#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
- (void)initViewControllers {
    HTWarningSetViewController *controller1 = [[HTWarningSetViewController alloc] init];
    controller1.yp_tabItemTitle = @"预警参数";
    
    HTMsgSetViewController *controller2 = [[HTMsgSetViewController alloc] init];
    controller2.yp_tabItemTitle = @"消息推送";
    
    HTVipLevelAndSaleController *controller3 = [[HTVipLevelAndSaleController alloc] init];
    controller3.yp_tabItemTitle = @"会员／消费";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2,controller3, nil];
}


#pragma mark - getters and setters

@end
