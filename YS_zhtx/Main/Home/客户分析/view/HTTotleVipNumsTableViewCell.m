//
//  HTTotleVipNumsTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTTotleVipNumsTableViewCell.h"
@interface HTTotleVipNumsTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *totelLabel;

@end
@implementation HTTotleVipNumsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HTCustomersInfoReprotModel *)model{
    _model = model;
    self.totelLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.totalCount];
}

@end
