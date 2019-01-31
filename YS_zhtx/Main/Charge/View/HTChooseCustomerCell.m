//
//  HTChooseCustomerCell.m
//  YS_zhtx
//
//  Created by mac on 2019/1/10.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTChooseCustomerCell.h"

@implementation HTChooseCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ImageView.clipsToBounds = YES;
    self.ImageView.layer.cornerRadius = 24;
    self.levelLabel.clipsToBounds = YES;
    self.levelLabel.layer.cornerRadius = 15.0 / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
