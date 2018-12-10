//
//  HTMeBaceInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMeBaceInfoTableViewCell.h"
@interface HTMeBaceInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *guiderNum;


@end
@implementation HTMeBaceInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTMineModel *)model{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.personMessage.img] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.personMessage.name];
    self.guiderNum.text = [NSString stringWithFormat:@"工号：%@",[HTHoldNullObj getValueWithUnCheakValue:model.personMessage.gNum]];
}
@end
