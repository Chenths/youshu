//
//  HTChooseBetweenDateCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTChooseBetweenDateCell.h"
@interface HTChooseBetweenDateCell()

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end
@implementation HTChooseBetweenDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTCustomersInfoReprotModel *)model{
    _model = model;
    NSString *begin = self.index.section == 2 ? self.index.row == 0 ?  model.consumeTimeBegin : model.consumeTimeSecBegin : model.rankTimeBegin;
    NSString *end = self.index.section == 2 ? self.index.row == 0 ?  model.consumeTimeEnd : model.consumeTimeSecEnd : model.rankTimeEnd;
    self.descLabel.text = [NSString stringWithFormat:@"%@ 至 %@",begin,end];
}
-(void)setReportModel:(HTShopSaleReportModel *)reportModel{
    _reportModel = reportModel;
    NSString *begin = reportModel.productBeginTime;
    NSString *end = reportModel.productEndTime;
    self.descLabel.text = [NSString stringWithFormat:@"%@ 至 %@",begin,end];
}

@end
