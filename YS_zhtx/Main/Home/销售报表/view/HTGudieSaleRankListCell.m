//
//  HTGudieSaleRankListCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGudieSaleRankListCell.h"

@interface HTGudieSaleRankListCell()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *workNum;
@property (weak, nonatomic) IBOutlet UILabel *amountPrice;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end

@implementation HTGudieSaleRankListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTBigOrderModel *)model{
    _model = model;
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",model.index.row + 1];
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.pname];
    self.workNum.text = [NSString stringWithFormat:@"工号：%@",[HTHoldNullObj getValueWithUnCheakValue:model.jobnum]];
    self.amountPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.finalprice]];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.time];
}

@end
