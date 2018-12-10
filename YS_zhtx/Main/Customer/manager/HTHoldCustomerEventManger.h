//
//  HTHoldCustomerEventManger.h
//  YS_zhtx
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTCustModel.h"
#import <Foundation/Foundation.h>

@interface HTHoldCustomerEventManger : NSObject

+(void)storedForCustomerWithCustomerPhone:(NSString *)tel;

+(void)deduedForCustomerWithCustomerPhone:(NSString *)tel;

+(void)editCustomerWithCustomerId:(NSString *)customerId;

+(void)addTimerForCustomerWithCustomerId:(NSString *)customerId;

+(void)lookCustomerBillListWithCustomerId:(NSString *)customerId andCustModel:(HTCustModel *)cust;

+(void)chatWithCustomerWithCustomerId:(NSString *)customerId  customerName:(NSString *)customerName andOpenId:(NSString *)openId;

+(void)callCustomerWithCustomerPhone:(NSString *)telPhone;

@end
