//
//  HTOnlineOrderListModel.m
//  有术
//
//  Created by mac on 2018/10/11.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTOnlineOrderListModel.h"

@implementation HTOnlineOrderListModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"orderId" : @"id",
             };
}
@end
