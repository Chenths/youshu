//
//  HTTurnListTpyeOutViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTurnListTpyeOutViewCell.h"
@interface HTTurnListTpyeOutViewCell()
@property (weak, nonatomic) IBOutlet UILabel *weak;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *turnNumber;
@property (weak, nonatomic) IBOutlet UILabel *outCompany;
@property (weak, nonatomic) IBOutlet UILabel *totleCount;
@property (weak, nonatomic) IBOutlet UILabel *cheakName;
@property (weak, nonatomic) IBOutlet UILabel *holdName;

@end
@implementation HTTurnListTpyeOutViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HTTurnListItemsModel *)model{
    _model = model;
    NSDateFormatter * yearF1 = [[NSDateFormatter alloc] init];
    [yearF1 setDateFormat:@"YYYY-MM-dd"];
    NSString *createdate = model.swapDate;
    NSDate *date = createdate.length >= 10 ?  [yearF1 dateFromString:[createdate substringWithRange:NSMakeRange(0, 10)]]  : [yearF1 dateFromString:createdate];
    self.weak.text = [self weekdayStringFromDate:date];
    self.date.text = [NSString stringWithFormat:@"%@",createdate.length >= 10 ? [createdate substringWithRange:NSMakeRange(0, 10)]: createdate];
    self.time.text = [NSString stringWithFormat:@"%@",createdate.length >= 16 ? [createdate substringWithRange:NSMakeRange(11, 5)]: createdate];
    self.turnNumber.text = [NSString stringWithFormat:@"调货单号:%@",[HTHoldNullObj getValueWithUnCheakValue:model.swapProductOrderNo]];
    self.outCompany.text = [HTHoldNullObj getValueWithUnCheakValue:model.swapCompanyName];
    self.totleCount.text = [HTHoldNullObj getValueWithUnCheakValue:model.swapTotalCount];
    self.cheakName.text = [HTHoldNullObj getValueWithUnCheakValue:model.signUserName].length == 0 ? @"--" :  [HTHoldNullObj getValueWithUnCheakValue:model.signUserName];
    self.holdName.text = [HTHoldNullObj getValueWithUnCheakValue:model.swapUserName];
}
- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    [calendar setTimeZone: timeZone];
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    return [weekdays objectAtIndex:theComponents.weekday];
}
@end
