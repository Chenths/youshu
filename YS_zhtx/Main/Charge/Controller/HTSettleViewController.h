//
//  HTSettleViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustModel.h"
#import "HTChargeOrderModel.h"
#import "HTCommonViewController.h"

@interface HTSettleViewController : HTCommonViewController

@property (nonatomic,strong) HTChargeOrderModel *orderModel;

@property (nonatomic,strong) NSString *addUrl;

@property (nonatomic,strong) NSString *payCode;

@property (nonatomic,strong) NSString *requestNum;

@property (nonatomic,strong) NSArray *products;

@property (nonatomic,strong) HTCustModel *custModel;


@end
