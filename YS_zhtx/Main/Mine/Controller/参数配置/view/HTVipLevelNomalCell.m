//
//  HTVipLevelNomalCell.m
//  有术
//
//  Created by mac on 2017/7/12.
//  Copyright © 2017年 zhtxwl_hx. All rights reserved.
//

#import "HTVipLevelNomalCell.h"

@interface HTVipLevelNomalCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *lowValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *lowUnitLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightValueLabel;

@property (weak, nonatomic) IBOutlet UILabel *heightUnitLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;

@property (weak, nonatomic) IBOutlet UILabel *topLable;


@end

@implementation HTVipLevelNomalCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.topLable.hidden = YES;
}
- (void)setModel:(HTVipLevelSeterModel *)model{
    _model = model;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.title];
    self.lowValueLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.lowValue];
    self.lowUnitLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.units];
    self.heightUnitLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.units];
    self.heightValueLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.heightValue];
}
-(void)setIsLast:(BOOL)isLast{
    _isLast = isLast;
    if (isLast) {
        self.heightValueLabel.hidden = YES;
        self.heightUnitLabel.hidden = YES;
        self.lineView.hidden = YES;
        self.topLable.hidden = NO;

    }else{
        self.heightValueLabel.hidden = NO;
        self.heightUnitLabel.hidden = NO;
        self.lineView.hidden = NO;
        self.topLable.hidden = YES;
        
    }
}
@end
