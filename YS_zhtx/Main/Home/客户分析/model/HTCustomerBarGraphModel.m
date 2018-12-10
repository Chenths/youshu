//
//  HTCustomerBarGraphModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomerBarGraphModel.h"

@implementation HTCustomerBarGraphModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"labellist" : [HTBarGraphSingleModel class],
             };
}

@end
