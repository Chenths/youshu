//
//  HTBossCustomerBasicInfoCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossCustomerBasicInfoCell.h"
@interface HTBossCustomerBasicInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *vipNumbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *todayAddVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *weakVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAddVipLabel;
@property (weak, nonatomic) IBOutlet UILabel *noNameNumsLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthStoredMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthStoredBuyLabel;


@end
@implementation HTBossCustomerBasicInfoCell
- (void)setModel:(HTBossCustomerInfoModel *)model{
    _model = model;
    self.vipNumbersLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.totalCount];
    self.todayAddVipLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.todayTotalCount];
    self.weakVipLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.weekTotalCount];
    self.monthAddVipLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.thisMonthCount];
    self.noNameNumsLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.notNameCustomerCount];
    self.monthStoredMoneyLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.thisMonthAmount];
    self.monthStoredBuyLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.vipConsumeAmount];
    
    
}

@end
