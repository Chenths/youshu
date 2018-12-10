//
//  HTOrderOrProductState.m
//  YS_zhtx
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderOrProductState.h"

@implementation HTOrderOrProductState
/*
 object StateName {
 const val RETURENED = "已退货"
 const val EXCHANGED = "已换货"
 const val CANCELED = "已取消"
 const val CLOSED = "已关闭"
 const val UNPAID = "未支付"
 const val NORMAL = "正常"
 const val PAID = "已支付"
 }
 */
+(NSString *)getOrderStateFormOrderString:(NSString *)state{
    
    if ([state isEqualToString:@"已取消"]) {
        return @"CANCELED";
    }else if ([state isEqualToString:@"已关闭"]){
        return @"CLOSED";
    }else if ([state isEqualToString:@"未支付"]){
        return @"UNPAID";
    }else if([state isEqualToString:@"已支付"]){
        return @"PAID";
    }else{
        return @"orderEXCHANGED";
    }
    
    
}
+(NSString *)getProductStateFormOrderString:(NSString *)state{
    if ([state isEqualToString:@"已退货"]) {
        return @"RETURENED";
    }else if ([state isEqualToString:@"已换货"]){
        return @"EXCHANGED";
    }else{
        return @"NORMAL";
    }
}


@end

