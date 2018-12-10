//
//  HTOrderDetailModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderCustomerModel.h"
#import "HTOrderDetailProductModel.h"
#import "HTOrderDetailExchangesModel.h"

#import <Foundation/Foundation.h>

@interface HTOrderDetailModel : NSObject
//创建时间
@property (nonatomic,strong) NSString *createdate;
//导购
@property (nonatomic,strong) NSString *creator;
//会员信息
@property (nonatomic,strong) HTOrderCustomerModel *customer;
//折扣
@property (nonatomic,strong) NSString *discount;
//结算价
@property (nonatomic,strong) NSString *finalprice;
//是否改价
@property (nonatomic,strong) NSString *hasmodifiedprice;
//订单号
@property (nonatomic,strong) NSString *ordernum;
//订单状态
@property (nonatomic,strong) NSString *orderstatus;
//订单支付方式
@property (nonatomic,strong) NSString *paytype;
//微信或者支付宝支付方式
@property (nonatomic,strong) NSString *mpaymenttype;
//订单正常产品
@property (nonatomic,strong) NSArray *product;
//订单备注
@property (nonatomic,strong) NSString *remark;
//订单原价
@property (nonatomic,strong) NSString *totalprice;
//订单退换货列表
@property (nonatomic,strong) NSArray *returnandexchangeproduct;
//订单图片
@property (nonatomic,strong) NSArray *orderimage;

@property (nonatomic,strong) NSString *orderId;


@end
