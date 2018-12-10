//
//  HTLegendTableViewCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossLegendTableViewCell.h"
@interface HTBossLegendTableViewCell()

@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UILabel *categroeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;
@property (weak, nonatomic) IBOutlet UILabel *totleMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;

@end

@implementation HTBossLegendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.colorView.layer.masksToBounds = YES;
    self.colorView.layer.cornerRadius = 8;
    // Initialization code
}
-(void)setModel:(HTPieDataItem *)model{
    _model = model;
    self.colorView.backgroundColor = model.color;
    self.categroeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name];
    
    self.numbersLabel.text = [NSString stringWithFormat:@"%@件",[HTHoldNullObj getValueWithUnCheakValue:model.total]];
    
    self.totleMoneyLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalprice]];
    self.presentLabel.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.data],@"%"];
}

@end
