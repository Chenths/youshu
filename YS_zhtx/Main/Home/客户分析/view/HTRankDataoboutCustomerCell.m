//
//  HTRankDataoboutCustomerCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTRankDataoboutCustomerCell.h"

@interface HTRankDataoboutCustomerCell()

@property (weak, nonatomic) IBOutlet UIImageView *holdImg;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *levelLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
@implementation HTRankDataoboutCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.levelLabel changeCornerRadiusWithRadius:9];
    [self.levelLabel changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
    // Initialization code
}

-(void)setModel:(HTRankReportSingleCustomerModel *)model{
    _model = model;
    NSArray *imgNames = @[@"rankFirst",@"rankSecond",@"rankThird"];
    if (model.position.integerValue < imgNames.count) {
        self.holdImg.hidden = NO;
        self.rankLabel.hidden = YES;
        self.holdImg.image = [UIImage imageNamed: imgNames[model.position.integerValue]];
    }else{
        self.holdImg.hidden = YES;
        self.rankLabel.hidden = NO;
        self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.position.integerValue + 1];
    }
    self.levelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.custlevel];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headimg] placeholderImage:[UIImage imageNamed:@"g-customerholdImg"]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name].length == 0 ? @"未录入称呼" : [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.sexImg.image = [model.sex isEqualToString:@"0"] ? [UIImage imageNamed:@"g-woman"] :[UIImage imageNamed:@"g-man"];
    self.amountLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.amount]];
    self.descLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.label];
    self.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.phone];
}
@end
