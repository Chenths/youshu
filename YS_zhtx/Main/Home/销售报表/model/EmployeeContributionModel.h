//
//  EmployeeContributionModel.h
//  YS_zhtx
//
//  Created by mac on 2018/7/16.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuideSaleInfoModel.h"
#import <Foundation/Foundation.h>

@interface EmployeeContributionModel : NSObject
//散客贡献
@property (nonatomic,strong) NSString *notvipsalescale;
//销售额
@property (nonatomic,strong) NSString *sale;
//vip贡献
@property (nonatomic,strong) NSString *vipsalescale;

@property (nonatomic,strong) NSArray *data;

@end
