//
//  HTChangePriceViewController.h
//  YS_zhtx
//
//  Created by mac on 2018/6/15.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTChargeOrderModel.h"
#import "HTCustModel.h"
#import "HTCommonViewController.h"
typedef void(^DIDCHANGE)(NSArray *backArray,NSString *wechatPayOrderId,NSString *finalPrice,NSString *payCode);

typedef void(^DIDOrderPay)();

@interface HTChangePriceViewController : HTCommonViewController

@property (nonatomic,strong) NSArray *dataArray;

@property (nonatomic,strong) NSArray *oldDataArray;

@property (nonatomic,strong) HTChargeOrderModel *orderModel;

@property (nonatomic,strong) HTCustModel *custModel;

@property (nonatomic,assign) BOOL isReturn;

@property (nonatomic,copy) DIDCHANGE didChange;

@property (nonatomic,copy) DIDOrderPay didpay;

@property (nonatomic,strong) NSString *changePrice;

@end
