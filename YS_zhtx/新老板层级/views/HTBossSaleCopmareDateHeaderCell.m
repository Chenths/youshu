//
//  HTBossSaleCopmareDateHeaderCell.m
//  有术
//
//  Created by mac on 2018/5/18.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossSaleCopmareDateHeaderCell.h"

@interface  HTBossSaleCopmareDateHeaderCell()

@property (weak, nonatomic) IBOutlet UILabel *dayDateLabel;

@property (weak, nonatomic) IBOutlet UILabel *weakLabel;

@property (weak, nonatomic) IBOutlet UILabel *monthDateLabel;


@end

@implementation HTBossSaleCopmareDateHeaderCell

- (void)setDateStr:(NSString *)dateStr{
    _dateStr = dateStr;
    if (self.rankState == HTRANKSTATEYEAR) {
        self.dayDateLabel.hidden = YES;
        self.weakLabel.hidden = YES;
        if (dateStr.length >= 7 ) {
           self.monthDateLabel.text = [NSString stringWithFormat:@"%@月", [dateStr substringWithRange:NSMakeRange(5, 2)]];
        }
    }else if (self.rankState == HTRANKSTATEMONTH){
        self.dayDateLabel.hidden = NO;
        self.weakLabel.hidden = NO;
        self.monthDateLabel.hidden = YES;
        if (dateStr.length >= 10 ) {
            self.dayDateLabel.text = [NSString stringWithFormat:@"%@号", [dateStr substringWithRange:NSMakeRange(8, 2)]];
            self.weakLabel.text = [self fromDateToWeek:dateStr];
        }else{
            self.dayDateLabel.text = @"";
            self.weakLabel.text = @"";
        }
        
    }
}
//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    NSInteger yearInt = [selectDate substringWithRange:NSMakeRange(0, 4)].integerValue;
    NSInteger monthInt = [selectDate substringWithRange:NSMakeRange(5, 2)].integerValue;
    NSInteger dayInt = [selectDate substringWithRange:NSMakeRange(8, 2)].integerValue;
    int c = 20;//世纪
    NSInteger y = yearInt -1;//年
    NSInteger d = dayInt;
    NSInteger m = monthInt;
    int w =(y+(y/4)+(c/4)-2*c+(26*(m+1)/10)+d-1)%7;
    NSString *weekDay = @"";
    switch (w) {
        case 0:
            weekDay = @"周日";
            break;
        case 1:
            weekDay = @"周一";
            break;
        case 2:
            weekDay = @"周二";
            break;
        case 3:
            weekDay = @"周三";
            break;
        case 4:
            weekDay = @"周四";
            break;
        case 5:
            weekDay = @"周五";
            break;
        case 6:
            weekDay = @"周六";
            break;
        default:
            break;
    }
    return weekDay;
}


@end
