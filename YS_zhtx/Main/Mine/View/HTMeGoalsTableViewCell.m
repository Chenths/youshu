//
//  HTMeGoalsTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMeGoalsTableViewCell.h"
@interface HTMeGoalsTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *todaySaleLabel;
@property (weak, nonatomic) IBOutlet UILabel *monthLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearLabel;

@property (weak, nonatomic) IBOutlet UIImageView *holdImg;

@property (weak, nonatomic) IBOutlet UIImageView *holdImg1;

@property (weak, nonatomic) IBOutlet UIImageView *holdImg2;


@end

@implementation HTMeGoalsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];


}
-(void)setModel:(HTMineModel *)model{
    _model = model;
    self.holdImg.image = [UIImage imageNamed:@"g-mineDown"];
    self.holdImg1.image = [UIImage imageNamed:@"g-mineDown"];
    self.holdImg2.image = [UIImage imageNamed:@"g-mineDown"];
    if (self.descM.isOpen) {
        if (self.descM.selectedGoalstype == HTSelectedGoalsTypeYear) {
         self.holdImg2.image = [UIImage imageNamed:@"g-mineUp"];
        }else if (self.descM.selectedGoalstype == HTSelectedGoalsTypeMonth){
          self.holdImg1.image = [UIImage imageNamed:@"g-mineUp"];
        }else if (self.descM.selectedGoalstype == HTSelectedGoalsTypeToday){
          self.holdImg.image = [UIImage imageNamed:@"g-mineUp"];
        }
    }
    self.todaySaleLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.amount]];
    self.monthLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:model.monthTarget] isEqualToString:@"0"] ? @"无数据" : [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.monthTarget],@"%"];
    self.yearLabel.text = [[HTHoldNullObj getValueWithUnCheakValue:model.monthTarget] isEqualToString:@"0"] ? @"无数据" : [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.yearTarget],@"%"];
}
- (IBAction)saleBtClicked:(id)sender {
 
    if (self.delegate) {
        [self.delegate todayGoalClicked];
    }
}
- (IBAction)monthClicked:(id)sender {
    if (self.delegate) {
        [self.delegate monthGoalClicked];
    }
}
- (IBAction)yearClicked:(id)sender {
    if (self.delegate) {
        [self.delegate yaerGoalClicked];
    }
}


@end
