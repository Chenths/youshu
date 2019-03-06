//
//  HTExchangeProductDetailCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTExchangeProductDetailCollectionCell.h"
#import "HTShowImg.h"
@interface HTExchangeProductDetailCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *barcode;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;

@end
@implementation HTExchangeProductDetailCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HTOrderDetailProductModel *)model{
    _model = model;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.totalPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalprice]];
    self.barcode.text = [HTHoldNullObj getValueWithUnCheakValue:model.barcode];
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalprice]];

    self.productImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];
}

- (void)tapAction{
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_model.image];
}

@end
