//
//  HTMineModel.m
//  YS_zhtx
//
//  Created by mac on 2018/10/23.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMineModel.h"

@implementation HTMineModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"amountList" : [HTSingleLineReportModel class],
             };
}

@end