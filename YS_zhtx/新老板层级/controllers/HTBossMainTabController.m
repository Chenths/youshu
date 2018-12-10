//
//  HTBossMainTabController.m
//  有术
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
//#import "HTBossFirstNavController.h"
#import "HTBossHomeBasicInfoController.h"
#import "HTBossReportViewController.h"
#import "HTBossInventoryReportController.h"
#import "HTBossMeViewController.h"
#import "HTBossMainTabController.h"
#import "HTSecondReportViewController.h"
#import "HTBaceNavigationController.h"
//#import "HTJumpTools.h"
@interface HTBossMainTabController()
{
    NSArray *arr;
}
@end
@implementation HTBossMainTabController
#pragma mark -life cycel
- (void)viewDidLoad{
    [super viewDidLoad];
    HTBossHomeBasicInfoController *vc = [[HTBossHomeBasicInfoController alloc] init];
    vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[[UIImage imageNamed:@"首页"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[[UIImage imageNamed:@"首页-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ];
    HTSecondReportViewController *vc2 = [[HTSecondReportViewController alloc] init];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"报表" image:[[UIImage imageNamed:@"报表-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]selectedImage:[[UIImage imageNamed:@"报表"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] ];
    HTBossInventoryReportController *vc3 = [[HTBossInventoryReportController alloc] init];
    vc3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"库存" image:[[UIImage imageNamed:@"库存"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] selectedImage:[[UIImage imageNamed:@"库存-1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ] ];
    HTBossMeViewController *vc4 = [[HTBossMeViewController alloc] init];
    vc4.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[[UIImage imageNamed:@"我的"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]  selectedImage:[[UIImage imageNamed:@"我的-1"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
    arr = @[vc,vc2,vc3,vc4];
    NSMutableArray *controls = [NSMutableArray array];
    for (int  i = 0 ; i < arr.count ; i++) {
        UIViewController *vc = arr[i];
        vc.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        vc.navigationItem.leftBarButtonItem.tintColor = [UIColor whiteColor];
        vc.navigationItem.leftBarButtonItem.tag = 900 + i ;
        vc.navigationItem.rightBarButtonItem.tag = 800 + i ;
        HTBaceNavigationController *nav = [[HTBaceNavigationController alloc] initWithRootViewController:vc];
        [controls addObject:nav];
    }
    self.tabBar.tintColor = [UIColor colorWithHexString:@"#222222"];
    self.viewControllers = controls;
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [MBProgressHUD hideHUD];
    if ([[HTShareClass shareClass].jumpType  length] > 0 ) {
        if ([[HTShareClass shareClass].jumpType isEqualToString:@"TUNE_MANIFEST_OUT"]|| [[HTShareClass shareClass].jumpType isEqualToString:@"TUNE_MANIFEST_IN"]) {
        }else{
            [self chageMessgeStateWith:[HTShareClass shareClass].jumpDic[@"noticeId"]];
        }
    }
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}

- (BOOL)shouldAutorotate
{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.selectedViewController supportedInterfaceOrientations];
}
#pragma mark -UITabelViewDelegate

#pragma mark -CustomDelegate

#pragma mark -EventResponse

#pragma mark -private methods
- (void)chageMessgeStateWith:(NSString *) msgId{
    NSDictionary *dic = @{
                          @"id":[msgId length] > 0 ? msgId : @"",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,userReadNotice4App] params:dic success:^(id json) {
    } error:^{
    } failure:^(NSError *error) {
    }];
}
#pragma mark - getters and setters
@end
