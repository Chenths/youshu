//
//  HTInventoryDescInfoCollectionCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//
#import "HTRatioSliderView.h"
#import "HTInventoryDescInfoCollectionCell.h"
@interface HTInventoryDescInfoCollectionCell()

@property (weak, nonatomic) IBOutlet UIView *holdView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *presentLabel;


@end

@implementation HTInventoryDescInfoCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.holdView changeCornerRadiusWithRadius:8];
    [self createSiler];
}
-(void)createSiler{
    HTRatioSliderView *v = [[HTRatioSliderView alloc] initWithFrame:CGRectMake(16, self.presentLabel.y + 16 + 20 , self.width , 3)];
    [self.contentView addSubview:v];
}
-(void)setModel:(HTPieDataItem *)model{
    _model = model;
    self.holdView.backgroundColor = model.color;
    self.titleLabel.text = [HTHoldNullObj getValueWithUnCheakValue: model.name];
    self.countLabel.text = [NSString stringWithFormat:@"%@件",[HTHoldNullObj getValueWithUnCheakValue:model.total]];
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",[HTHoldNullObj getValueWithUnCheakValue:model.finalprice]];
    self.presentLabel.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithUnCheakValue:model.data],@"%"];
}
@end
