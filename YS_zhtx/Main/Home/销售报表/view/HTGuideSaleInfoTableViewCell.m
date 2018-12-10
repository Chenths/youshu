//
//  HTGuideSaleInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuideSaleInfoTableViewCell.h"
@interface HTGuideSaleInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderAndProductCount;

@property (weak, nonatomic) IBOutlet UILabel *priceAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *salePresentLabel;

@property (weak, nonatomic) IBOutlet UILabel *workNumberLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *presentProgress;



@end
@implementation HTGuideSaleInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.presentProgress changeCornerRadiusWithRadius:2.5];
}
-(void)setModel:(HTGuideSaleInfoModel *)model{
    _model = model;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",model.index.row + 1];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.orderAndProductCount.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.finalordercount],[HTHoldNullObj getValueWithUnCheakValue:model.finalsalevolume]];
    self.priceAmountLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalfinalprice]];
    self.salePresentLabel.text = [NSString stringWithFormat:@"%@%@",model.ralt,@"%"];
    self.workNumberLabel.text = [NSString stringWithFormat:@"工号：%@",model.jobnum];
    self.presentProgress.progress = model.ralt.floatValue / 100;
}


@end
