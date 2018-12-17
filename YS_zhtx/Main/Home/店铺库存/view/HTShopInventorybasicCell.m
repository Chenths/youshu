//
//  HTInventorybasicCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTShopInventorybasicCell.h"
@interface HTShopInventorybasicCell()
@property (weak, nonatomic) IBOutlet UILabel *inventoryTotleCount;
@property (weak, nonatomic) IBOutlet UILabel *saleGoodLable;
@property (weak, nonatomic) IBOutlet UILabel *saleBadLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cosPriceLabe;



@end


@implementation HTShopInventorybasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
}
-(void)setModel:(HTInventoryReportModel *)model{
    _model = model;
    self.inventoryTotleCount.text = [HTHoldNullObj getValueWithUnCheakValue:model.totalStock];
    self.saleGoodLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.goodMarket];
    self.saleBadLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.unsalable];
    self.priceLabel.text =[NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalPrice]];
    self.cosPriceLabe.text = model.isboos ? [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.costPrice]]  : @"****";
}
@end
