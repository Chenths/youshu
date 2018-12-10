//
//  HTFastCashierViewController.h
//  有术
//
//  Created by mac on 2018/5/14.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTOrderDetailModel.h"
#import "HTCommonViewController.h"

@interface HTChangeFastCashierViewController : HTCommonViewController

@property (nonatomic,strong) HTCustModel *custModel;

@property (nonatomic,strong) NSArray *exchangeArray;

@property (nonatomic,strong) HTOrderDetailModel *orderModel;
@end
