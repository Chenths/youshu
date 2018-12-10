//
//  HTStoredMoneyCollectionCell.m
//  有术
//
//  Created by mac on 2018/1/2.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTStoredMoneyCollectionCell.h"

@interface HTStoredMoneyCollectionCell()
@property (weak, nonatomic) IBOutlet UILabel *storedMoneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *sendStoredMoneyLabel;


@end


@implementation HTStoredMoneyCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(HTStoredSendModel *)model{
    _model = model;
    
    self.storedMoneyLabel.text = [NSString stringWithFormat:@"充%@元",model.money];
    self.sendStoredMoneyLabel.text = [NSString stringWithFormat:@"送%@元",model.send];
}

@end
