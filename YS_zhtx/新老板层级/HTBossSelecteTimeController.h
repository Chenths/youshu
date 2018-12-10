//
//  HTBossSelecteTimeController.h
//  有术
//
//  Created by mac on 2018/4/23.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^CHANGESELECTEDTIME)(NSString *companyName,NSString *companyId,NSArray *dates);
#import "HTCommonViewController.h"

@interface HTBossSelecteTimeController : HTCommonViewController

@property (nonatomic,strong) NSArray *selectedTimes;

@property (nonatomic,strong) CHANGESELECTEDTIME changeselectedTime;

@end
