//
//  HTNoticeCenterViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/9/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTNoticeController.h"
#import "HTNoticeListViewController.h"
#import "HTNoticeCenterViewController.h"

@interface HTNoticeCenterViewController ()

@end

@implementation HTNoticeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"定时提醒";
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
    for (int i = 0 ; i < self.tabBar.items.count; i++) {
        YPTabItem *item = self.tabBar.items[i];
        item.contentHorizontalAlignment = i == 0 ? UIControlContentHorizontalAlignmentRight : UIControlContentHorizontalAlignmentLeft;
        item.contentEdgeInsets =  i == 0 ? UIEdgeInsetsMake(0, 0, 0, 24) : UIEdgeInsetsMake(0, 24, 0, 0);
        
    }
    
    
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma EventResponse

#pragma private methods
- (void)initViewControllers {
     HTNoticeController*controller1 = [[HTNoticeController alloc] init];
    controller1.yp_tabItemTitle = @"设置定时";
    controller1.modelId = self.modelId;
    controller1.moduleId = self.moduleId;
    HTNoticeListViewController *controller2 = [[HTNoticeListViewController alloc] init];
    controller2.yp_tabItemTitle = @"定时列表";
    controller2.modelId = self.modelId;
    controller2.moduleId = self.moduleId;
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
}

@end
