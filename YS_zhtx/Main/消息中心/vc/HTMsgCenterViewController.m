//
//  HTMsgCenterViewController.m
//  YS_zhtx
//
//  Created by mac on 2018/10/8.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "JCHATConversationListViewController.h"
#import "HTMessegeViewController.h"
#import "HTMsgCenterViewController.h"

@interface HTMsgCenterViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *headScollerView;

@end

@implementation HTMsgCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"消息中心";
    [self initViewControllers];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 0, screenSize.width, 44)
            contentViewFrame:CGRectMake(0, 44 + 2, screenSize.width, screenSize.height - 44 - 2 - nav_height)];
    self.tabBar.itemTitleColor = [UIColor colorWithHexString:@"#999999"];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithHexString:@"#222222"];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:14];
    self.tabBar.itemTitleSelectedFont = [UIFont boldSystemFontOfSize:17];
    self.tabBar.leadingSpace = 0;
    self.tabBar.trailingSpace = 0;
    self.tabBar.itemFontChangeFollowContentScroll = YES;
    self.tabBar.indicatorScrollFollowContent = YES;
    self.tabBar.indicatorColor = [UIColor clearColor];
    [self.tabBar setNumberBadgeMarginTop:2 centerMarginRight:15 titleHorizonalSpace:8 titleVerticalSpace:2];
    [self.tabBar setIndicatorWidth:40 marginTop:40 marginBottom:0 tapSwitchAnimated:NO];
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:20];
    [self.tabContentView setContentScrollEnabled:YES tapSwitchAnimated:NO];
    self.tabContentView.loadViewOfChildContollerWhileAppear = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self laodSystemNum];
    [self laodNotDoNum];
    [self laodWillDoNum];
    [self laodTuntNum];
}
- (void)initViewControllers {
    HTMessegeViewController *controller1 = [[HTMessegeViewController alloc] init];
    controller1.yp_tabItemTitle = @"系统消息";
    controller1.state = @"ISNOTICE";
    controller1.type = @"SYS_LIST";
    controller1.showState = NO;
    HTMessegeViewController *controller2 = [[HTMessegeViewController alloc] init];
    controller2.yp_tabItemTitle = @"待办事项";
    controller2.state = @"ISNOTICE";
    controller2.type = @"JOB_LIST";
    controller2.showState = NO;
    HTMessegeViewController *controller3 = [[HTMessegeViewController alloc] init];
    controller3.yp_tabItemTitle = @"工作计划";
    controller3.state = @"ALL";
    controller3.showState = NO;
    controller3.type = @"USER_LIST";
    HTMessegeViewController *controller4 = [[HTMessegeViewController alloc] init];
    controller4.yp_tabItemTitle = @"库存消息";
    controller4.state = @"ALL";
    controller4.showState = YES;
    controller4.type = @"BILL_MANIFEST";
    
    if ([HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].JMessageUserId].length > 0) {
        JCHATConversationListViewController *chatViewController = [[JCHATConversationListViewController alloc] init];
        chatViewController.yp_tabItemTitle = @"微信消息";
        self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2,controller3,controller4,chatViewController, nil];
    }else{
         self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2,controller3,controller4, nil];
    }

//    HTMessegeViewController *controller5 = [[HTMessegeViewController alloc] init];
//    controller5.yp_tabItemTitle = @"微信消息";
//    controller5.state = @"ALL";
//    controller5.showState = YES;
//    controller5.type = @"BILL_MANIFEST";
//    HTMessegeViewController *controller6 = [[HTMessegeViewController alloc] init];
//    controller6.yp_tabItemTitle = @"微信消息1";
//    controller6.state = @"ALL";
//    controller6.showState = YES;
//    controller6.type = @"BILL_MANIFEST";
//    HTMessegeViewController *controller7 = [[HTMessegeViewController alloc] init];
//    controller7.yp_tabItemTitle = @"微信消息2";
//    controller7.state = @"ALL";
//    controller7.showState = YES;
//    controller7.type = @"BILL_MANIFEST";
//    HTMessegeViewController *controller8 = [[HTMessegeViewController alloc] init];
//    controller8.yp_tabItemTitle = @"微信消息3";
//    controller8.state = @"ALL";
//    controller8.showState = YES;
//    controller8.type = @"BILL_MANIFEST";
//    HTMessegeViewController *controller9 = [[HTMessegeViewController alloc] init];
//    controller9.yp_tabItemTitle = @"微信消息4";
//    controller9.state = @"ALL";
//    controller9.showState = YES;
//    controller9.type = @"BILL_MANIFEST";
//    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2,controller3,controller4,controller5,controller6,controller7,controller8,controller9, nil];
}
//系统消息
/*
 会员维护
 VIP_FEEDBACK,
 新订单提醒
 NEW_ORDER,
 日报表通知
 DAY_REPORT,
 * 周报表通知
 
 WEEK_REPORT,
 
 月报表通知
 MONTH_REPORT,
 * 系统消息提醒
 SYSTEM,
 * 用户自定义通知
 
 MODEL,
 SYS_LIST{
 NEW_ORDER,
 SYSTEM
 },
 JOB_LIST{
 VIP_FEEDBACK,
 DAY_REPORT,
 WEEK_REPORT,
 MODEL,
 MONTH_REPORT
 };
 */
//state
/*
 ALL
 WILL
 ISNOTICE
 NOTREAD
 READ
 DEL
 */
- (void)laodSystemNum{
    
    NSDictionary *dic = @{
                          @"type" :@"SYS_LIST",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        
        if (json[@"data"][@"count"]) {
            for (HTMessegeViewController *vc in self.viewControllers) {
                if ([vc.yp_tabItemTitle isEqualToString:@"系统消息"]) {
                    vc.yp_tabItem.badge = (NSUInteger)[json[@"data"] getFloatWithKey:@"count"];
                    break;
                }
            }
        }
    } error:^{
        
    } failure:^(NSError *error) {
        
    }];
}
//待办事项
- (void)laodNotDoNum{
    
    NSDictionary *dic = @{
                          @"type" :@"JOB_LIST",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        
        if (json[@"data"][@"count"]) {
            for (HTMessegeViewController *vc in self.viewControllers) {
                if ([vc.yp_tabItemTitle isEqualToString:@"报表消息"]) {
                    vc.yp_tabItem.badge = (NSUInteger)[json[@"data"] getFloatWithKey:@"count"];
                    break;
                }
            }
        }
    } error:^{
        
    } failure:^(NSError *error) {
        
    }];
}
//工作计划
- (void)laodWillDoNum{
    
    NSDictionary *dic = @{
                          @"type" :@"USER_LIST",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        
        if (json[@"data"][@"count"]) {
            
            for (HTMessegeViewController *vc in self.viewControllers) {
                if ([vc.yp_tabItemTitle isEqualToString:@"工作计划"]) {
                    vc.yp_tabItem.badge = (NSUInteger)[json[@"data"] getFloatWithKey:@"count"];
                    break;
                }
            }
        }
    } error:^{
        
    } failure:^(NSError *error) {
        
    }];
}
//工作计划
- (void)laodTuntNum{
    
    NSDictionary *dic = @{
                          @"type" :@"BILL_MANIFEST",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    [HTHttpTools GET:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        
        if (json[@"data"][@"count"]) {
            
            for (HTMessegeViewController *vc in self.viewControllers) {
                if ([vc.yp_tabItemTitle isEqualToString:@"库存消息"]) {
                    vc.yp_tabItem.badge = (NSUInteger)[json[@"data"] getFloatWithKey:@"count"];
                    break;
                }
            }
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}

- (void)tabContentView:(YPTabContentView *)tabConentView didSelectedTabAtIndex:(NSUInteger)index{
    if (self.tabBar.selectedItemIndex == 1) {
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem  creatBarButtonItemWithTitle:@"标记为已读" target:self action:@selector(clearClicked:)];
    }else{
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)clearClicked:(UIBarButtonItem *)sender{
    
    
    NSDictionary *dic = @{
                          @"companyId" : [HTShareClass shareClass].loginModel.companyId,
                          @"type":@"JOB_LIST"
                          
                          };
    [MBProgressHUD showMessage:@""];
    __weak typeof(self) weakSelf = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@admin/api/notice/read_all_4_app.html",baseUrl] params:dic success:^(id json) {
        [MBProgressHUD hideHUD];
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf laodNotDoNum];
        [strongSelf laodWillDoNum];
        HTMessegeViewController *vc =(id) self.viewControllers[1];
        [vc loadDadaWithPage:1];
    } error:^{
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:SeverERRORSTRING];
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"请检查你的网络"];
    }];
}
@end
