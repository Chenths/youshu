//
//  NSDate+Manager.h
//  24小助理
//
//  Created by mac on 16/5/3.
//  Copyright © 2016年 zhtxwl_hx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Manager)
//几年后
- (NSDate *)dateByAddingYears:(NSInteger)years;
//几月后
- (NSDate *)dateByAddingMonths:(NSInteger)months;
//几周后
- (NSDate *)dateByAddingWeeks:(NSInteger)weeks;
//几天后
- (NSDate *)dateBySubingDays:(NSInteger)days;
//几个小时后
- (NSDate *)dateByAddingHours:(NSInteger)hours;
//几分钟后
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
//几秒后
- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;



@end
