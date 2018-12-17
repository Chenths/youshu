//
//  HTBossVipFrequencyCell.m
//  有术
//
//  Created by mac on 2018/4/16.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossVipFrequencyCell.h"

@interface HTBossVipFrequencyCell()
@property (weak, nonatomic) IBOutlet UILabel *numbersLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightWidth;
@property (weak, nonatomic) IBOutlet UIView *planView;
@property (weak, nonatomic) IBOutlet UILabel *countTitle;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadingWidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tralling;

@end
@implementation HTBossVipFrequencyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.planView.layer.masksToBounds = YES;
    self.planView.layer.cornerRadius = 15;
    // Initialization code
}
- (void)setModel:(HTBossVipFrequencyModel *)model{
    _model = model;
    if (self.isNeeaLeft) {
        self.leadingWidth.constant = 0.0f;
        self.tralling.constant = 0.0f;
        self.titleWidth.constant = 0.0f;
        self.numbersLabel.hidden = YES;
    }else{
        self.leadingWidth.constant = 15.0f;
        self.tralling.constant = 15.0f;
        self.titleWidth.constant = 65.0f;
        self.numbersLabel.hidden = NO;
    }
    CGFloat width =  self.isNeeaLeft ? self.width - 15  : HMSCREENWIDTH - 65 - 30 - 15;
    self.numbersLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.key];
    if (model.color) {
        self.planView.backgroundColor = model.color;
    }
    self.rightWidth.constant = model.maxVal.floatValue == 0 ? width + 15 :( width - (width * model.val.floatValue / model.maxVal.floatValue == width ? width :  (width * model.val.floatValue / model.maxVal.floatValue + 15) ) + 15);
    CGFloat width1 = [[NSString stringWithFormat:@"%@",model.val] boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:0 attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.width + 5;
    if (model.maxVal.floatValue == 0) {
        self.countTitle.textColor = [UIColor blackColor];
          self.countTitle.text = [HTHoldNullObj getValueWithUnCheakValue:model.val];
        return;
    }
    if (width * model.val.floatValue / model.maxVal.floatValue - 8 >= width1) {
        self.countTitle.textColor = [UIColor whiteColor];
    }else{
        self.countTitle.textColor = [UIColor blackColor];
    }
    self.countTitle.text = [HTHoldNullObj getValueWithUnCheakValue:model.val];
}
- (void)setIsNeeaLeft:(BOOL)isNeeaLeft{
    _isNeeaLeft = isNeeaLeft;
    if (isNeeaLeft) {
        self.leadingWidth.constant = 0.0f;
        self.tralling.constant = 0.0f;
        self.titleWidth.constant = 0.0f;
        self.numbersLabel.hidden = YES;
    }else{
        self.leadingWidth.constant = 15.0f;
        self.tralling.constant = 15.0f;
        self.titleWidth.constant = 65.0f;
        self.numbersLabel.hidden = NO;
    }
}
@end
