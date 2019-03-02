//
//  HTSaleItemPayKindTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2019/2/26.
//  Copyright © 2019年 有术-新零售. All rights reserved.
//

#import "HTSaleItemPayKindTableViewCell.h"

@implementation HTSaleItemPayKindTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setDataArr:(NSArray *)dataArr{
    _wechatModel = dataArr[0];
    _aliPayModel = dataArr[1];
    _RMBModel = dataArr[2];
    _posModel = dataArr[3];
    
    self.wechatPayLabel.text = [NSString stringWithFormat:@"%@%@%@", _wechatModel.perDescribeStr,_wechatModel.describeStr, _wechatModel.sufDescribeStr];
    self.aliPayLabel.text = [NSString stringWithFormat:@"%@%@%@", _aliPayModel.perDescribeStr,_aliPayModel.describeStr, _aliPayModel.sufDescribeStr];
    self.rmbPayLabel.text = [NSString stringWithFormat:@"%@%@%@", _RMBModel.perDescribeStr,_RMBModel.describeStr, _RMBModel.sufDescribeStr];
    self.posPayLabel.text = [NSString stringWithFormat:@"%@%@%@", _posModel.perDescribeStr,_posModel.describeStr, _posModel.sufDescribeStr];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
