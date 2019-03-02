//
//  HTPrinterModel.h
//  24小助理
//
//  Created by mac on 16/9/2.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum payType
{
    cashType,//现金支付
    posType,//刷卡支付
    storedType,//储值制服
    aliType,//支付宝扫码支付
    storedSendType,//储值赠送支付
    alipayType,
    wetchatType,
    mixType,//组合支付
}payType;

@interface HTPrinterModel : NSObject
//订单id
@property (nonatomic,copy) NSString *orderId;
//订单号
//PROSTR(orderNo);
@property (nonatomic,copy) NSString *orderNo;
// 款号，色号，尺寸 原价 折扣  售价
@property (nonatomic,strong) NSMutableArray *goodsList;

//订单总价
//PROSTR(orderTotalPrize);
@property (nonatomic,copy) NSString *orderTotalPrize;
//结算价
//PROSTR(orderFinalPrize);
@property (nonatomic,copy) NSString *orderFinalPrize;

//积分
//PROSTR(points);
@property (nonatomic,copy) NSString *points;

@property (nonatomic,copy) NSString *discount;

//优惠卷
//PROSTR(coupons);
@property (nonatomic,copy) NSString *coupons;
//储值消费
//PROSTR(storeValue);
@property (nonatomic,copy) NSString *storeValue;

@property (nonatomic,copy) NSString *freeStoreValue;
//时间
//PROSTR(time);
@property (nonatomic,copy) NSString *date;
//支付类型
@property (nonatomic,assign) payType paytype;
//是否改过价
@property (nonatomic,assign) BOOL modifyPrice;

//退换货打印单子
//导购
@property (nonatomic,strong) NSString *returnGuider;
//退换货订单号
@property (nonatomic,strong) NSString *returnOrderId;
//退货列表
@property (nonatomic,strong) NSMutableArray *returnGoodsList;
//换货列表
@property (nonatomic,strong) NSMutableArray *exchangeGoodsList;
//退换货总价
@property (nonatomic,strong) NSString *returnOrderFinalPrice;
//退换货支付方式
@property (nonatomic,assign) payType returnPayType;
//退换货优惠卷
@property (nonatomic,copy) NSString *returnCoupons;
//退货储值消费
@property (nonatomic,copy) NSString *returnStoreValue;

@property (nonatomic,copy) NSString *returnFreeStoreValue;
//换货积分使用情况
@property (nonatomic,copy) NSString *returnTime;
//退货积分使用情况
@property (nonatomic,copy) NSString *returnPoints;

@property (nonatomic,copy) NSString *returnOrderNo;

@property (nonatomic,copy) NSString *telPhone;

@property (nonatomic,strong) NSString *orderDesc;

@property (nonatomic,strong) NSMutableDictionary *lastOrderPrintDic;

@property (nonatomic,strong) NSMutableArray *afterSalesList;
//组合销售新增多人销售名字
@property (nonatomic, strong) NSString *salerName;
@end
