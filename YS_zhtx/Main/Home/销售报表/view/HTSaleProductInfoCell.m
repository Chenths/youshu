//
//  HTSaleProductInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTSaleProductInfoCell.h"
#import "HTShowImg.h"
@interface HTSaleProductInfoCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UILabel *catAndYearLabel;
@property (weak, nonatomic) IBOutlet UILabel *productCount;


@end
@implementation HTSaleProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HTProductRankInfoModel *)model{
    _model = model;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.barcode.text = [HTHoldNullObj getValueWithUnCheakValue:model.stylecode];
    self.catAndYearLabel.text = [NSString stringWithFormat:@"类别:%@(%@%@)",[HTHoldNullObj getValueWithUnCheakValue:model.customertype],[HTHoldNullObj getValueWithUnCheakValue:model.year],[HTHoldNullObj getValueWithUnCheakValue:model.season]];
    self.productCount.text = [NSString stringWithFormat:@"%@件",model.count];
    self.productImg.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];
}

- (void)tapAction{
    [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_model.image];
}

@end
