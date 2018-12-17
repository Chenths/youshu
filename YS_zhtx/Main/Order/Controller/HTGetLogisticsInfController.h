//
//  HTGetLogisticsInfController.h
//  YS_zhtx
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderDetailModel.h"
#import "HTCommonViewController.h"

@interface HTGetLogisticsInfController : HTCommonViewController

@property (nonatomic,strong) NSString *orderId;

@property (nonatomic,strong) HTOrderDetailModel *orderModel;

@property (nonatomic,strong) NSArray *goodsArray;

@end
