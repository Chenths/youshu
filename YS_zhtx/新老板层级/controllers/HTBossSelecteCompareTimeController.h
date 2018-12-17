//
//  HTBossSelecteTimeController.h
//  有术
//
//  Created by mac on 2018/5/3.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^SENDTIMES)(NSString *beginTime, NSString *endTime);
#import "HTCommonViewController.h"

@interface HTBossSelecteCompareTimeController : HTCommonViewController

@property (nonatomic,copy) SENDTIMES sendTime;

@end
