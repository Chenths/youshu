//
//  HTSecondReportViewController.m
//  有术
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossReportViewController.h"
#import "HTBossCustomerInfoController.h"
#import "HTSecondReportViewController.h"
#import "HTCompareReportCenterController.h"
#import "HTBaceNavigationController.h"
#import "HTRightNavBar.h"
#import "HTMsgCenterViewController.h"
#import "HTMsgCenterViewController.h"
//#import "HTTotleMessgeViewController.h"
#import "UIBarButtonItem+Extension.h"
@interface HTSecondReportViewController ()
{
    NSMutableArray *controllers;
    BOOL isFirst;
}
@property (nonatomic,strong) HTRightNavBar *rightBt ;
@end

@implementation HTSecondReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#222222"]}];
   self.navigationController.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithHexString:@"#222222"];
    HTBaceNavigationController  *nav =(id)self.navigationController;
    nav.imageName = @"返回灰色";
    isFirst = NO;
    [self createVC];
    [self createRightNavBar];
    NSArray * segArr = @[@"销售报表",@"客户分析"];
    UISegmentedControl *titleSegment = [[UISegmentedControl alloc] initWithItems:segArr];
    titleSegment.frame = CGRectMake(0, 0,180 , 30);
    titleSegment.selectedSegmentIndex = 0 ;
    titleSegment.tintColor = [UIColor colorWithHexString:@"222222"];
//    titleSegment.
    [titleSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = titleSegment;
}
- (void)laodNoRedNum{
    
    NSDictionary *dic = @{
                          @"type" :@"",
                          @"state":@"NOTREAD",
                          @"companyId":[HTShareClass shareClass].loginModel.companyId
                          };
    __weak typeof(self) weakSelf = self;
    [HTHttpTools POST:[NSString stringWithFormat:@"%@%@%@",baseUrl,middleNotice,loadUserNoticeCount4App] params:dic success:^(id json) {
        __weak typeof(weakSelf) strongSelf  = weakSelf;
        if (json[@"data"][@"count"]) {
            [strongSelf.rightBt setNumber: [json[@"data"][@"count"] intValue]];
            [HTShareClass shareClass].badge = [json[@"data"][@"count"] stringValue];
        }
    } error:^{
    } failure:^(NSError *error) {
    }];
}
- (void)createRightNavBar{
    
      self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImageName:@"术logo-黑" highImageName:@"术logo-黑" target:self action:nil];
    
    self.rightBt = [[[NSBundle mainBundle] loadNibNamed:@"HTRightNavBar" owner:nil options:nil]  lastObject];
    self.rightBt.imageName = @"消息-黑";
    [self.rightBt baseInit];
    [self.rightBt sizeToFit];
    [self.rightBt addTarget:self action:@selector(rightBtClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.rightBt];
}
- (void)rightBtClicked:(UIButton *)sender{
    [self.navigationController pushViewController:[[HTMsgCenterViewController alloc] init] animated:YES];
}

-(void) createVC{
    if (!controllers) {
        controllers = [NSMutableArray array];
    }

    HTBossReportViewController *vc = [[HTBossReportViewController alloc] init];
    vc.pushVc = ^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    };
    HTBossCustomerInfoController *vc1 = [[HTBossCustomerInfoController alloc] init];
    vc1.pushVc = ^(UIViewController *vc) {
        [self.navigationController pushViewController:vc animated:YES];
    };
    [controllers addObject:vc];
    [controllers addObject:vc1];
    
}
- (IBAction)compareClicked:(id)sender {
    HTCompareReportCenterController *vc = [[HTCompareReportCenterController alloc] init];
    [self.navigationController pushViewController:vc
                                         animated:YES];    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self laodNoRedNum];
    if (!isFirst) {
        isFirst = YES;
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        UIViewController *vc =  controllers[0];
        vc.view.frame = CGRectMake(0, 0, HMSCREENWIDTH , HEIGHT- tar_height - nav_height - SafeAreaBottomHeight);
        [self.view addSubview:vc.view];
    }
}
-(void)segmentAction:(UISegmentedControl *)sender{
    
    NSInteger index =  sender.selectedSegmentIndex;
    
    switch (index) {
        case 0:{
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            UIViewController *vc = controllers[0];
            vc.view.frame = CGRectMake(0, 0, HMSCREENWIDTH , HEIGHT - tar_height - nav_height - SafeAreaBottomHeight);
            [self.view addSubview:vc.view];
        }
            break;
        case 1:{
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            UIViewController *vc = controllers[1];
            vc.view.frame = CGRectMake(0, 0, HMSCREENWIDTH , HEIGHT- tar_height - nav_height - SafeAreaBottomHeight);
            [self.view addSubview:vc.view];
        }
            break;
    }
    
}



@end
