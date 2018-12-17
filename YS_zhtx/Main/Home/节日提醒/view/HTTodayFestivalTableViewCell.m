//
//  HTTodayFestivalTableViewCell.m
//  有术
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTTodayFestivalTableViewCell.h"

@interface HTTodayFestivalTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *festivalTitle;

@property (weak, nonatomic) IBOutlet UILabel *yangliLabel;


@end

@implementation HTTodayFestivalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setDataDic:(NSDictionary *)dataDic{
    _dataDic = dataDic;
    self.dateLabel.text = [dataDic getStringWithKey:@"accurateDate"];
    self.yangliLabel.text = [dataDic getStringWithKey:@"lunarDate"];
    self.festivalTitle.text = [dataDic getStringWithKey:@"name"];
}

@end
