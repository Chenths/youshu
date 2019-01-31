//
//  HTRFMTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/1/28.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTRFMTableViewCell.h"

@implementation HTRFMTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTCustRFMMeaasge *)model{
    _model = model;
    self.left1.text = [HTHoldNullObj getValueWithUnCheakValue:model.days].length == 0 ? @"--" : [NSString stringWithFormat:@"%@天未消费", [HTHoldNullObj getValueWithUnCheakValue:model.days]];

    self.left2.text = [HTHoldNullObj getValueWithUnCheakValue:model.onum].length == 0 ? @"--" : [NSString stringWithFormat:@"%@次", [HTHoldNullObj getValueWithUnCheakValue:model.onum]];
    
    self.left3.text = [HTHoldNullObj getValueWithUnCheakValue:model.amountprice].length == 0 ? @"--" : [NSString stringWithFormat:@"¥%@", [HTHoldNullObj getValueWithUnCheakValue:model.amountprice]];
    
    switch ([model.r integerValue]) {
        case 1:
            self.right1.text = [NSString stringWithFormat:@"沉睡 | 1"];
            break;
        case 2:
            self.right1.text = [NSString stringWithFormat:@"休眠 | 2"];
            break;
        case 3:
            self.right1.text = [NSString stringWithFormat:@"警戒 | 3"];
            break;
        case 4:
            self.right1.text = [NSString stringWithFormat:@"次活跃 | 4"];
            break;
        case 5:
            self.right1.text = [NSString stringWithFormat:@"活跃 | 5"];
            break;
        default:
            self.right1.text = [NSString stringWithFormat:@"无 | --"];
            break;
    }
    
    switch ([model.f integerValue]) {
        case 1:
            self.right2.text = [NSString stringWithFormat:@"超低频 | 1"];
            break;
        case 2:
            self.right2.text = [NSString stringWithFormat:@"低频 | 2"];
            break;
        case 3:
            self.right2.text = [NSString stringWithFormat:@"中频 | 3"];
            break;
        case 4:
            self.right2.text = [NSString stringWithFormat:@"高频 | 4"];
            break;
        case 5:
            self.right2.text = [NSString stringWithFormat:@"超高频 | 5"];
            break;
        default:
            self.right2.text = [NSString stringWithFormat:@"无 | --"];
            break;
    }
    
    switch ([model.m integerValue]) {
        case 1:
            self.right3.text = [NSString stringWithFormat:@"1钻 | 1"];
            break;
        case 2:
            self.right3.text = [NSString stringWithFormat:@"2钻 | 2"];
            break;
        case 3:
            self.right3.text = [NSString stringWithFormat:@"3钻 | 3"];
            break;
        case 4:
            self.right3.text = [NSString stringWithFormat:@"4钻 | 4"];
            break;
        case 5:
            self.right3.text = [NSString stringWithFormat:@"5钻 | 5"];
            break;
        default:
            self.right3.text = [NSString stringWithFormat:@"无 | --"];
            break;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
