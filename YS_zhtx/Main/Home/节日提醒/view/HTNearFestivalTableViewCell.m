//
//  HTNearFestivalTableViewCell.m
//  有术
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "NSDate+Manager.h"
#import "HTNearFestivalTableViewCell.h"
@interface HTNearFestivalTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *festivalLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *yongliLabel;

@property (weak, nonatomic) IBOutlet UILabel *diffDayLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (nonatomic,assign)  NSUInteger tomer;


@end


@implementation HTNearFestivalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.festivalLabel.text = [dataDic getStringWithKey:@"name"];
    self.dateLabel.text = [dataDic getStringWithKey:@"accurateDate"];
    self.yongliLabel.text = [dataDic getStringWithKey:@"lunarDate"];
    
    self.diffDayLabel.text = [NSString stringWithFormat:@"%d",((int)[dataDic getFloatWithKey:@"diffDay"] - 1) ];
    
    NSDate *tomorrom = [[NSDate date] dateBySubingDays:1];
    
    NSDateFormatter  *dateForem = [[NSDateFormatter alloc] init];
    [dateForem setDateFormat:@"YYYY-MM-dd"];
    NSString *datestring = [dateForem stringFromDate:tomorrom];
    NSDateFormatter *dateform = [[NSDateFormatter alloc] init];
    [dateform setDateFormat:@"YYYY-MM-dd-hh-mm-ss"];
    NSDate *tomeroDate = [dateform dateFromString:[NSString stringWithFormat:@"%@-%@-%@-%@",datestring,@"00",@"00",@"00"]];
    self.tomer = (NSUInteger)[tomeroDate timeIntervalSinceNow]  ;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",self.tomer / (60 * 60), (self.tomer % (60 * 60)) / 60,(self.tomer % (60 * 60)) % 60];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timego) userInfo:nil repeats:YES];
}
- (void)timego{
    self.tomer--;
    self.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",self.tomer / (60 * 60), (self.tomer % (60 * 60)) / 60,(self.tomer % (60 * 60)) % 60];
}
@end
