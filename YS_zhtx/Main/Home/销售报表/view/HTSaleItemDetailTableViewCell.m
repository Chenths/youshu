//
//  HTSaleItemDetailTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSaleItemDetailTableViewCell.h"
#import "HTWarningHoldManager.h"
@implementation HTSaleItemDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)leftRedTouchAction:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:self.leftModel.titleStr andWarningValue:self.leftModel.describeStr];
}
- (IBAction)rightRedTouchAction:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:self.rightModel.titleStr andWarningValue:self.rightModel.describeStr];
}

- (void)setDataArr:(NSArray *)dataArr{
    if (dataArr.count == 1) {
        _leftModel = dataArr[0];
        self.leftTitle.text = _leftModel.titleStr;
        self.leftDetail.text = [NSString stringWithFormat:@"%@%@%@", _leftModel.perDescribeStr,_leftModel.describeStr, _leftModel.sufDescribeStr];
        self.leftImv.image = [UIImage imageNamed:_leftModel.headerImvName];
        self.leftRedBtn.hidden = YES;
        
        
        self.rightImv.hidden = YES;
        self.rightTitle.hidden = YES;
        self.rightDetail.hidden = YES;
        self.rightRedBtn.hidden = YES;
        
        if (_hideRedPoint) {
            return;
        }
        [self holdBt:self.leftRedBtn value:_leftModel.describeStr andTitle:_leftModel.titleStr];
    }else{
        
        _leftModel = dataArr[0];
        self.leftTitle.text = _leftModel.titleStr;
        self.leftDetail.text = [NSString stringWithFormat:@"%@%@%@", _leftModel.perDescribeStr,_leftModel.describeStr, _leftModel.sufDescribeStr];
        self.leftImv.image = [UIImage imageNamed:_leftModel.headerImvName];
        self.leftRedBtn.hidden = YES;
        
        self.rightImv.hidden = NO;
        self.rightTitle.hidden = NO;
        self.rightDetail.hidden = NO;
        self.rightRedBtn.hidden = NO;
        
        _rightModel = dataArr[1];
        self.rightTitle.text = _rightModel.titleStr;
        self.rightDetail.text = [NSString stringWithFormat:@"%@%@%@", _rightModel.perDescribeStr,_rightModel.describeStr, _rightModel.sufDescribeStr];
        self.rightImv.image = [UIImage imageNamed:_rightModel.headerImvName];
        self.rightRedBtn.hidden = YES;
        
        if (_hideRedPoint) {
            return;
        }
        [self holdBt:self.leftRedBtn value:_leftModel.describeStr andTitle:_leftModel.titleStr];
        [self holdBt:self.rightRedBtn value:_rightModel.describeStr andTitle:_rightModel.titleStr];
    }
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
