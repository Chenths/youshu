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
@property (weak, nonatomic) IBOutlet UIView *colorView;

@end
@implementation HTChooseBetweenDateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setModel:(HTCustomersInfoReprotModel *)model{
    _model = model;
    NSString *begin = self.index.section == 2 ? self.index.row == 0 ?  model.consumeTimeBegin : model.consumeTimeSecBegin : model.rankTimeBegin;
    if (self.index.section == 2 && self.showColor) {
        _colorView.hidden = NO;
        if (self.index.row == 0) {
            _colorView.backgroundColor = [UIColor colorWithHexString:@"#614DB6"];
        }else{
            _colorView.backgroundColor = [UIColor colorWithHexString:@"#FC5C7D"];
        }
    }else{
        _colorView.hidden = YES;
    }
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
