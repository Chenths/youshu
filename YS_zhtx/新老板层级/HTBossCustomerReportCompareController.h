//
//  HTBossCustomerReportCompareController.h
//  有术
//
//  Created by mac on 2018/4/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^PUSHVC)(void);
#import "HTCommonViewController.h"

@interface HTBossCustomerReportCompareController : HTCommonViewController
@property (nonatomic,strong) NSString *ids;
@property (nonatomic,strong) NSString *dates;
@property (nonatomic,strong) NSString *shopId;
@property (nonatomic,strong) NSString *shopName;
@property (nonatomic,strong) NSArray *companys;
@property (nonatomic,strong) NSArray *selectedDates;
@property (nonatomic,assign) BOOL isTime;
@property (nonatomic,copy) PUSHVC pushVc;
@end
