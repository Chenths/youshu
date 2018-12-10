//
//  HTStaffSaleRankListCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTStaffSaleRankListCell.h"
@interface HTStaffSaleRankListCell()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *saleProductNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *salePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *returnOrderNumberLabel;

@end
@implementation HTStaffSaleRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTStaffSaleRankListModel *)model{
    _model = model;
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.orderNumLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderNumCurrent];
    self.saleProductNumberLabel.text =
    [HTHoldNullObj getValueWithUnCheakValue:model.totalCurrent];
    if ( [model.moneyCurrent isEqualToString:@"总金额"]) {
        self.salePriceLabel.text = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:model.moneyCurrent]];;
    }else{
        self.salePriceLabel.text = [NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue:model.moneyCurrent]];
    }
    self.returnOrderNumberLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderNumRe];
}

@end
