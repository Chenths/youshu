//
//  HTBirthDayCustomerCenterController.m
//  有术
//
//  Created by mac on 2018/1/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBirthdayCustomerListController.h"
#import "HTBirthDayCustomerCenterController.h"

@interface HTBirthDayCustomerCenterController ()

@end

@implementation HTBirthDayCustomerCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"生日祝福";
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

#pragma mark -EventResponse

#pragma mark -private methods
- (void) initViewControllers{
    HTBirthdayCustomerListController *vc1 = [[HTBirthdayCustomerListController alloc] init];
    vc1.yp_tabItemTitle = @"今日生日";
    vc1.htbirthTodayType = HTBirthToday;
    __weak typeof(self) weakSelf = self;
    vc1.selectectNear = ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf.tabBar.selectedItemIndex  = 1;
    };
    HTBirthdayCustomerListController *vc2 = [[HTBirthdayCustomerListController alloc] init];
    vc2.yp_tabItemTitle = @"即将生日";
    vc2.htbirthTodayType = HTBirthNear;
    self.viewControllers = @[vc1,vc2];
    
}
#pragma mark - getters and setters

@end
