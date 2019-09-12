//
//  HTNewPayYHQTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/8/7.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTNewPayYHQTableViewCell.h"

@implementation HTNewPayYHQTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.cellWidth.constant = HMSCREENWIDTH;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
