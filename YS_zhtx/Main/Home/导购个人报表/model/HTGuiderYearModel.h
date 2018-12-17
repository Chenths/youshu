//
//  HTGuiderYearModel.h
//  YS_zhtx
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderYearItmeModel.h"
#import <Foundation/Foundation.h>

@interface HTGuiderYearModel : NSObject

@property (nonatomic,strong) NSArray *detail;

@property (nonatomic,strong) NSString *salesAmount;

@property (nonatomic,strong) NSString *salesVolume;
@property (nonatomic,strong) NSString *salesCount;

//目标销售额
@property (nonatomic,strong) NSString *targetSales;
//目标完成率
@property (nonatomic,strong) NSString *completion;

@end
