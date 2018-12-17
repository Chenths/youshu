//
//  HTBillsViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/9/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustModel.h"
#import "HTCommonViewController.h"

@interface HTBillsViewController : HTCommonViewController

@property (nonatomic,strong) NSString *custId;

@property (nonatomic,strong) HTCustModel *cust;

@end
