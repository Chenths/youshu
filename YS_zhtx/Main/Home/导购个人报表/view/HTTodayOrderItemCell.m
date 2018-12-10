//
//  HTTodayOrderItemCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/6.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTOrderOrProductState.h"
#import "HTTodayOrderItemCell.h"

@interface HTTodayOrderItemCell()
@property (weak, nonatomic) IBOutlet UIImageView *orderStateImg;
@property (weak, nonatomic) IBOutlet UILabel *orderStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImg;
@property (weak, nonatomic) IBOutlet UILabel *customerName;
@property (weak, nonatomic) IBOutlet UIImageView *sexImg;
@property (weak, nonatomic) IBOutlet UILabel *custLevel;

@property (weak, nonatomic) IBOutlet UILabel *orderNum;
@property (weak, nonatomic) IBOutlet UILabel *finallPrice;
@property (weak, nonatomic) IBOutlet UILabel *totlePrice;
@property (weak, nonatomic) IBOutlet UILabel *productCount;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *guiderLabel;

@end
@implementation HTTodayOrderItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.custLevel changeCornerRadiusWithRadius:self.custLevel.height / 2];
    [self.custLevel changeBorderStyleColor:[UIColor colorWithHexString:@"#999999"] withWidth:1];
}

-(void)setModel:(HTGuiderDayItmeModel *)model{
    _model = model;
    self.orderNum.text = [NSString stringWithFormat:@"订单号:%@",[HTHoldNullObj getValueWithUnCheakValue:model.ordernum]];
    self.customerName.text = model.customername.length == 0 ? @"散客" :  [HTHoldNullObj getValueWithUnCheakValue:model.customername];
    self.finallPrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.amount]];
    self.totlePrice.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithBigDecmalObj:model.totalprice]];
    self.productCount.text = [NSString stringWithFormat:@"共 %@ 件商品",[HTHoldNullObj getValueWithUnCheakValue:model.volume]];
    self.guiderLabel.text = [NSString stringWithFormat:@"导购:%@",[HTHoldNullObj getValueWithUnCheakValue:model.name]];
    self.createTime.text = [NSString stringWithFormat:@"创建时间:%@",model.createdate];
    if ([[HTOrderOrProductState getOrderStateFormOrderString:model.orderstatus] isEqualToString:@"UNPAID"] || [[HTOrderOrProductState getOrderStateFormOrderString:model.orderstatus] isEqualToString:@"PAID"] ) {
        self.orderStateImg.hidden = YES;
        self.orderStateLabel.hidden = NO;
        self.orderStateLabel.text = [HTHoldNullObj getValueWithUnCheakValue:model.orderstatus];
    }else{
        self.orderStateImg.hidden = NO;
        self.orderStateLabel.hidden = YES;
        self.orderStateImg.image = [UIImage imageNamed:[HTOrderOrProductState getOrderStateFormOrderString:model.orderstatus]];
    }
    self.custLevel.text = [HTHoldNullObj getValueWithUnCheakValue:model.custlevel];
    if ([HTHoldNullObj getValueWithUnCheakValue:model.custlevel].length == 0) {
        self.custLevel.hidden = YES;
    }else{
        self.custLevel.hidden = NO;
    }
    self.sexImg.image  = [model.sex isEqualToString:@"1"] ? [UIImage imageNamed:@"g-man"] : [UIImage imageNamed:@"g-woman"];
    [self.headImg sd_setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:CUSTOMERHOLDIMG]];
}
@end
