//
//  HTGuiderDayModel.m
//  YS_zhtx
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderDayModel.h"

@implementation HTGuiderDayModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"Model" : [HTGuiderDayItmeModel class],
             };
}

@end
