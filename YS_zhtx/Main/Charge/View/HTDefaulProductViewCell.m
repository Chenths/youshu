//
//  HTFastProductViewCell.m
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTDefaulProductViewCell.h"
#import "HTOrderOrProductState.h"
#import "HTShowImg.h"
@interface HTDefaulProductViewCell()
@property (weak, nonatomic) IBOutlet UILabel *barcodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdViewLeading;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UILabel *value3Label;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UIImageView *holdImg;

@property (weak, nonatomic) IBOutlet UIImageView *holdBackImg;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *value1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *value2Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *value3Width;

@end
@implementation HTDefaulProductViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.value1Label changeCornerRadiusWithRadius:3];
    [self.value2Label changeCornerRadiusWithRadius:3];
    [self.value3Label changeCornerRadiusWithRadius:3];
}
-(void)setOrderProductModel:(HTOrderDetailProductModel *)orderProductModel{
    _orderProductModel = orderProductModel;
    self.selectedImg.hidden = YES;
    self.selectedImgWidth.constant = 0.0f;
    self.holdViewLeading.constant = 0.0f;
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:orderProductModel.image] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.barcodeTitle.text = [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.barcode];
    if ([HTHoldNullObj getValueWithUnCheakValue:orderProductModel.year].length == 0 && [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.season].length == 0 ) {
        self.categoryLabel.text = orderProductModel.customtype ? @"无数据" : [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.customtype];
    }else{
    self.categoryLabel.text = [NSString stringWithFormat:@"%@(%@ %@)",orderProductModel.customtype,orderProductModel.year,orderProductModel.season];
    }
    self.value1Label.text =  [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.color].length == 0 ? @"无数据" :  [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.color] ;
    self.value2Label.text = [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.size].length ==0 ? @"无数据" :  [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.size];
    self.value1Width.constant = [self.value1Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value2Width.constant = [self.value2Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value3Label.hidden = YES;
    if ([[HTOrderOrProductState getProductStateFormOrderString:orderProductModel.state] isEqualToString:@"NORMAL"]) {
        self.holdImg.hidden = YES;
    }else{
        self.holdImg.hidden = NO;
        self.holdImg.image = [UIImage imageNamed:[HTOrderOrProductState getProductStateFormOrderString:orderProductModel.state]];
    }
    self.holdBackImg.hidden = YES;
    self.indexLabel.hidden = YES;
    
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",orderProductModel.finalprice];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderProductModel.totalprice];
    self.stateLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:orderProductModel.discount] isEqualToString:@"-10"] ? @"/": [NSString stringWithFormat:@"%.1lf折",orderProductModel.discount.floatValue * 10];
    
    self.productImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];
}

- (void)tapAction{
    if (_orderProductModel) {
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_orderProductModel.image];
    }else{
        if ([_chargeModel.selectedModel.productimage isEqualToString:@""] || _chargeModel.selectedModel.productimage == nil) {
            [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:[[_chargeModel.product firstObject] productimage]];
        }else{
            [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_chargeModel.selectedModel.productimage];
        }
    }
}

-(void)setChargeModel:(HTCahargeProductModel *)chargeModel{
    _chargeModel = chargeModel;
    self.selectedImg.hidden = NO;
    self.selectedImgWidth.constant = 15;
    self.holdViewLeading.constant = 15;
    self.selectedImg.image = [UIImage imageNamed:chargeModel.isSelected ? @"singleSelected" :@"singleUnselected"];
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:chargeModel.selectedModel.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.barcodeTitle.text  = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.barcode];
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:chargeModel.selectedModel.finalprice]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:chargeModel.selectedModel.price]];
    self.categoryLabel.text  = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.customtype];
    
    self.value1Label.text = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.color];
    self.value2Label.text = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.size];
    self.value1Width.constant = [self.value1Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value2Width.constant = [self.value2Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value3Label.hidden = YES;
    self.holdImg.hidden = YES;
    self.stateLabel.text =  [[HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.discount] isEqualToString:@"-10"] ? @"/": [NSString stringWithFormat:@"%.1lf折",chargeModel.selectedModel.discount.floatValue * 10];
    
    self.productImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];
}

-(void)setExcOrReProductModel:(HTOrderDetailProductModel *)orderProductModel{
    _excOrReProductModel = orderProductModel;
    
    self.selectedImg.image = [UIImage imageNamed:orderProductModel.isSelected ? @"singleSelected" :@"singleUnselected"];
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:orderProductModel.image] placeholderImage:[UIImage imageNamed:@"g-goodsHoldImg"]];
    self.barcodeTitle.text = [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.barcode];
    if ([HTHoldNullObj getValueWithUnCheakValue:orderProductModel.year].length == 0 && [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.season].length == 0 ) {
        self.categoryLabel.text = orderProductModel.customtype ? @"无数据" : [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.customtype];
    }else{
        self.categoryLabel.text = [NSString stringWithFormat:@"%@(%@ %@)",orderProductModel.customtype,orderProductModel.year,orderProductModel.season];
    }
    self.value1Label.text = [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.color].length == 0 ? @"无数据" :  [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.color];
    self.value2Label.text = [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.size].length ==0 ? @"无数据" :  [HTHoldNullObj getValueWithUnCheakValue:orderProductModel.size];;
    self.value1Width.constant = [self.value1Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value2Width.constant = [self.value2Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value3Label.hidden = YES;
    if ([[HTOrderOrProductState getProductStateFormOrderString:orderProductModel.state] isEqualToString:@"NORMAL"]) {
        self.holdImg.hidden = YES;
        self.selectedImg.hidden = NO;
        self.selectedImgWidth.constant = 15;
        self.holdViewLeading.constant = 15;
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }else{
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"#F8F8F8"];
        self.holdImg.hidden = NO;
        self.holdImg.image = [UIImage imageNamed:[HTOrderOrProductState getProductStateFormOrderString:orderProductModel.state]];
        self.selectedImg.hidden = YES;
        self.selectedImgWidth.constant = 0.0f;
        self.holdViewLeading.constant = 0.0f;
    }
    self.holdBackImg.hidden = YES;
    self.indexLabel.hidden = YES;
    
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",orderProductModel.finalprice];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",orderProductModel.totalprice];
    self.stateLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:orderProductModel.discount] isEqualToString:@"-10"] ? @"/": [NSString stringWithFormat:@"%.1lf折",orderProductModel.discount.floatValue * 10];
}


@end
