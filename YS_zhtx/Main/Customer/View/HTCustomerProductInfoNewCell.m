//
//  HTCustomerProductInfoNewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/6/18.
//  Copyright © 2019 有术-新零售. All rights reserved.
//

#import "HTCustomerProductInfoNewCell.h"

@implementation HTCustomerProductInfoNewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)setModel:(HTCustomerPrudcutInfo *)model{
    _model = model;
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.productimage] placeholderImage:[UIImage imageNamed:PRODUCTHOLDIMG]];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.codeLabel.text = [NSString stringWithFormat:@"条码:%@", [HTHoldNullObj getValueWithUnCheakValue:model.barcode]];
    self.detailLabel.text = [NSString stringWithFormat:@"%@/%@/%@/%@", [HTHoldNullObj getValueWithUnCheakValue:model.year], [HTHoldNullObj getValueWithUnCheakValue:model.season], [HTHoldNullObj getValueWithUnCheakValue:model.color], [HTHoldNullObj getValueWithUnCheakValue:model.size]];
    self.nowPrice.text = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:model.finalprice]];
    
    NSString *oldPriceStr = [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:model.price]];
    // 下划线
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:oldPriceStr attributes:attribtDic];
    //赋值
    self.oldPrice.attributedText = attribtStr;
    if ([model.discount floatValue] == -10) {
        self.discountLabel.text = @"";
        self.discountLabel.hidden = YES;
    }else{
        self.discountLabel.text = [NSString stringWithFormat:@"%.2f折" ,[[HTHoldNullObj getValueWithUnCheakValue:model.discount] floatValue] * 10];
        self.discountLabel.hidden = NO;
    }
    self.buyTime.text = [NSString stringWithFormat:@"购买时间:%@", [HTHoldNullObj getValueWithUnCheakValue:model.buytime]];
    self.buyStore.text = [NSString stringWithFormat:@"消费店铺:%@", [HTHoldNullObj getValueWithUnCheakValue:model.belongstore]];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
