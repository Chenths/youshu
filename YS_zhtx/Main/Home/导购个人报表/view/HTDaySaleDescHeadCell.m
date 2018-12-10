//
//  HTDaySaleDescHeadCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTDaySaleDescHeadCell.h"
@interface HTDaySaleDescHeadCell()
@property (weak, nonatomic) IBOutlet UILabel *totlePrice;
@property (weak, nonatomic) IBOutlet UILabel *dateBackLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderDesc;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;

@end
@implementation HTDaySaleDescHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDate:(NSString *)date{
    _date  = date;
    self.dateBackLabel.text = [self fromDateToWeek:date];
}
//通过日期求星期
- (NSString*)fromDateToWeek:(NSString*)selectDate
{
    if (selectDate.length < 10) {
        return @"";
    }
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
-(void)setModel:(HTGuiderDayModel *)model{
    _model = model;
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.salesAmount]];
    self.totlePrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.salesPrice]];
    self.orderDesc.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.count],[HTHoldNullObj getValueWithUnCheakValue:model.salesVolume]];
}

@end
