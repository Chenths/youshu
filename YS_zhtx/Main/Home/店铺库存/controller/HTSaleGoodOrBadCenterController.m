//
//  HTSaleGoodOrBadCenterController.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTInventorySaleInfoController.h"
#import "HTSaleGoodOrBadCenterController.h"

@interface HTSaleGoodOrBadCenterController ()

@end

@implementation HTSaleGoodOrBadCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"畅滞销款管理";
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

- (void)initViewControllers {
    HTInventorySaleInfoController *controller1 = [[HTInventorySaleInfoController alloc] init];
    controller1.yp_tabItemTitle = @"畅销款";
    controller1.companyId = self.companyId;
    controller1.saletype = HTSaleGood;
    HTInventorySaleInfoController *controller2 = [[HTInventorySaleInfoController alloc] init];
    controller2.yp_tabItemTitle = @"滞销款";
    controller2.companyId = self.companyId;
    controller2.saletype = HTSaleBad;
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, nil];
}

@end
