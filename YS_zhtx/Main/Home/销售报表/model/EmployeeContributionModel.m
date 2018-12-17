//
//  EmployeeContributionModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "EmployeeContributionModel.h"

@implementation EmployeeContributionModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"data" : [HTGuideSaleInfoModel class],
             };
}
@end
