//
//  HTShopInventoryInfoCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTShopInventoryInfoCell.h"

@interface HTShopInventoryInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *inventoryNumLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleGoodsLabel;

@property (weak, nonatomic) IBOutlet UILabel *saleBadeLabel;

@property (weak, nonatomic) IBOutlet UILabel *inventoryPriceLabel;

@end
@implementation HTShopInventoryInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTCompanyRepotryModel *)model{
    _model = model;
    self.shopNameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.companyName];
    self.inventoryNumLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.crtStock];
    self.saleBadeLabel.text = @"无数据";
    self.saleGoodsLabel.text = @"无数据";
    self.inventoryPriceLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.price].length == 0 ? @"无数据" :[HTHoldNullObj getValueWithUnCheakValue:model.price] ;
}

@end
