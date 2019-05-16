//
//  HTNewReturnAndChangeViewController.h
//  YS_zhtx
//
//  Created by mac on 2019/4/11.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//
#import "HTCommonViewController.h"
#import "HTChargeOrderModel.h"
#import "HTCustModel.h"
#import "HTOrderDetailModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HTNewReturnAndChangeViewController : HTCommonViewController

//@property (nonatomic,strong) NSString *addUrl;
//
//@property (nonatomic,strong) NSString *payCode;

@property (nonatomic,strong) NSString *requestNum;

@property (nonatomic,strong) NSArray *products;

@property (nonatomic,strong) HTCustModel *custModel;
//如果是简易下单
@property (nonatomic, assign) BOOL isFromFast;
@property (nonatomic, strong) NSString *bcProductStr;
//拷贝过来新增的
@property (nonatomic, assign) NSString *orderId;
@property (nonatomic, assign) BOOL isReturnAll;
@property (nonatomic, strong) NSMutableArray *returnProducts;
//@property (nonatomic,strong) HTChargeOrderModel *orderModel;
@property (nonatomic,strong) HTOrderDetailModel *orderModel;
@end

NS_ASSUME_NONNULL_END
