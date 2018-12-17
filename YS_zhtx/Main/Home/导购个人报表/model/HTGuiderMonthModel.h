//
//  HTGuiderMonthModel.h
//  YS_zhtx
//
//  Created by mac on 2018/10/9.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTGuiderMonthIterModel.h"
#import <Foundation/Foundation.h>

@interface HTGuiderMonthModel : NSObject
//总销售额
@property (nonatomic,strong) NSString *salesAmount;
//总吊牌价
@property (nonatomic,strong) NSString *salesPrice;
//总销量
@property (nonatomic,strong) NSString *salesVolume;
//总订单量
@property (nonatomic,strong) NSString *salesCount;
//目标销售额
@property (nonatomic,strong) NSString *targetSales;
//目标完成率
@property (nonatomic,strong) NSString *completion;



@property (nonatomic,strong) NSArray *detail;


@end
