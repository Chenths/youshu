//
//  HTInventorybasicCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTInventorybasicCell.h"
@interface HTInventorybasicCell()
@property (weak, nonatomic) IBOutlet UILabel *inventoryTotleCount;
@property (weak, nonatomic) IBOutlet UILabel *saleGoodLable;
@property (weak, nonatomic) IBOutlet UILabel *saleBadLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end


@implementation HTInventorybasicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(HTCompanyRepotryModel *)model{
    _model = model;
    self.inventoryTotleCount.text = [HTHoldNullObj getValueWithUnCheakValue:model.crtStock];
    self.saleBadLabel.text = @"无数据";
    self.saleBadLabel.text = @"无数据";
    self.priceLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.price].length == 0 ? @"无数据"  :[HTHoldNullObj getValueWithUnCheakValue:model.price] ;
}
@end
