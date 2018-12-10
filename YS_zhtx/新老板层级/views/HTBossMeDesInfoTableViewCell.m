//
//  HTBossMeDesInfoTableViewCell.m
//  有术
//
//  Created by mac on 2018/4/28.
//  Copyright © 2018年 zhtxwl_hx. All rights reserved.
//

#import "HTBossMeDesInfoTableViewCell.h"
@interface HTBossMeDesInfoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *shopNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopClerkLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipLabel;



@end
@implementation HTBossMeDesInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.shopNumLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].bossData.companycount].length == 0 ? @"无数据"  :  [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].bossData.companycount];
    self.shopClerkLabel.text = [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].bossData.employeecount].length == 0 ? @"无数据" : [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].bossData.employeecount] ;
    self.vipLabel.text =  [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].bossData.vipcount].length == 0 ? @"无数据" : [HTHoldNullObj getValueWithUnCheakValue:[HTShareClass shareClass].bossData.vipcount] ;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
