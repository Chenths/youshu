//
//  HTChooseDateTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChooseDateTableViewCell.h"
@interface HTChooseDateTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
@implementation HTChooseDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setModel:(HTShopSaleReportModel *)model{
    _model = model;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",model.beginTime,model.endTime];
}
-(void)setReportModel:(HTShopSaleReportModel *)reportModel{
    _reportModel = reportModel;
    self.timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@",reportModel.productBeginTime,reportModel.productEndTime];
}
-(void)setReportDate:(NSString *)reportDate{
    _reportDate = reportDate;
    self.timeLabel.text = [HTHoldNullObj getValueWithUnCheakValue:reportDate];
}
@end
