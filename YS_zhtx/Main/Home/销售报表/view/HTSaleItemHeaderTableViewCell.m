//
//  HTSaleItemHeaderTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSaleItemHeaderTableViewCell.h"
#import "HTWarningHoldManager.h"
@implementation HTSaleItemHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)redPointTouchAction:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:self.model.titleStr andWarningValue:self.model.describeStr];
}

- (void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    self.model = dataArr[0];
    self.titleLabel.text = _model.titleStr;
    self.detailLabel.text = [NSString stringWithFormat:@"%@%@%@", _model.perDescribeStr,_model.describeStr, _model.sufDescribeStr];
    self.headerImv.image = [UIImage imageNamed:_model.headerImvName];
    self.redPointBtn.hidden = YES;
    if (_hideRedPoint) {
        return;
    }
    [self holdBt:self.redPointBtn value:_model.describeStr andTitle:_model.titleStr];
}

-(void)holdBt:(UIButton *)bt  value:(NSString *)value andTitle:(NSString *)title{
    if ([title isEqualToString:@"折扣"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.zkl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"连带率"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.ldl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"换货率"] && value.floatValue > [HTShareClass shareClass].reportWarnStandard.hhl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"退货率"] && value.floatValue > [HTShareClass shareClass].reportWarnStandard.thl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"VIP销售占比"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.vipgxl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"VIP新增数"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.AnewMonthVIPNum.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"老VIP成交数"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.MonthlyTurnover4OldVIPNum.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"营业额"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.monthTarget.floatValue){
        bt.hidden = NO;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
