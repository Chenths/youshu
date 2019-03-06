//
//  HTWarningDefaulTableCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/21.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTWarningDefaulTableCell.h"
@interface HTWarningDefaulTableCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *holdLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tailLabel;


@end
@implementation HTWarningDefaulTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HTEarlyWarningModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    self.tailLabel.text = [NSString stringWithFormat:@"%@预警", [HTHoldNullObj getValueWithUnCheakValue:model.keyUnit]];
    self.holdLabel.text = [NSString stringWithFormat:@"%@", [HTHoldNullObj getValueWithUnCheakValue:model.bacekey]];
    self.valueLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.keyValue].length == 0 ? @"未添加" : [NSString stringWithFormat:@"%@%@", [HTHoldNullObj getValueWithUnCheakValue:model.preStr],  [HTHoldNullObj getValueWithUnCheakValue:model.keyValue]];
}
@end
