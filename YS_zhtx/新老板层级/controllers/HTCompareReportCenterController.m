//
//  HTCompareReportCenterController.m
//  有术
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossSaleReportCompareController.h"
#import "HTBossCustomerReportCompareController.h"
#import "HTCompareReportCenterController.h"

@interface HTCompareReportCenterController ()
{
    NSMutableArray *controllers;
    BOOL isFirst;
}
@end

@implementation HTCompareReportCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createVC];
     NSArray * segArr = @[@"销售报表",@"客户分析"];
     UISegmentedControl *titleSegment = [[UISegmentedControl alloc] initWithItems:segArr];
     titleSegment.frame = CGRectMake(0, 0,180 , 30);
     titleSegment.selectedSegmentIndex = 0 ;
     titleSegment.tintColor = [UIColor colorWithHexString:@"222222"];
     [titleSegment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
       self.navigationItem.titleView = titleSegment;
}

- (BOOL)shouldAutorotate{
    return YES;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeRight;
}
-(void) createVC{
    if (!controllers) {
        controllers = [NSMutableArray array];
    }
    
    HTBossSaleReportCompareController *vc = [[HTBossSaleReportCompareController alloc] init];
    HTBossCustomerReportCompareController *vc1 = [[HTBossCustomerReportCompareController alloc] init];

    [controllers addObject:vc];
    [controllers addObject:vc1];
    if (self.sectedType == HTSectedTypeShop) {
        vc.companys = self.companys;
        vc.ids = self.ids;
        vc.isTime = NO;
        
        vc1.companys = self.companys;
        vc1.ids = self.ids;
        vc1.isTime = NO;
    }else{
        vc.dates = self.dates;
        vc.shopId = self.shopId;
        vc.isTime = YES;
        vc.selectedDates = self.selectedDates;
        vc.shopName = self.shopName;
        
        vc1.dates = self.dates;
        vc1.shopId = self.shopId;
        vc1.isTime = YES;
        vc1.selectedDates = self.selectedDates;
        vc1.shopName = self.shopName;
    }
    
}
- (IBAction)compareClicked:(id)sender {
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//     [self attemptro]
    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //刷新
    [UIViewController attemptRotationToDeviceOrientation];
    if (!isFirst) {
        isFirst = YES;
        for (UIView *view in self.view.subviews) {
            [view removeFromSuperview];
        }
        UIViewController *vc =  controllers[0];
        [self.view addSubview:vc.view];
        [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top);
            make.leading.mas_equalTo(self.view.mas_leading);
            make.trailing.mas_equalTo(self.view.mas_trailing);
            make.bottom.mas_equalTo(self.view.mas_bottom);
        }];
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
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top);
                make.leading.mas_equalTo(self.view.mas_leading);
                make.trailing.mas_equalTo(self.view.mas_trailing);
                make.bottom.mas_equalTo(self.view.mas_bottom);
            }];
        }
            break;
            
        case 1:{
            for (UIView *view in self.view.subviews) {
                [view removeFromSuperview];
            }
            UIViewController *vc = controllers[1];
            [self.view addSubview:vc.view];
            [vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top);
                make.leading.mas_equalTo(self.view.mas_leading);
                make.trailing.mas_equalTo(self.view.mas_trailing);
                make.bottom.mas_equalTo(self.view.mas_bottom);
            }];
        }
            break;
    }
}


@end
