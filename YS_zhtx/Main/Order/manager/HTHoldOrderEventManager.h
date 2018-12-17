//
//  HTHoldOrderEventManager.h
//  YS_zhtx
//
//  Created by mac on 2018/9/10.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HTHoldOrderEventManager : NSObject

+(void)printOrderInfoWithOrderId:(NSString *)orderId;

+(void)addTimerForOrderWithOrderId:(NSString *)orderId;

+(void)exchangeOrReturnOrderWithOrderId:(NSString *)orderId;

+(void)postImgsForOrderWithOrderId:(NSString *)orderId;

+(void)seeOrderDetailWithOrderId:(NSString *)orderId;

@end
