//
//  HTContinueBackModel.m
//  YS_zhtx
//
//  Created by mac on 2018/9/3.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTContinueBackModel.h"

@implementation HTContinueBackModel

-(NSString *)date{
    if (!_date) {
        NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
        [yearF1 setDateFormat:@"YYYY-MM-dd"];
        NSString *today    = [yearF1 stringFromDate:[NSDate date]];
        return today;
    }
    return _date;
}
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
             @"date" : @"create_date",
             @"desc" : @"followcontent",
             @"modelId":@"id"
             };
}

@end
