//
//  HTCompareReportCenterController.h
//  有术
//
//  Created by mac on 2018/4/27.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTBossCompareViewController.h"
#import "HTCommonViewController.h"

@interface HTCompareReportCenterController : HTCommonViewController
@property (nonatomic,strong) NSString *ids;
@property (nonatomic,strong) NSString *dates;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSArray *companys;
@property (nonatomic,strong) NSArray *selectedDates;
@property (nonatomic,assign) HTSectedType sectedType;
@end
