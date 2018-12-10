//
//  HTNewGoodsImgTableViewCell.m
//  有术
//
//  Created by mac on 2018/5/24.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
#import "HTChargeProductInfoModel.h"
#import "HTNewGoodsImgTableViewCell.h"
@interface HTNewGoodsImgTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *productImg;
//商品界面
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
//商品数量
@property (weak, nonatomic) IBOutlet UILabel *goodsNumberLabel;
//商品类别
@property (weak, nonatomic) IBOutlet UILabel *goodsType;
//商品单价
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;
//商品颜色
@property (weak, nonatomic) IBOutlet UILabel *goodsColorLabel;
//商品尺寸
@property (weak, nonatomic) IBOutlet UILabel *goodsSizeLabel;

@property (weak, nonatomic) IBOutlet UILabel *oldPrizeLabe;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel *cheakStateLabel;

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sizeWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *colorWidth;

@end


@implementation HTNewGoodsImgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.cheakStateLabel changeCornerRadiusWithRadius:3];
    self.goodsSizeLabel.layer.cornerRadius = 3;
    self.goodsSizeLabel.layer.masksToBounds = YES;
    self.goodsColorLabel.layer.cornerRadius = 3;
    self.goodsColorLabel.layer.masksToBounds = YES;
}
-(void)setModel:(HTCahargeProductModel *)model{
    _model = model;
    self.cheakStateLabel.hidden = YES;
    if (!self.model.selectedModel) {
        HTChargeProductInfoModel *mmm = [self.model.product firstObject];
        [self configDataWithModel:mmm andIsselected:NO];
    }else{
        HTChargeProductInfoModel *mmm = model.selectedModel;
        [self configDataWithModel:mmm andIsselected:YES];
    }
}
-(void)setProductModel:(HTOrderDetailProductModel *)model{
    _productModel = model;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.goodsName.text = [HTHoldNullObj getValueWithUnCheakValue:model.barcode] ;
    self.goodsType.text = [HTHoldNullObj getValueWithUnCheakValue:model.customtype];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.finalprice];
    self.oldPrizeLabe.text = [NSString stringWithFormat:@"¥%@",model.totalprice];
    self.goodsSizeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.size];
    self.goodsColorLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.color];
    self.sizeWidth.constant = [self.goodsSizeLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 < 32 ? 32 : [self.goodsSizeLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 ;
    self.colorWidth.constant = [self.goodsColorLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 < 32 ? 32 : [self.goodsColorLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 ;
    if (model.isCheak) {
        self.cheakStateLabel.text = @"已核对";
        self.cheakStateLabel.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }else{
        self.cheakStateLabel.text = @"未核对";
        self.cheakStateLabel.backgroundColor = [UIColor colorWithHexString:@"#f1f1f1"];
    }
}
-(void)configDataWithModel:(HTChargeProductInfoModel *)model andIsselected:(BOOL) isSelected{
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:model.productimage] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.goodsName.text = isSelected ? [HTHoldNullObj getValueWithUnCheakValue:model.barcode] : [HTHoldNullObj getValueWithUnCheakValue:model.stylecode];
    self.goodsType.text = [HTHoldNullObj getValueWithUnCheakValue:model.customtype];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"¥%@",model.finalprice];
    self.oldPrizeLabe.text = [NSString stringWithFormat:@"¥%@",model.price];
    self.discountLabel.text = [NSString stringWithFormat:@"%@" ,model.discount.floatValue == 0 ? @"0折" : model.discount.floatValue < 0 ? @"／折" : [NSString stringWithFormat:@"%.1lf折",[HTHoldNullObj getValueWithUnCheakValue:model.discount].floatValue * 10]];
    if (isSelected) {
        self.goodsSizeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.size];
        self.goodsColorLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.color];
        self.sizeWidth.constant = [self.goodsSizeLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 < 32 ? 32 : [self.goodsSizeLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 ;
        self.colorWidth.constant = [self.goodsColorLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 < 32 ? 32 : [self.goodsColorLabel.text getStringWidhtWithHeight:21 andFont:13] + 20 ;
    }else{
        self.goodsSizeLabel.text = @"?";
        self.goodsColorLabel.text = @"?";
        self.sizeWidth.constant = 32;
        self.colorWidth.constant = 32;
    }
}

@end
