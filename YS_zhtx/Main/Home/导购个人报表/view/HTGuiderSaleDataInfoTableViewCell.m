//
//  HTGuiderSaleDataInfoTableViewCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//

#import "HTGuiderSaleDataInfoTableViewCell.h"
@interface HTGuiderSaleDataInfoTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *totalSaleMoney;

@property (weak, nonatomic) IBOutlet UILabel *vipBuy;

@property (weak, nonatomic) IBOutlet UILabel *notVipBuy;

@property (weak, nonatomic) IBOutlet UILabel *rank;

@property (weak, nonatomic) IBOutlet UILabel *dicount;

@property (weak, nonatomic) IBOutlet UILabel *related;

@end

@implementation HTGuiderSaleDataInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(HTGuiderReportModel *)model{
    _model = model;
    HTGuideReportBaceMsgModel *msg = model.basicMessage;
    self.dicount.text = [HTHoldNullObj getValueWithBigDecmalObj:msg.discount];
    self.related.text = [HTHoldNullObj getValueWithBigDecmalObj:msg.serialUP];
    self.rank.text = [HTHoldNullObj getValueWithUnCheakValue:msg.performanceRank];
    self.totalSaleMoney.text = [HTHoldNullObj getValueWithBigDecmalObj:msg.finalPrice];
    self.vipBuy.text = [HTHoldNullObj getValueWithBigDecmalObj:msg.vipAmount];
    self.notVipBuy.text = [HTHoldNullObj getValueWithBigDecmalObj:msg.notVipAmount];
}
@end
