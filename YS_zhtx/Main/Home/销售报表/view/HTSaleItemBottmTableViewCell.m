//
//  HTSaleItemBottmTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSaleItemBottmTableViewCell.h"
#import "HTWarningHoldManager.h"
@implementation HTSaleItemBottmTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataArr:(NSArray *)dataArr{
    if (dataArr.count == 1) {
        _leftModel = dataArr[0];
        self.leftTopLabel.text = _leftModel.titleStr;
        self.leftBottomLabel.text = [NSString stringWithFormat:@"%@%@%@", _leftModel.perDescribeStr,_leftModel.describeStr, _leftModel.sufDescribeStr];
        self.leftBottomImv.hidden = YES;
        self.leftBtn.hidden = YES;
        
        self.rightTopLabel.hidden = YES;
        self.rightBottomLabel.hidden = YES;
        self.rightBottomImv.hidden = YES;
        
    }else{
        _leftModel = dataArr[0];
        self.leftTopLabel.text = _leftModel.titleStr;
        self.leftBottomLabel.text = [NSString stringWithFormat:@"%@%@%@", _leftModel.perDescribeStr,_leftModel.describeStr, _leftModel.sufDescribeStr];
        
        _rightModel = dataArr[1];
        self.rightTopLabel.text = _rightModel.titleStr;
        self.rightBottomLabel.text = [NSString stringWithFormat:@"%@%@%@", _rightModel.perDescribeStr,_rightModel.describeStr, _rightModel.sufDescribeStr];
        
        self.rightTopLabel.hidden = NO;
        self.rightBottomLabel.hidden = NO;
        self.rightBottomImv.hidden = NO;
        
        //判断是不是展示支付种类的上一层 消费 充值金额
        if (_ifShowDownImv) {
            self.leftBottomImv.hidden = NO;
            self.leftBtn.hidden = NO;
            self.rightBottomImv.hidden = NO;
            self.rightBtn.hidden = NO;
            if (_currentSelectShowPayKindType == 0) {
                self.leftBottomImv.image = [UIImage imageNamed:@"bDown"];
                self.rightBottomImv.image = [UIImage imageNamed:@"bDown"];
            }else if (_currentSelectShowPayKindType == 1){
                self.leftBottomImv.image = [UIImage imageNamed:@"bUp"];
                self.rightBottomImv.image = [UIImage imageNamed:@"bDown"];
            }else{
                self.leftBottomImv.image = [UIImage imageNamed:@"bDown"];
                self.rightBottomImv.image = [UIImage imageNamed:@"bUp"];
            }
        }else{
            self.leftBottomImv.hidden = YES;
            self.leftBtn.hidden = YES;
            self.rightBottomImv.hidden = YES;
            self.rightBtn.hidden = YES;
        }
    }
}

- (IBAction)showTouchChangePayKindLeftAction:(id)sender {
    NSLog(@"点击左侧展示支付详情");
    if (self.delegate) {
        [self.delegate selectChooseShowPayKindType:0];
    }
}
- (IBAction)showTouchCHangePayKindRightAction:(id)sender {
    NSLog(@"点击右侧展示支付详情");
    if (self.delegate) {
        [self.delegate selectChooseShowPayKindType:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
