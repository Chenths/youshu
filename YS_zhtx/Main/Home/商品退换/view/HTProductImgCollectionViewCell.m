//
//  HTProductImgCollectionViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/19.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTProductImgCollectionViewCell.h"
#import "HTShowImg.h"
@interface HTProductImgCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImg;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *holdLabel;

@end
@implementation HTProductImgCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTOrderDetailProductModel *)model{
    _model = model;

    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    if (model.productState == HTProductStateChange) {
        self.holdLabel.hidden = NO;
        self.holdLabel.image = [UIImage imageNamed:@"EXCHANGE"];
    }else if (model.productState == HTProductStateReturn) {
        self.holdLabel.hidden = NO;
        self.holdLabel.image = [UIImage imageNamed:@"RETURN"];
    }else{
        self.holdLabel.hidden = YES;
    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",model.finalprice];
    self.productImg.userInteractionEnabled = YES;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];
}

- (void)tapAction{
    [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_model.image];
}

-(void)setProductModel:(HTChargeProductInfoModel *)productModel{
    _productModel = productModel;
    self.holdLabel.hidden = YES;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:productModel.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",productModel.finalprice];
}
@end
