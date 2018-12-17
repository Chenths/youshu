//
//  HTMonthSaleDescTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMonthSaleDescTableViewCell.h"
@interface HTMonthSaleDescTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *weakDay;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *detailTime;
@property (weak, nonatomic) IBOutlet UILabel *saleCount;
@property (weak, nonatomic) IBOutlet UILabel *totalPrice;
@property (weak, nonatomic) IBOutlet UILabel *saleAmount;

@end
@implementation HTMonthSaleDescTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)setModel:(HTGuiderMonthIterModel *)model{
    _model = model;
    self.weakDay.text = [HTHoldNullObj getValueWithUnCheakValue:model.weekName];
    if (model.date.length >= 10) {
        self.dateLabel.text = [model.date substringWithRange:NSMakeRange(5, 5)];
    }
    self.saleCount.text = [NSString stringWithFormat:@"%@单%@件", [HTHoldNullObj getValueWithUnCheakValue:model.count],[HTHoldNullObj getValueWithUnCheakValue:model.volume]];
    
    NSMutableAttributedString * mAttribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalPrice]]];
    [mAttribute addAttribute:NSStrikethroughStyleAttributeName
                       value:@(NSUnderlineStyleSingle)
                       range:NSMakeRange(0, [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalPrice]].length)];
    self.totalPrice.attributedText = mAttribute  ;
    self.saleAmount.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.amount]];
}

@end
