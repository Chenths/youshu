//
//  HTStyleInventoryModel.m
//  YS_zhtx
//
//  Created by mac on 2018/9/14.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTStyleInventoryModel.h"

@implementation HTStyleInventoryModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"stock" : [HTStockInfoModel class],
             };
}

@end
