//
//  HTCustomersInfoReprotModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomersInfoReprotModel.h"

@implementation HTCustomersInfoReprotModel


+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"addCustomer" : [HTSingleLineReportModel class],
             @"amountDistribute" : [HTHorizontalReportDataModel class],
             @"amountDistribute2": [HTHorizontalReportDataModel class],
             @"customerConsumeTimeApp" : [HTHorizontalReportDataModel class],
             @"customerConsumeTimeApp2": [HTHorizontalReportDataModel class],
             @"consume" :[HTRankReportSingleCustomerModel class],
             @"storeAccount":[HTRankReportSingleCustomerModel class],
             };
}

@end
