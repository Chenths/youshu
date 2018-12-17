//
//  HTGuiderBaceInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderBaceInfoTableViewCell.h"
@interface HTGuiderBaceInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headimg;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end
@implementation HTGuiderBaceInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTGuiderReportModel *)model{
    _model = model;
    HTGuideReportBaceMsgModel *msg = model.basicMessage;
    self.nameLabel.text = [HTHoldNullObj getValueWithUnCheakValue:msg.name];
    self.phoneLabel.text = [HTHoldNullObj getValueWithUnCheakValue:msg.phone];
    
}

@end
