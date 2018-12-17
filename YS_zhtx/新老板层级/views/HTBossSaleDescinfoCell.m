//
//  HTBossSaleDescinfoCell.m
//  有术
//
//  Created by mac on 2018/5/21.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossSaleDescinfoCell.h"

@interface HTBossSaleDescinfoCell ()

@property (weak, nonatomic) IBOutlet UIView *firstBackView;
@property (weak, nonatomic) IBOutlet UIView *secondBackView;
@property (weak, nonatomic) IBOutlet UIView *thisrdBackView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *title1;
@property (weak, nonatomic) IBOutlet UILabel *value1;

@property (weak, nonatomic) IBOutlet UILabel *title2;
@property (weak, nonatomic) IBOutlet UILabel *value2;

@property (weak, nonatomic) IBOutlet UILabel *title3;
@property (weak, nonatomic) IBOutlet UILabel *value3;


@end

@implementation HTBossSaleDescinfoCell

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

-(void)setModel:(HTAgencyMainDataModel *)model{
    _model = model;
    if ([self.title isEqualToString:@"本月"]) {
        self.titleLabel.text = @"本月销售";
        self.title1.text = @"本月销量";
        self.title2.text = @"本月销额";
        self.title3.text = @"本月利润";
        self.value1.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.salesOrders],[HTHoldNullObj getValueWithUnCheakValue:model.salesNum]];
        self.value2.text = [NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.salesAmount]];
        self.value3.text = [[HTHoldNullObj getValueWithUnCheakValue:model.totalProfit] isEqualToString:@"0"]  ? @"无数据" :[NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.totalProfit]];
    }else{
        self.titleLabel.text = @"本年销售";
        self.title1.text = @"本年销量";
        self.title2.text = @"本年销额";
        self.title3.text = @"本年利润";
        self.value1.text = [NSString stringWithFormat:@"%@单%@件",[HTHoldNullObj getValueWithUnCheakValue:model.yearSalesOrders],[HTHoldNullObj getValueWithUnCheakValue:model.yearSalesNum]];
        self.value2.text = [NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.yearSalesAmount]];
        self.value3.text = [[HTHoldNullObj getValueWithUnCheakValue:model.yearProfit] isEqualToString:@"0"]  ? @"无数据" :[NSString stringWithFormat:@"￥%@",[HTHoldNullObj getValueWithUnCheakValue:model.yearProfit]];
    }
}

@end
