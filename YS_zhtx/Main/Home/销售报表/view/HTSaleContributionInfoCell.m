//
//  HTSaleContributionInfoCell.m
//  YS_zhtx
//
//  Created by mac on 2018/6/13.
//  Copyright © 2018年 有术-新零售. All rights reserved.
//  销售贡献报表

#import "HTSaleContributionInfoCell.h"
#import "HTRatioSliderView.h"
@interface HTSaleContributionInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *saleAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *vipPresent;
@property (weak, nonatomic) IBOutlet UILabel *notVipPrensent;

@property (nonatomic,strong) HTRatioSliderView *sliderView;

@end

@implementation HTSaleContributionInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

-(void)initSubs{
    [self createSiler];
}
-(void)createSiler{
    HTRatioSliderView *v = [[HTRatioSliderView alloc] initWithFrame:CGRectMake(16, self.vipPresent.y + self.vipPresent.height + 7, HMSCREENWIDTH - 32, 7)];
    [self.contentView addSubview:v];
}
-(void)setModel:(EmployeeContributionModel *)model{
    _model = model;
    [self.sliderView removeFromSuperview];
    self.saleAmountLabel.text = [HTHoldNullObj getValueWithBigDecmalObj:model.sale];
    self.vipPresent.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.vipsalescale],@"%"];
    self.notVipPrensent.text = [NSString stringWithFormat:@"%@%@",[HTHoldNullObj getValueWithBigDecmalObj:model.notvipsalescale],@"%"];
    self.sliderView = [[HTRatioSliderView alloc] initWithFrame:CGRectMake(16, self.vipPresent.y + self.vipPresent.height + 7, HMSCREENWIDTH - 32, 7) withDatas:@[[HTHoldNullObj getValueWithBigDecmalObj:model.vipsalescale],[HTHoldNullObj getValueWithBigDecmalObj:model.notvipsalescale]] andColors:@[@"#614DB6",@"#FC5C7D"]];
    [self addSubview:self.sliderView];
}
@end
