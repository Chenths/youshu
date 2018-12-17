//
//  HTMultitermBossSingleContrastCell.m
//  有术
//
//  Created by mac on 2018/4/25.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTMultitermBossSingleContrastCell.h"
@interface HTMultitermBossSingleContrastCell()

@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;
@property (weak, nonatomic) IBOutlet UILabel *valueTitle1;
@property (weak, nonatomic) IBOutlet UILabel *valueTitle2;



@end
@implementation HTMultitermBossSingleContrastCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
