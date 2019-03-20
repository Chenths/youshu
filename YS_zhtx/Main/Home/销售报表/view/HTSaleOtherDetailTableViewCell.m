//
//  HTSaleOtherDetailTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSaleOtherDetailTableViewCell.h"
#import "HTWarningHoldManager.h"
@implementation HTSaleOtherDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//@property (weak, nonatomic) IBOutlet UIImageView *leftImv;
//@property (weak, nonatomic) IBOutlet UIImageView *rightImv;
//@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
//@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
//@property (weak, nonatomic) IBOutlet UILabel *leftDetailLabel;
//@property (weak, nonatomic) IBOutlet UILabel *rightDetailLabel;
//@property (weak, nonatomic) IBOutlet UIButton *leftRedBtn;
//@property (weak, nonatomic) IBOutlet UIButton *rightRedBtn;
- (IBAction)leftRedAction:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:self.leftModel.titleStr andWarningValue:self.leftModel.describeStr];
}


- (IBAction)rightRedAction:(id)sender {
    [HTWarningHoldManager holdWarningWithTitle:self.rightModel.titleStr andWarningValue:self.rightModel.describeStr];
}

- (void)setDataArr:(NSArray *)dataArr{
    if (dataArr.count == 1) {
        _leftModel = dataArr[0];
        self.leftLabel.text = _leftModel.titleStr;
        if ([_leftModel.titleStr containsString:@"数量"] || [_leftModel.titleStr containsString:@"新增标签"] || [_leftModel.titleStr containsString:@"新增会员"] || [_leftModel.titleStr containsString:@"成交人数"]) {
            self.leftDetailLabel.text = [NSString stringWithFormat:@"%@%ld%@", _leftModel.perDescribeStr,[_leftModel.describeStr integerValue], _leftModel.sufDescribeStr];
        }else{
            self.leftDetailLabel.text = [NSString stringWithFormat:@"%@%@%@", _leftModel.perDescribeStr,_leftModel.describeStr, _leftModel.sufDescribeStr];
        }
        self.leftImv.image = [UIImage imageNamed:_leftModel.headerImvName];
        self.leftRedBtn.hidden = YES;
        
        self.rightLabel.hidden = YES;
        self.rightDetailLabel.hidden = YES;
        self.rightImv.hidden = YES;
        if (_hideRedPoint) {
            return;
        }
        [self holdBt:self.leftRedBtn value:_leftModel.describeStr andTitle:_leftModel.titleStr];
        
    }else{
        _leftModel = dataArr[0];
        self.leftLabel.text = _leftModel.titleStr;
        if ([_leftModel.titleStr containsString:@"数量"] || [_leftModel.titleStr containsString:@"新增标签"] || [_leftModel.titleStr containsString:@"新增会员"] || [_leftModel.titleStr containsString:@"成交人数"]) {
            self.leftDetailLabel.text = [NSString stringWithFormat:@"%@%ld%@", _leftModel.perDescribeStr,[_leftModel.describeStr integerValue], _leftModel.sufDescribeStr];
        }else{
            self.leftDetailLabel.text = [NSString stringWithFormat:@"%@%@%@", _leftModel.perDescribeStr,_leftModel.describeStr, _leftModel.sufDescribeStr];
        }
        self.leftImv.image = [UIImage imageNamed:_leftModel.headerImvName];
        self.leftRedBtn.hidden = YES;
        
        
        self.rightLabel.hidden = NO;
        self.rightDetailLabel.hidden = NO;
        self.rightImv.hidden = NO;
        
        _rightModel = dataArr[1];
        self.rightLabel.text = _rightModel.titleStr;
        if ([_rightModel.titleStr containsString:@"数量"] || [_rightModel.titleStr containsString:@"新增标签"] || [_rightModel.titleStr containsString:@"新增会员"] || [_rightModel.titleStr containsString:@"成交人数"]) {
            self.rightDetailLabel.text = [NSString stringWithFormat:@"%@%ld%@", _rightModel.perDescribeStr,[_rightModel.describeStr integerValue], _rightModel.sufDescribeStr];
        }else{
            self.rightDetailLabel.text = [NSString stringWithFormat:@"%@%@%@", _rightModel.perDescribeStr,_rightModel.describeStr, _rightModel.sufDescribeStr];
        }
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
    if ([title isEqualToString:@"销售额 (元)"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.monthTarget.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"折扣率"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.zkl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"单量"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.dl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"销量 (件)"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.xl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"客单价"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.kdj.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"新增会员"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.AnewMonthVIPNum.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"会员成交人数"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.MonthlyTurnover4OldVIPNum.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"会员贡献率"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.vipgxl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"回头率"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.hyhtl.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"活跃会员占比"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.hyvip.floatValue) {
        bt.hidden = NO;
    }else if ([title isEqualToString:@"连带率"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.ldl.floatValue){
        bt.hidden = NO;
    }
//    else if ([title isEqualToString:@"换货率"] && value.floatValue > [HTShareClass shareClass].reportWarnStandard.hhl.floatValue){
//        bt.hidden = NO;
//    }else if ([title isEqualToString:@"退货率"] && value.floatValue > [HTShareClass shareClass].reportWarnStandard.thl.floatValue){
//        bt.hidden = NO;
//    }
    else if ([title isEqualToString:@"VIP销售占比"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.vipgxl.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"VIP新增数"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.AnewMonthVIPNum.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"老VIP成交数"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.MonthlyTurnover4OldVIPNum.floatValue){
        bt.hidden = NO;
    }else if ([title isEqualToString:@"营业额"] && value.floatValue < [HTShareClass shareClass].reportWarnStandard.monthTarget.floatValue){
        bt.hidden = NO;
    }
}
@end
