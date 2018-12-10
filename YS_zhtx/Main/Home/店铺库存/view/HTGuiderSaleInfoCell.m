//
//  HTRecordListCell.m
//  有术
//
//  Created by mac on 2017/6/28.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTGuiderSaleInfoCell.h"

@interface HTGuiderSaleInfoCell()



@property (weak, nonatomic) IBOutlet UILabel *weakDate;

@property (weak, nonatomic) IBOutlet UILabel *timeDate;


@property (weak, nonatomic) IBOutlet UILabel *totlePrice;

@property (weak, nonatomic) IBOutlet UILabel *finalPrcie;



@end

@implementation HTGuiderSaleInfoCell


- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    
    
    
    
//    
    NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
    [yearF1 setDateFormat:@"YYYY-MM-dd"];
    NSDate *date = [dataDic getStringWithKey:@"crtTime"].length >= 10 ?  [yearF1 dateFromString:[[dataDic getStringWithKey:@"crtTime"] substringWithRange:NSMakeRange(0, 10)]]  : [yearF1 dateFromString:[dataDic getStringWithKey:@"crtTime"]];
     self.timeDate.text = [NSString stringWithFormat:@"%@",[dataDic getStringWithKey:@"crtTime"].length >= 10 ? [[dataDic getStringWithKey:@"crtTime"]substringWithRange:NSMakeRange(0, 10)]: [dataDic getStringWithKey:@"crtTime"]];
    self.weakDate.text = [self weekdayStringFromDate:date];
    self.totlePrice.text = [NSString stringWithFormat:@"类型：%@",[dataDic getStringWithKey:@"optTypeName"]];
    self.finalPrcie.text = [NSString stringWithFormat:@"数量：%@件",[dataDic getStringWithKey:@"stockChange"]];;
}




- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}

@end
