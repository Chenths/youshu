//
//  HTBossMeHeadTableViewCell.m
//  有术
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTLoginDataPersonModel.h"
#import "HTBossMeHeadTableViewCell.h"
@interface HTBossMeHeadTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end
@implementation HTBossMeHeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.positionLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.loginName];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].loginModel.person.name];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
