//
//  HTCustomersReportBaceInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTCustomersReportBaceInfoCell.h"

@interface HTCustomersReportBaceInfoCell()

@property (weak, nonatomic) IBOutlet UILabel *todayAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *weakAddLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthAddLabel;

@property (weak, nonatomic) IBOutlet UILabel *notNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthStoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipBuyLabel;

@end

@implementation HTCustomersReportBaceInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTCustomersInfoReprotModel *)model{
    _model = model;
    self.todayAddLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.todayCount];
    self.weakAddLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.thisWeekCount];
    self.monthAddLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.thisMonthCount];
    
    self.notNameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.notNameCustomerCount];
    self.monthStoreLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.thisMonthAmount];
    self.vipBuyLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.vipConsumeAmount];
}

@end
