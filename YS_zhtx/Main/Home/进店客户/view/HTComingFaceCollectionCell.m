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
@property (weak, nonatomic) IBOutlet UIImageView *oldHeadImg;
@property (weak, nonatomic) IBOutlet UIImageView *systemHeadImv;

@end

@implementation HTComingFaceCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.levelLabel changeCornerRadiusWithRadius:self.levelLabel.height *0.5];
//    [self.headImg changeCornerRadiusWithRadius:133.0 / 2];
//    [self.oldHeadImg changeCornerRadiusWithRadius:133.0 / 2];
    [self.systemHeadImv changeCornerRadiusWithRadius:43.0 / 2];
    [self.levelLabel changeBorderStyleColor:[UIColor colorWithHexString:@"999999"] withWidth:1];
}
-(void)setModel:(HTNewFaceVipModel *)model{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"进店: %@" ,[HTHoldNullObj getValueWithUnCheakValue:model.enterTime]];
    [self.systemHeadImv sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.snapPath] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    [self.oldHeadImg sd_setImageWithURL:[NSURL URLWithString:model.libPath] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.customerName];
    self.sexImg.image = [model.sex isEqualToString:@"男"] ? [UIImage imageNamed:@"g-man"]: [UIImage imageNamed:@"g-woman"];
    self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.level];
}

@end
