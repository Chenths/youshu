//
//  HTPiesModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTPiesModel.h"

@implementation HTPiesModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [HTPieDataItem class],
             };
}
@end
