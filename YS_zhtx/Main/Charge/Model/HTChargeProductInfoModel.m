//
//  HTChargeProductInfoModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/25.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChargeProductInfoModel.h"

@implementation HTChargeProductInfoModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{
             @"productId" : @"id",
             };
}
@end
