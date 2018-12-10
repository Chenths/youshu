//
//  HTComingFaceCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/7.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTComingFaceCollectionCell.h"

@interface HTComingFaceCollectionCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;

@end

@implementation HTComingFaceCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.levelLabel changeCornerRadiusWithRadius:self.levelLabel.height *0.5];
    [self.levelLabel changeBorderStyleColor:[UIColor colorWithHexString:@"999999"] withWidth:1];
}
-(void)setModel:(HTFaceVipModel *)model{
    _model = model;
    self.timeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.create_time];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.path] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.nickname_cust];
    self.sexImg.image = model.sex_cust ? [UIImage imageNamed:@"g-man"]: [UIImage imageNamed:@"g-woman"];
    self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.cust_level];
}

@end
