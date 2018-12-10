//
//  HTMESaleInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTMESaleInfoTableViewCell.h"
@interface HTMESaleInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *vipNum;
@property (weak, nonatomic) IBOutlet UILabel *saleRank;
@property (weak, nonatomic) IBOutlet UILabel *vipBack;

@end
@implementation HTMESaleInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTMineModel *)model{
    _model = model;
    self.vipNum.text = [HTHoldNullObj getValueWithUnCheakValue:model.vipCount];
    self.saleRank.text = [HTHoldNullObj getValueWithUnCheakValue:model.performanceRank];
    self.vipBack.text = [HTHoldNullObj getValueWithUnCheakValue:model.vipfollowCount];
}

@end
