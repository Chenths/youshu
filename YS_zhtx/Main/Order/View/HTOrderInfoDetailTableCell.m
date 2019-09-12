//
//  HTOrderInfoDetailTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderInfoDetailTableCell.h"


@interface HTOrderInfoDetailTableCell()

@property (weak, nonatomic) IBOutlet UILabel *goodsOldLabel;

@property (weak, nonatomic) IBOutlet UILabel *isChangepriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *changePriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *changeOverLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *yhqLabel;

@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@end
@implementation HTOrderInfoDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    self.isChangepriceLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.hasmodifiedprice];
    self.goodsOldLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithUnCheakValue:model.totalprice]];
    self.changePriceLabel.text = [NSString stringWithFormat:@"¥%ld",model.procouponsum];
    self.changeOverLabel.text = [NSString stringWithFormat:@"¥%ld",model.shouldsum];
    self.integralLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.usepointdeduct];
    self.yhqLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.usecoupon];
    
    self.discountLabel.text = model.discount.floatValue == 0 ? @"0折" : model.discount.floatValue < 0 ? @"/折" : [NSString stringWithFormat:@"%@折",[HTHoldNullObj getValueWithBigDecmalObj:model.discount]];
   
    self.finallPriceLabel.text =  [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalprice]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
