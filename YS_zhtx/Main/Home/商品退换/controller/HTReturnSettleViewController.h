//
//  HTReturnSettleViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustModel.h"
#import "HTOrderDetailModel.h"
#import "HTCommonViewController.h"

@interface HTReturnSettleViewController : HTCommonViewController

@property (nonatomic,strong) HTCustModel *custModel;

@property (nonatomic,strong) NSString *orderId;

@property (nonatomic,strong) HTOrderDetailModel *orderModel;

@property (nonatomic,assign) BOOL isReturnAll;

@property (nonatomic,strong) NSArray *returnProducts;

@end
