//
//  HTEditVipContinueBackListCell.m
//  YS_zhtx
//
//  Created by mac on 2018/8/28.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTEditVipContinueBackListCell.h"
@interface HTEditVipContinueBackListCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLable;

@end
@implementation HTEditVipContinueBackListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTContinueBackModel *)model{
    _model = model;
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.name].length == 0 ? [HTHoldNullObj getValueWithUnCheakValue:model.create_name].length == 0 ? @"暂无称呼" : [HTHoldNullObj getValueWithUnCheakValue:model.create_name]: [HTHoldNullObj getValueWithUnCheakValue:model.name];
    self.dateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.date];
    self.descLable.text = [HTHoldNullObj getValueWithUnCheakValue:model.desc];
}
- (IBAction)deleteDescClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteContinueBackWithCell:)]) {
        [self.delegate deleteContinueBackWithCell:self];
    }
    
}


@end
