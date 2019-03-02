//
//  HTChangePriceProductInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/20.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChangePriceProductInfoCell.h"
#import "HTShowImg.h"
@interface HTChangePriceProductInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *barcodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@property (weak, nonatomic) IBOutlet UILabel *value1Label;
@property (weak, nonatomic) IBOutlet UILabel *value2Label;
@property (weak, nonatomic) IBOutlet UIImageView *productImg;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *value1Width;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *value2Width;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImg;
@property (weak, nonatomic) IBOutlet UISwitch *onOffBt;
@property (weak, nonatomic) IBOutlet UILabel *sendStateLabel;




@end
@implementation HTChangePriceProductInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.onOffBt.tintColor = [UIColor colorWithHexString:@"#999999"];
//    self.onOffBt
}

-(void)setChargeModel:(HTCahargeProductModel *)chargeModel{
    _chargeModel = chargeModel;
    
    self.selectedImg.image = [UIImage imageNamed:chargeModel.isSelected ? @"singleSelected" :@"singleUnselected"];
    [self.productImg sd_setImageWithURL:[NSURL URLWithString:chargeModel.selectedModel.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.productImg.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.productImg addGestureRecognizer:tap];

    self.barcodeTitle.text  = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.barcode];
    self.finallPriceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:chargeModel.selectedModel.finalprice]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:chargeModel.selectedModel.price]];
    self.value1Label.text = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.color];
    self.value2Label.text = [HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.size];
    self.value1Width.constant = [self.value1Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.value2Width.constant = [self.value2Label.text getStringWidhtWithHeight:21 andFont:13] + 20;
    self.stateLabel.text = chargeModel.isChangePrice ? @"改价" : [[HTHoldNullObj getValueWithUnCheakValue:chargeModel.selectedModel.discount] isEqualToString:@"-10"] ? @"/": [NSString stringWithFormat:@"%.1lf折",chargeModel.selectedModel.discount.floatValue * 10];
    self.onOffBt.on = [chargeModel.hasGivePoint isEqualToString:@"0"] ? NO : YES;
    self.sendStateLabel.text = [chargeModel.hasGivePoint isEqualToString:@"0"] ? @"取消赠送" : @"赠送积分";
}

- (void)tapAction{
    if ([_chargeModel.selectedModel.productimage isEqualToString:@""] || _chargeModel.selectedModel.productimage == nil) {
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:[[_chargeModel.product firstObject] productimage]];
    }else{
        [HTShowImg showSingleBigImvWithImg:nil WithUrlStr:_chargeModel.selectedModel.productimage];
    }
    
}

-(void)setIndex:(NSIndexPath *)index{
    _index = index;
    self.indexLabel.text = [NSString stringWithFormat:@"%ld",index.row + 1];
}

- (IBAction)onOrOffClicked:(id)sender {
    
    if (self.onOffBt.on) {
        self.chargeModel.isChange = YES;
        self.chargeModel.hasGivePoint = @"1";
    }else{
        self.chargeModel.isChange = YES;
        self.chargeModel.hasGivePoint = @"0";
    }
    self.sendStateLabel.text = [self.chargeModel.hasGivePoint isEqualToString:@"0"] ? @"取消赠送" : @"赠送积分";
}



@end
