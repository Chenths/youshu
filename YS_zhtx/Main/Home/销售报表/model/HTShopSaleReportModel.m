//
//  HTShopSaleReportModel.m
//  YS_zhtx
//
//  Created by mac on 2018/7/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "NSDate+Manager.h"
#import "HTShopSaleReportModel.h"

@implementation HTShopSaleReportModel
+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{
             @"amountList" : [HTSingleLineReportModel class],
             @"bigOrderMap":[HTBigOrderModel class],
             @"productRank":[HTProductRankInfoModel class]
             };
}
-(NSString *)beginTime{
    if (_beginTime.length == 0) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
        [yearF2 setDateFormat:@"dd"];
        NSString *whichDay = [yearF2 stringFromDate:[NSDate date]];
        NSString *thisMonth = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-1 * (whichDay.integerValue - 1)]];
        return thisMonth;
    }
    return _beginTime;
}
-(NSString *)endTime{
    if (_endTime.length == 0) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
        [yearF2 setDateFormat:@"dd"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        return today;
    }
    return _endTime;
}
-(NSString *)productEndTime{
    if (_productEndTime.length == 0) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
        [yearF2 setDateFormat:@"dd"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        return today;
    }
    return _productEndTime;
}
-(NSString *)productBeginTime{
    if (_productBeginTime.length == 0) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSDateFormatter * yearF2 = [[NSDateFormatter alloc] init];
        [yearF2 setDateFormat:@"dd"];
        NSString *whichDay = [yearF2 stringFromDate:[NSDate date]];
        NSString *thisMonth = [yearF1 stringFromDate:[[NSDate date] dateBySubingDays:-1 * (whichDay.integerValue - 1)]];
        return thisMonth;
    }
    return _productBeginTime;
}
-(NSString *)season{
    if (_season.length == 0) {
        return @"0";
    }
    return _season;
}
@end
