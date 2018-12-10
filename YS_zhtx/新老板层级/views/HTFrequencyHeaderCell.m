//
//  HTFrequencyHeaderCell.m
//  有术
//
//  Created by mac on 2018/5/2.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTFrequencyHeaderCell.h"
@interface HTFrequencyHeaderCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;


@end
@implementation HTFrequencyHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    self.dateLabel.text = [NSString stringWithFormat:@"%@至%@",self.beginTime,self.endTime];
}
@end
