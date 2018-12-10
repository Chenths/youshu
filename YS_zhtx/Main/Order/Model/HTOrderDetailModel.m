//
//  HTOrderDetailModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderDetailModel.h"

@implementation HTOrderDetailModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"product" : [HTOrderDetailProductModel class],
             @"returnandexchangeproduct":[HTOrderDetailExchangesModel class]
             };
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"orderId" : @"id",
             };
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
