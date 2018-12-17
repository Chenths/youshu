//
//  HTNotBirthdayCell.m
//  有术
//
//  Created by mac on 2018/1/26.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTNotBirthdayCell.h"

@interface HTNotBirthdayCell()

@property (weak, nonatomic) IBOutlet UIButton *seeBt;


@end


@implementation HTNotBirthdayCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.seeBt.layer.masksToBounds = YES;
    self.seeBt.layer.cornerRadius = 3;
    self.seeBt.layer.borderColor = [UIColor colorWithHexString:@"#222222"].CGColor;
    self.seeBt.layer.borderWidth =  1;
    self.seeBt.enabled = NO;
}

- (void)setHtbirthType:(HTBirthTodayOrNear)htbirthType{
    _htbirthType = htbirthType;
    if (htbirthType == HTBirthToday) {
        self.seeBt.hidden = NO;
    }else{
        self.seeBt.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
