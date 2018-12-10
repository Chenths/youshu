//
//  HTBossInfoHeaderCell.m
//  有术
//
//  Created by mac on 2018/4/10.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossInfoHeaderCell.h"

@interface HTBossInfoHeaderCell()

@property (weak, nonatomic) IBOutlet UILabel *moneyProfitLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthSaleNums;
@property (weak, nonatomic) IBOutlet UILabel *monthTotleSaleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *todaySaleProfitLabel;

@property (weak, nonatomic) IBOutlet UIView *firstBackView;
@property (weak, nonatomic) IBOutlet UIView *secondBackView;
@property (weak, nonatomic) IBOutlet UIView *thisrdBackView;
@end

@implementation HTBossInfoHeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.firstBackView.layer.masksToBounds = YES;
    self.firstBackView.layer.cornerRadius = 3;
    self.firstBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.firstBackView.layer.shadowOffset = CGSizeMake(5, 5);
    self.firstBackView.layer.shadowOpacity = 0.18;
    self.firstBackView.layer.shadowRadius = 5;
    self.firstBackView.clipsToBounds = NO;

    
    self.secondBackView.layer.masksToBounds = YES;
    self.secondBackView.layer.cornerRadius = 3;
    self.secondBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.secondBackView.layer.shadowOffset = CGSizeMake(5, 5);
    self.secondBackView.layer.shadowOpacity = 0.18;
    self.secondBackView.layer.shadowRadius = 5;
    self.secondBackView.clipsToBounds = NO;
    
    self.thisrdBackView.layer.masksToBounds = YES;
    self.thisrdBackView.layer.cornerRadius = 3;
    self.thisrdBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.thisrdBackView.layer.shadowOffset = CGSizeMake(5, 5);
    self.thisrdBackView.layer.shadowOpacity = 0.18;
    self.thisrdBackView.layer.shadowRadius = 5;
    self.thisrdBackView.clipsToBounds = NO;
}
- (void)setModel:(HTAgencyMainDataModel *)model{
    _model = model;

    
    self.moneyProfitLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:model.todayProfit] isEqualToString:@"0"]  ? @"无数据" :[HTHoldNullObj getValueWithUnCheakValue:model.todayProfit];
    self.todaySaleLabel.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.todaySalesOrders],[HTHoldNullObj getValueWithUnCheakValue:model.todaySalesNum]];
    
    self.todaySaleMoneyLabel.text = [NSString stringWithFormat:@"￥%@", [HTHoldNullObj getValueWithUnCheakValue:self.model.todaySalesAmount]];
    
}


@end
