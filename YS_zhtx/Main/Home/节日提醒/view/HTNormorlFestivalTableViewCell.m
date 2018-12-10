//
//  HTNormorlFestivalTableViewCell.m
//  有术
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "NSDate+Manager.h"
#import "HTNormorlFestivalTableViewCell.h"

@interface HTNormorlFestivalTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *festivalLabel;

@property (weak, nonatomic) IBOutlet UILabel *dayLabel;

@property (weak, nonatomic) IBOutlet UILabel *engMonthLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *diffDayLabel;



@end

@implementation HTNormorlFestivalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.festivalLabel.text = [dataDic getStringWithKey:@"name"];
    self.dayLabel.text = [dataDic getStringWithKey:@"day"];
    self.engMonthLabel.text = [dataDic getStringWithKey:@"englishMon"];
    self.dateLabel.text = [[dataDic getStringWithKey:@"isLunar"] isEqualToString:@"1"] ? [dataDic getStringWithKey:@"lunarDate"] : [dataDic getStringWithKey:@"solarDate"];
    self.diffDayLabel.text = [dataDic getStringWithKey:@"diffDay"];
    
   
    
    
}

@end
