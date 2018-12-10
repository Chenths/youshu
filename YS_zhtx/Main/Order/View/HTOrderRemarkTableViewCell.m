//
//  HTOrderRemarkTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/22.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTOrderRemarkTableViewCell.h"
@interface HTOrderRemarkTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
@implementation HTOrderRemarkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.titleLabel changeCornerRadiusWithRadius:self.titleLabel.height * 0.5];
    self.descLabel.text = @"备注信息备注信息备注信息备注信息备注信息备注信息备注信息备.信息备注信息备注信息备注信息备";
}
-(void)setModel:(HTOrderDetailModel *)model{
    _model = model;
    self.descLabel.text = model.remark.length == 0 ? @"无" : model.remark;
}


@end
