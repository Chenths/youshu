//
//  HTMyShopCustomersCenterController.m
//  有术
//
//  Created by mac on 2017/11/1.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//
#import "HTOnlineCustomerListViewController.h"
#import "HTMyShopCustomersCenterController.h"

@interface HTMyShopCustomersCenterController ()

@end

@implementation HTMyShopCustomersCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"进店客户";
    
    NSString *dateStr = @"";
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:dateStr forKey:@"faceList"];
    [user synchronize];
    
    [self initViewControllers];
    
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
    HTOnlineCustomerListViewController *controller1 = [[HTOnlineCustomerListViewController alloc] init];
    controller1.yp_tabItemTitle = @"会员";
    controller1.usrType = HTUSRERVIP;
    HTOnlineCustomerListViewController *controller2 = [[HTOnlineCustomerListViewController alloc] init];
    controller2.yp_tabItemTitle = @"散客";
    controller2.usrType = HTUSRERNOTVIP;
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
}


@end
