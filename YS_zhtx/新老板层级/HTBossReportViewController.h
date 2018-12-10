//
//  HTBossReportViewController.h
//  有术
//
//  Created by mac on 2018/4/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
typedef void(^PUSHVC)(UIViewController *vc);
#import "HTCommonViewController.h"

@interface HTBossReportViewController : HTCommonViewController

@property (nonatomic,copy) PUSHVC  pushVc;

@end
