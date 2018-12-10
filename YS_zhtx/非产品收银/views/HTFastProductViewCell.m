//
//  HTFastProductViewCell.m
//  有术
//
//  Created by mac on 2018/5/15.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//
#import "HTOrderOrProductState.h"
#import "HTFastProductViewCell.h"
@interface HTFastProductViewCell()
@property (weak, nonatomic) IBOutlet UILabel *sequenceLabel;
@property (weak, nonatomic) IBOutlet UILabel *barcodeTitle;
@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *dicountLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectedImgWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *holdViewLeading;



@end
@implementation HTFastProductViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)setModel:(HTFastPrudoctModel *)model{
    _model = model;
    self.selectedImg.hidden = YES;
    self.selectedImgWidth.constant = 0.0f;
    self.holdViewLeading.constant = 0.0f;
    self.numberLabel.textColor = [UIColor colorWithHexString:@"999999"];
    self.barcodeTitle.text = [HTHoldNullObj getValueWithUnCheakValue:model.barcode].length == 0 ? @"/" : [HTHoldNullObj getValueWithUnCheakValue:model.barcode];
    self.priceLabel.text = [NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue:model.price]];
    if (model.discount.length > 0) {
        self.finallPriceLabel.text =  [NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:[self getFinallPriceWithPrice:model.price andDiscount:model.discount]]];
    }else{
        self.finallPriceLabel.text = [NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue:model.price]];
    }
    self.categoryLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.categoryName].length == 0 ? @"/" :  [HTHoldNullObj getValueWithUnCheakValue:model.categoryName];
    self.dicountLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.discount].length == 0 ? @"/" : [NSString stringWithFormat:@"%@折", [HTHoldNullObj getValueWithUnCheakValue:model.discount]];
    self.numberLabel.text =  [NSString stringWithFormat:@"x%@",[HTHoldNullObj getValueWithUnCheakValue:model.numbers]];
    if (model.state.allKeys.count > 0) {
        if (![[model.state getStringWithKey:@"id"] isEqualToString:@"1"] && [model.state getStringWithKey:@"id"].length > 0) {
            self.numberLabel.textColor = [UIColor colorWithHexString:@"999999"];
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [model.state getStringWithKey:@"name"];
            self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
        }else{
            self.numberLabel.textColor = [UIColor colorWithHexString:@"222222"];
            self.numberLabel.hidden = NO;
            self.numberLabel.text = [model.state getStringWithKey:@"name"];
            self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        }
    }
  
}
-(void)setProductModel:(HTCahargeProductModel *)productModel{
    _productModel = productModel;
    
    HTChargeProductInfoModel *model1 = productModel.selectedModel;
    self.barcodeTitle.text = model1.barcode;
    self.priceLabel.text =[NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue: model1.price]];
    self.finallPriceLabel.text =[NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue:model1.finalprice]];
    self.dicountLabel.text =  model1.discount.floatValue == 0.0f || model1.discount.floatValue == 1.0f  ? @"无" : model1.discount.floatValue < 0.0f ? @"/" : [NSString stringWithFormat:@"%.1lf折" ,model1.discount.floatValue * 10];
    self.categoryLabel.text = model1.customtype;
    if (model1.isSelected) {
        self.selectedImg.image = [UIImage imageNamed:@"单选-选中"];
    }else{
        self.selectedImg.image = [UIImage imageNamed:@"单选-未选中"];
    }
#warning ---
//    if (![[model1.state getStringWithKey:@"id"] isEqualToString:@"1"] && [model1.state getStringWithKey:@"id"].length > 0) {
//        self.selectedImg.hidden = YES;
//        self.selectedImgWidth.constant = 0.0f;
//        self.holdViewLeading.constant = 0.0f;
//        self.numberLabel.textColor = [UIColor colorWithHexString:@"999999"];
//        self.numberLabel.hidden = NO;
//        self.numberLabel.text = [model1.state getStringWithKey:@"name"];
//        self.backgroundColor = [UIColor colorWithHexString:@"f8f8f8"];
//    }else{
//        self.selectedImg.hidden = NO;
//        self.selectedImgWidth.constant = 25.0f;
//        self.holdViewLeading.constant = 30.0f;
//        self.numberLabel.textColor = [UIColor colorWithHexString:@"222222"];
//        self.numberLabel.hidden = NO;
//        self.numberLabel.text = [model1.state getStringWithKey:@"name"];
//        self.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    }
}
-(void)setIndex:(NSIndexPath *)index{
    _index = index;
    self.sequenceLabel.text = [NSString stringWithFormat:@"%ld",index.row + 1];
}
-(NSString *)getFinallPriceWithPrice:(NSString *)price andDiscount:(NSString *)discount{
    if (discount.floatValue == 0) {
        return price;
    }
    CGFloat f = discount.floatValue;
    NSString *str = [NSString stringWithFormat:@"%lf",f  / 10 * price.floatValue];
    NSDecimalNumberHandler *roundUp = [NSDecimalNumberHandler
                                       
                                       decimalNumberHandlerWithRoundingMode:NSRoundBankers
                                       
                                       scale:0
                                       
                                       raiseOnExactness:NO
                                       
                                       raiseOnOverflow:NO
                                       
                                       raiseOnUnderflow:NO
                                       
                                       raiseOnDivideByZero:YES];
    NSDecimalNumber *subtotal = [NSDecimalNumber decimalNumberWithString:str];
    
    NSDecimalNumber *discount1 = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    NSDecimalNumber *total = [subtotal decimalNumberByAdding:discount1 withBehavior:roundUp];
    return [NSString stringWithFormat:@"%@",total];
}
@end
