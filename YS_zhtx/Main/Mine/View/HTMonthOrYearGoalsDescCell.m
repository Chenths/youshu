//
//  HTMonthOrYearGoalsDescCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMonthOrYearGoalsDescCell.h"
@interface HTMonthOrYearGoalsDescCell()

@property (weak, nonatomic) IBOutlet UILabel *amount;

@property (weak, nonatomic) IBOutlet UILabel *title;

@end
@implementation HTMonthOrYearGoalsDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTMineModel *)model{
    _model = model;
    if (self.descM.selectedGoalstype == HTSelectedGoalsTypeYear) {
        self.title.text = @"年目标：";
        self.amount.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue:model.monthRate]];
    }
    if (self.descM.selectedGoalstype == HTSelectedGoalsTypeMonth) {
        self.title.text = @"月目标：";
        self.amount.text = [NSString stringWithFormat:@"%@",[HTHoldNullObj getValueWithUnCheakValue:model.monthRate]];
    }
    
   
    
}
@end
