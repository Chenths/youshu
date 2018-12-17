//
//  HTOrderInfoDetailTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderInfoDetailTableCell.h"


@interface HTOrderInfoDetailTableCell()

@property (weak, nonatomic) IBOutlet UILabel *payTypeLabel;

@property (weak, nonatomic) IBOutlet UILabel *isChangepriceLabel;

@property (weak, nonatomic) IBOutlet UILabel *orderTotalLabel;

@property (weak, nonatomic) IBOutlet UILabel *discountLabel;

@property (weak, nonatomic) IBOutlet UILabel *integralLabel;

@property (weak, nonatomic) IBOutlet UILabel *finallPriceLabel;

@end
@implementation HTOrderInfoDetailTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    self.isChangepriceLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.hasmodifiedprice];
    self.payTypeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.paytype];
    self.orderTotalLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalprice]];
    self.discountLabel.text = model.discount.floatValue == 0 ? @"0折" : model.discount.floatValue < 0 ? @"/折" : [NSString stringWithFormat:@"%@折",[HTHoldNullObj getValueWithBigDecmalObj:model.discount]];
    self.integralLabel.text = @"无数据";
   
    self.finallPriceLabel.text =  [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalprice]];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

@end
